import prime31.sokol
import prime31.sokol.sapp
import prime31.sokol.gfx

#flag -I.

#define HANDMADE_MATH_IMPLEMENTATION
#include "HandmadeMath.h"

fn C.HMM_Perspective(FOV f32, AspectRatio f32, Near f32, Far f32) C.hmm_mat4
fn C.HMM_LookAt() C.hmm_mat4
fn C.HMM_MultiplyMat4() C.hmm_mat4
fn C.HMM_Rotate() C.hmm_mat4
fn C.HMM_Vec3() C.hmm_vec3

const (
	vert = '#include <metal_stdlib>
using namespace metal;
struct params_t {
	float4x4 mvp;
};
struct vs_in {
  float4 position [[attribute(0)]];
  float4 color [[attribute(1)]];
};
struct vs_out {
  float4 position [[position]];
  float4 color;
};
vertex vs_out _main(vs_in inp [[stage_in]], constant params_t& params [[buffer(0)]]) {
  vs_out outp;
  outp.position = params.mvp * inp.position;
  outp.color = inp.color;
  return outp;
}'
	frag = '#include <metal_stdlib>
using namespace metal;
fragment float4 _main(float4 color [[stage_in]]) {
  return color;
};'
)

struct AppState {
mut:
	pip sg_pipeline
	bind sg_bindings
	pass_action sg_pass_action
	rx f32
	ry f32
	view_proj C.hmm_mat4
}

struct VsParams {
    mvp C.hmm_mat4
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 0.3
	color_action.val[1] = 0.3

	mut pass_action := sg_pass_action{}
	pass_action.colors[0] = color_action

	state := &AppState{
		pass_action: pass_action
	}

	sapp_run(&sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		cleanup_cb: cleanup
		window_title: 'Word up sapp'.str
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

	verts := [
		-1.0, -1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
         1.0, -1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.0, 1.0,
        -1.0,  1.0, -1.0,   1.0, 0.0, 0.0, 1.0,

        -1.0, -1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
         1.0, -1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
         1.0,  1.0,  1.0,   0.0, 1.0, 0.0, 1.0,
        -1.0,  1.0,  1.0,   0.0, 1.0, 0.0, 1.0,

        -1.0, -1.0, -1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0,  1.0, -1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0,  1.0,  1.0,   0.0, 0.0, 1.0, 1.0,
        -1.0, -1.0,  1.0,   0.0, 0.0, 1.0, 1.0,

        1.0, -1.0, -1.0,   1.0, 0.5, 0.0, 1.0,
        1.0,  1.0, -1.0,   1.0, 0.5, 0.0, 1.0,
        1.0,  1.0,  1.0,   1.0, 0.5, 0.0, 1.0,
        1.0, -1.0,  1.0,   1.0, 0.5, 0.0, 1.0,

        -1.0, -1.0, -1.0,   0.0, 0.5, 1.0, 1.0,
        -1.0, -1.0,  1.0,   0.0, 0.5, 1.0, 1.0,
         1.0, -1.0,  1.0,   0.0, 0.5, 1.0, 1.0,
         1.0, -1.0, -1.0,   0.0, 0.5, 1.0, 1.0,

        -1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0,
        -1.0,  1.0,  1.0,   1.0, 0.0, 0.5, 1.0,
         1.0,  1.0,  1.0,   1.0, 0.0, 0.5, 1.0,
         1.0,  1.0, -1.0,   1.0, 0.0, 0.5, 1.0]!
	state.bind.vertex_buffers[0] = sg_make_buffer(&sg_buffer_desc{
		size: sizeof(f32) * verts.len
		content: verts.data
	})

	indices := [
		u16(0), 1, 2,  0, 2, 3,
        6, 5, 4,  7, 6, 4,
        8, 9, 10,  8, 10, 11,
        14, 13, 12,  15, 14, 12,
        16, 17, 18,  16, 18, 19,
        22, 21, 20,  23, 22, 20
	]!
	state.bind.index_buffer = sg_make_buffer(&sg_buffer_desc{
        @type: C.SG_BUFFERTYPE_INDEXBUFFER
        size: sizeof(u16) * indices.len
        content: indices.data
    })

	mut vs_desc := sg_shader_stage_desc{
		source: vert.str
	}
	vs_desc.uniform_blocks[0].size = sizeof(VsParams)

	fs_desc := sg_shader_stage_desc{
		source: frag.str
	}

	shd := sg_make_shader(&sg_shader_desc{
		vs: vs_desc
		fs: fs_desc
	})

	mut layout := sg_layout_desc{}
	layout.buffers[0].stride = 28
	layout.attrs[0] = sg_vertex_attr_desc{
		format: C.SG_VERTEXFORMAT_FLOAT3
	}
	layout.attrs[1] = sg_vertex_attr_desc{
		format: C.SG_VERTEXFORMAT_FLOAT4
	}

	rasterizer := sg_rasterizer_state{
		cull_mode: C.SG_CULLMODE_BACK
		sample_count: 4
	}
	state.pip = sg_make_pipeline(&sg_pipeline_desc{
		layout: layout
		shader: shd
		index_type: C.SG_INDEXTYPE_UINT16
		depth_stencil: sg_depth_stencil_state{
			depth_compare_func: C.SG_COMPAREFUNC_LESS_EQUAL
			depth_write_enabled: true
		}
		rasterizer: rasterizer
	})

	// view-projection matrix
	proj := C.HMM_Perspective(60.0, f32(sapp_width()) / f32(sapp_height()), 0.01, 10.0)
	view := HMM_LookAt(HMM_Vec3(0.0, 1.5, 6.0), HMM_Vec3(0.0, 0.0, 0.0), HMM_Vec3(0.0, 1.0, 0.0))
	state.view_proj = HMM_MultiplyMat4(proj, view)
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)

	// compute model-view-projection matrix for vertex shader
	state.rx += 1.0
	state.ry += 2.0
	rxm := HMM_Rotate(state.rx, HMM_Vec3(1.0, 0.0, 0.0))
    rym := HMM_Rotate(state.ry, HMM_Vec3(0.0, 1.0, 0.0))
    model := HMM_MultiplyMat4(rxm, rym)
	vs_params := VsParams{
		mvp: HMM_MultiplyMat4(state.view_proj, model)
	}

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	sg_apply_pipeline(state.pip)
	sg_apply_bindings(&state.bind)
	sg_apply_uniforms(C.SG_SHADERSTAGE_VS, 0, &vs_params, sizeof(VsParams))
	sg_draw(0, 36, 1)
	sg_end_pass()
	sg_commit()
}

fn cleanup() {
	println('hi cleanup')
}