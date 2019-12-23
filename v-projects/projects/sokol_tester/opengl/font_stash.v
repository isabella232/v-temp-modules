import prime31.sokol
import os

#define FONTSTASH_IMPLEMENTATION
#include "fontstash/fontstash.h"
#define SOKOL_FONTSTASH_IMPL
#include "util/sokol_fontstash.h"

struct AppState {
mut:
	pass_action sg_pass_action
	fons &C.FONScontext
	font_normal int
}

fn main() {
	mut color_action := sg_color_attachment_action {
		action: C.SG_ACTION_CLEAR
	}
	color_action.val[0] = 0.3
	color_action.val[1] = 0.3
	color_action.val[2] = 0.32
	color_action.val[3] = 1.0

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
		window_title: 'V Metal Text Rendering'.str
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

	s := &C.sgl_desc_t{}
	C.sgl_setup(s)

    state.fons = C.sfons_create(512, 512, 1)

	if bytes := os.read_bytes('assets/DroidSerif-Regular.ttf') {
		println('loaded $bytes.len')
		state.font_normal = C.fonsAddFontMem(state.fons, "sans", bytes.data, bytes.len, false)
		println('fnt $state.font_normal')
	}
}

fn frame(user_data voidptr) {
	mut state := &AppState(user_data)

	state.render_font()

	sg_begin_default_pass(&state.pass_action, sapp_width(), sapp_height())
	C.sgl_draw()
	sg_end_pass()
	sg_commit()
}

fn cleanup() {
	println('hi cleanup')
}

fn (state &AppState) render_font() {
	mut sx := 0.0
	mut sy := 0.0
	mut dx := 0.0
	mut dy := 0.0
	lh := 0.0
    white := C.sfons_rgba(255, 255, 255, 255)
    black := C.sfons_rgba(0, 0, 0, 255)
    brown := C.sfons_rgba(192, 128, 0, 128)
    blue := C.sfons_rgba(0, 192, 255, 255)
    C.fonsClearState(state.fons)

	C.sgl_defaults()
    C.sgl_matrix_mode_projection()
    C.sgl_ortho(0.0, f32(C.sapp_width()), f32(C.sapp_height()), 0.0, -1.0, 1.0)

	sx = 0
	sy = 50
    dx = sx
	dy = sy

	C.fonsSetFont(state.fons, state.font_normal)
	C.fonsSetSize(state.fons, 100.0)
	C.fonsVertMetrics(state.fons, C.NULL, C.NULL, &lh)
	dx = sx
	dy += lh
	C.fonsSetColor(state.fons, white)
	dx = C.fonsDrawText(state.fons, dx, dy, c'The quick ', C.NULL)

	fonsSetFont(state.fons, state.font_normal)
	fonsSetSize(state.fons, 48.0)
	fonsSetColor(state.fons, brown)
	dx = fonsDrawText(state.fons, dx, dy, c"brown ", C.NULL)

	fonsSetFont(state.fons, state.font_normal)
	fonsSetSize(state.fons, 24.0)
	fonsSetColor(state.fons, white)
	dx = fonsDrawText(state.fons, dx, dy, c"fox ", C.NULL)

	dx = sx
	dy += lh * 1.2
	C.fonsSetSize(state.fons, 22.0)
	C.fonsSetFont(state.fons, state.font_normal)
	C.fonsSetColor(state.fons, blue)
	C.fonsDrawText(state.fons, dx, dy, c"Now is the time for all good men to come to the aid of the party.", C.NULL)

	dx = 300
	dy = 350
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_LEFT | C.FONS_ALIGN_BASELINE)
	C.fonsSetSize(state.fons, 60.0)
	C.fonsSetFont(state.fons, state.font_normal)
	C.fonsSetColor(state.fons, white)
	C.fonsSetSpacing(state.fons, 5.0)
	C.fonsSetBlur(state.fons, 6.0)
	C.fonsDrawText(state.fons, dx, dy, c"Blurry...", C.NULL)

	dx = 300
	dy += 50.0
	fonsSetSize(state.fons, 28.0)
	fonsSetFont(state.fons, state.font_normal)
	fonsSetColor(state.fons, white)
	fonsSetSpacing(state.fons, 0.0)
	fonsSetBlur(state.fons, 3.0)
	fonsDrawText(state.fons, dx,dy + 2, c"DROP SHADOW", C.NULL)
	fonsSetColor(state.fons, black)
	fonsSetBlur(state.fons, 0)
	fonsDrawText(state.fons, dx,dy, c"DROP SHADOW", C.NULL)

	C.fonsSetSize(state.fons, 18.0)
	C.fonsSetFont(state.fons, state.font_normal)
	C.fonsSetColor(state.fons, white)
	dx = 50
	dy = 350
	line(dx-10,dy,dx+250,dy)
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_LEFT | C.FONS_ALIGN_TOP)
	dx = C.fonsDrawText(state.fons, dx,dy, c"Top",C.NULL)
	dx += 10
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_LEFT | C.FONS_ALIGN_MIDDLE)
	dx = C.fonsDrawText(state.fons, dx,dy, c"Middle",C.NULL)
	dx += 10
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_LEFT | C.FONS_ALIGN_BASELINE)
	dx = C.fonsDrawText(state.fons, dx,dy, c"Baseline",C.NULL)
	dx += 10
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_LEFT | C.FONS_ALIGN_BOTTOM)
	C.fonsDrawText(state.fons, dx,dy, c"Bottom",C.NULL)
	dx = 150
	dy = 400
	line(dx,dy-30,dx,dy+80.0)
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_LEFT | C.FONS_ALIGN_BASELINE)
	C.fonsDrawText(state.fons, dx,dy, c"Left",C.NULL)
	dy += 30
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_CENTER | C.FONS_ALIGN_BASELINE)
	C.fonsDrawText(state.fons, dx,dy, c"Center",C.NULL)
	dy += 30
	C.fonsSetAlign(state.fons, C.FONS_ALIGN_RIGHT | C.FONS_ALIGN_BASELINE)
	C.fonsDrawText(state.fons, dx,dy, c"Right",C.NULL)

	C.sfons_flush(state.fons)
}

fn line(sx f32, sy f32, ex f32, ey f32) {
    C.sgl_begin_lines()
    C.sgl_c4b(255, 255, 0, 128)
    C.sgl_v2f(sx, sy)
    C.sgl_v2f(ex, ey)
    C.sgl_end()
}