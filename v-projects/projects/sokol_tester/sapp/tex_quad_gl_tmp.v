import via.libs.sokol
import prime31.sokol.sapp
import via.libs.sokol.gfx
import prime31.stb.image
import via.math
import graphics
import rand

struct AppState {
mut:
	pip sg_pipeline
	bind sg_bindings
	pass_action sg_pass_action
	rx f32
	ry f32
	trans_mat math.Mat44

	checker_img C.sg_image
	beach_img C.sg_image

	mesh &graphics.Mesh
}

fn main() {
	state := &AppState{
		pass_action: gfx.create_clear_pass(0.3, 0.3, 1.0, 1.0)
	}

	sapp_run(&sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		event_userdata_cb: on_event
		cleanup_cb: cleanup
		window_title: 'Textured Cube'.str
	})
}

fn init(user_data voidptr) {
	mut state := &AppState(user_data)

	sg_setup(&sg_desc {
		mtl_device: C.sapp_metal_get_device()
		mtl_renderpass_descriptor_cb: sapp_metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp_metal_get_drawable
		d3d11_device: sapp_d3d11_get_device()
		d3d11_device_context: sapp_d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp_d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp_d3d11_get_depth_stencil_view
	})

	mut verts := [
		graphics.Vertex{ math.Vec2{-1,-1}, 	math.Vec2{0,0},		math.Color{} },
		graphics.Vertex{ math.Vec2{1,-1}, 	math.Vec2{1,0},		math.Color{} },
		graphics.Vertex{ math.Vec2{1,1}, 	math.Vec2{1,1},		math.Color{} },
		graphics.Vertex{ math.Vec2{-1,1}, 	math.Vec2{0,1},		math.Color{0xff0000ff} }
	]!
	indices := [u16(0), 1, 2, 0, 2, 3]!
	state.bind = graphics.bindings_create(verts, .immutable, indices, .immutable)

	state.bind.fs_images[0] = create_image()
	state.pip = graphics.pipeline_make_default()

	state.beach_img = state.bind.fs_images[0]
	state.checker_img = create_checker_image()

	// view-projection matrix
	state.trans_mat = math.mat44_ortho2d(-2, 2, 2, -2)

	for i, _ in verts {
		verts[i].pos.x -= 1
		verts[i].pos.y -= 1
	}
	state.mesh = graphics.mesh_create_dynamic(verts, .dynamic, indices, .dynamic)
	state.mesh.bind_image(state.checker_img, 0)
}

fn create_image() C.sg_image {
	img := image.load('assets/beach.png')
	mut img_desc := sg_image_desc{
		width: img.width
		height: img.height
		pixel_format: .rgba8
		min_filter: .nearest
		mag_filter: .nearest
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: img.data
		size: sizeof(u32) * img.width * img.height
    }

    sg_img := sg_make_image(&img_desc)
	img.free()
	return sg_img
}

fn create_checker_image() C.sg_image {
	/* create a checkerboard texture */
    pixels := [
        u32(0xFFFFFFFF), 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
        0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
        0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
	]!

	mut img_desc := sg_image_desc{
		width: 4
		height: 4
		pixel_format: .rgba8
		min_filter: .nearest
		mag_filter: .nearest
		wrap_u: .clamp_to_edge
		wrap_v: .clamp_to_edge
	}
	img_desc.content.subimage[0][0] = sg_subimage_content{
		ptr: pixels.data
		size: sizeof(u32) * pixels.len
    }

    return C.sg_make_image(&img_desc)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)

	sg_apply_bindings(&state.bind)
	sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &state.trans_mat, sizeof(math.Mat44))
	sg_draw(0, 6, 1)

	for i, _ in state.mesh.verts {
		state.mesh.verts[i].pos.x += math.rand_between(-0.01, 0.01)
		state.mesh.verts[i].pos.y += math.rand_between(-0.01, 0.01)
	}
	state.mesh.update_verts()

	state.mesh.apply_bindings()
	state.mesh.apply_uniforms(.vs, 0, &state.trans_mat, sizeof(math.Mat44))
	state.mesh.draw()

	sg_end_pass()
	sg_commit()
}

fn on_event(evt &C.sapp_event, user_data voidptr) {
	if evt.@type == .key_down {
		match evt.key_code {
			.f {
				mut state := &AppState(user_data)
				state.bind.fs_images[0] = state.beach_img
			}
			.g {
				mut state := &AppState(user_data)
				state.bind.fs_images[0] = state.checker_img
			}
			else {}
		}
	}
}

fn cleanup() {}