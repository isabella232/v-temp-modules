module sgl
import via.libs.sokol

pub const ( used_import = sokol.used_import )

#define SOKOL_GL_IMPL
#include "util/sokol_gl.h"

/* setup/shutdown/misc */
[inline]
pub fn setup(desc &C.sgl_desc_t) {
	C.sgl_setup(desc)
}

[inline]
pub fn shutdown() {
	C.sgl_shutdown()
}

[inline]
pub fn error() C.sgl_error_t {
	return C.sgl_error()
}

[inline]
pub fn defaults() {
	C.sgl_defaults()
}

[inline]
pub fn rad(deg f32) f32 {
	return C.sgl_rad(deg)
}

[inline]
pub fn deg(rad f32) f32 {
	return C.sgl_deg(rad)
}

/* create and destroy pipeline objects */
[inline]
pub fn make_pipeline(desc &C.sg_pipeline_desc) C.sgl_pipeline {
	return C.sgl_make_pipeline(desc)
}

[inline]
pub fn destroy_pipeline(pip C.sgl_pipeline) {
	C.sgl_destroy_pipeline(pip)
}

/* render state functions */
[inline]
pub fn viewport(x int, y int, w int, h int, origin_top_left bool) {
	C.sgl_viewport(x, y, w, h, origin_top_left)
}

[inline]
pub fn scissor_rect(x int, y int, w int, h int, origin_top_left bool) {
	C.sgl_scissor_rect(x, y, w, h, origin_top_left)
}

[inline]
pub fn enable_texture() {
	C.sgl_enable_texture()
}

[inline]
pub fn disable_texture() {
	C.sgl_disable_texture()
}

[inline]
pub fn texture(img C.sg_image) {
	C.sgl_texture(img)
}

/* pipeline stack functions */
[inline]
pub fn default_pipeline() {
	C.sgl_default_pipeline()
}

[inline]
pub fn load_pipeline(pip C.sgl_pipeline) {
	C.sgl_load_pipeline(pip)
}

[inline]
pub fn push_pipeline() {
	C.sgl_push_pipeline()
}

[inline]
pub fn pop_pipeline() {
	C.sgl_pop_pipeline()
}

/* matrix stack functions */
[inline]
pub fn matrix_mode_modelview() {
	C.sgl_matrix_mode_modelview()
}

[inline]
pub fn matrix_mode_projection() {
	C.sgl_matrix_mode_projection()
}

[inline]
pub fn matrix_mode_texture() {
	C.sgl_matrix_mode_texture()
}

[inline]
pub fn load_identity() {
	C.sgl_load_identity()
}

[inline]
pub fn load_matrix(m []f32) {
	C.sgl_load_matrix(m.data)
}

[inline]
pub fn load_transpose_matrix(m []f32) {
	C.sgl_load_transpose_matrix(m.data)
}

[inline]
pub fn mult_matrix(m []f32) {
	C.sgl_mult_matrix(m.data)
}

[inline]
pub fn mult_transpose_matrix(m []f32) {
	C.sgl_mult_transpose_matrix(m.data)
}

[inline]
pub fn rotate(angle_rad f32, x f32, y f32, z f32) {
	C.sgl_rotate(angle_rad, x, y, z)
}

[inline]
pub fn scale(x f32, y f32, z f32) {
	C.sgl_scale(x, y, z)
}

[inline]
pub fn translate(x f32, y f32, z f32) {
	C.sgl_translate(x, y, z)
}

[inline]
pub fn frustum(l f32, r f32, b f32, t f32, n f32, f f32) {
	C.sgl_frustum(l, r, b, t, n, f)
}

[inline]
pub fn ortho(l f32, r f32, b f32, t f32, n f32, f f32) {
	C.sgl_ortho(l, r, b, t, n, f)
}

[inline]
pub fn perspective(fov_y f32, aspect f32, z_near f32, z_far f32) {
	C.sgl_perspective(fov_y, aspect, z_near, z_far)
}

[inline]
pub fn lookat(eye_x f32, eye_y f32, eye_z f32, center_x f32, center_y f32, center_z f32, up_x f32, up_y f32, up_z f32) {
	C.sgl_lookat(eye_x, eye_y, eye_z, center_x, center_y, center_z, up_x, up_y, up_z)
}

[inline]
pub fn push_matrix() {
	C.sgl_push_matrix()
}

[inline]
pub fn pop_matrix() {
	C.sgl_pop_matrix()
}

/* these functions only set the internal 'current texcoord / color' (valid inside or outside begin/end) */
[inline]
pub fn t2f(u f32, v f32) {
	C.sgl_t2f(u, v)
}

[inline]
pub fn c3f(r f32, g f32, b f32) {
	C.sgl_c3f(r, g, b)
}

[inline]
pub fn c4f(r f32, g f32, b f32, a f32) {
	C.sgl_c4f(r, g, b, a)
}

[inline]
pub fn c3b(r byte, g byte, b byte) {
	C.sgl_c3b(r, g, b)
}

[inline]
pub fn c4b(r byte, g byte, b byte, a byte) {
	C.sgl_c4b(r, g, b, a)
}

[inline]
pub fn c1i(rgba u32) {
	C.sgl_c1i(rgba)
}

/* define primitives, each begin/end is one draw command */
[inline]
pub fn begin_points() {
	C.sgl_begin_points()
}

[inline]
pub fn begin_lines() {
	C.sgl_begin_lines()
}

[inline]
pub fn begin_line_strip() {
	C.sgl_begin_line_strip()
}

[inline]
pub fn begin_triangles() {
	C.sgl_begin_triangles()
}

[inline]
pub fn begin_triangle_strip() {
	C.sgl_begin_triangle_strip()
}

[inline]
pub fn begin_quads() {
	C.sgl_begin_quads()
}

[inline]
pub fn v2f(x f32, y f32) {
	C.sgl_v2f(x, y)
}

[inline]
pub fn v3f(x f32, y f32, z f32) {
	C.sgl_v3f(x, y, z)
}

[inline]
pub fn v2f_t2f(x f32, y f32, u f32, v f32) {
	C.sgl_v2f_t2f(x, y, u, v)
}

[inline]
pub fn v3f_t2f(x f32, y f32, z f32, u f32, v f32) {
	C.sgl_v3f_t2f(x, y, z, u, v)
}

[inline]
pub fn v2f_c3f(x f32, y f32, r f32, g f32, b f32) {
	C.sgl_v2f_c3f(x, y, r, g, b)
}

[inline]
pub fn v2f_c3b(x f32, y f32, r byte, g byte, b byte) {
	C.sgl_v2f_c3b(x, y, r, g, b)
}

[inline]
pub fn v2f_c4f(x f32, y f32, r f32, g f32, b f32, a f32) {
	C.sgl_v2f_c4f(x, y, r, g, b, a)
}

[inline]
pub fn v2f_c4b(x f32, y f32, r byte, g byte, b byte, a byte) {
	C.sgl_v2f_c4b(x, y, r, g, b, a)
}

[inline]
pub fn v2f_c1i(x f32, y f32, rgba u32) {
	C.sgl_v2f_c1i(x, y, rgba)
}

[inline]
pub fn v3f_c3f(x f32, y f32, z f32, r f32, g f32, b f32) {
	C.sgl_v3f_c3f(x, y, z, r, g, b)
}

[inline]
pub fn v3f_c3b(x f32, y f32, z f32, r byte, g byte, b byte) {
	C.sgl_v3f_c3b(x, y, z, r, g, b)
}

[inline]
pub fn v3f_c4f(x f32, y f32, z f32, r f32, g f32, b f32, a f32) {
	C.sgl_v3f_c4f(x, y, z, r, g, b, a)
}

[inline]
pub fn v3f_c4b(x f32, y f32, z f32, r byte, g byte, b byte, a byte) {
	C.sgl_v3f_c4b(x, y, z, r, g, b, a)
}

[inline]
pub fn v3f_c1i(x f32, y f32, z f32, rgba u32) {
	C.sgl_v3f_c1i(x, y, z, rgba)
}

[inline]
pub fn v2f_t2f_c3f(x f32, y f32, u f32, v f32, r f32, g f32, b f32) {
	C.sgl_v2f_t2f_c3f(x, y, u, v, r, g, b)
}

[inline]
pub fn v2f_t2f_c3b(x f32, y f32, u f32, v f32, r byte, g byte, b byte) {
	C.sgl_v2f_t2f_c3b(x, y, u, v, r, g, b)
}

[inline]
pub fn v2f_t2f_c4f(x f32, y f32, u f32, v f32, r f32, g f32, b f32, a f32) {
	C.sgl_v2f_t2f_c4f(x, y, u, v, r, g, b, a)
}

[inline]
pub fn v2f_t2f_c4b(x f32, y f32, u f32, v f32, r byte, g byte, b byte, a byte) {
	C.sgl_v2f_t2f_c4b(x, y, u, v, r, g, b, a)
}

[inline]
pub fn v2f_t2f_c1i(x f32, y f32, u f32, v f32, rgba u32) {
	C.sgl_v2f_t2f_c1i(x, y, u, v, rgba)
}

[inline]
pub fn v3f_t2f_c3f(x f32, y f32, z f32, u f32, v f32, r f32, g f32, b f32) {
	C.sgl_v3f_t2f_c3f(x, y, z, u, v, r, g, b)
}

[inline]
pub fn v3f_t2f_c3b(x f32, y f32, z f32, u f32, v f32, r byte, g byte, b byte) {
	C.sgl_v3f_t2f_c3b(x, y, z, u, v, r, g, b)
}

[inline]
pub fn v3f_t2f_c4f(x f32, y f32, z f32, u f32, v f32, r f32, g f32, b f32, a f32) {
	C.sgl_v3f_t2f_c4f(x, y, z, u, v, r, g, b, a)
}

[inline]
pub fn v3f_t2f_c4b(x f32, y f32, z f32, u f32, v f32, r byte, g byte, b byte, a byte) {
	C.sgl_v3f_t2f_c4b(x, y, z, u, v, r, g, b, a)
}

[inline]
pub fn v3f_t2f_c1i(x f32, y f32, z f32, u f32, v f32, rgba u32) {
	C.sgl_v3f_t2f_c1i(x, y, z, u, v, rgba)
}

[inline]
pub fn end() {
	C.sgl_end()
}

/* render everything */
[inline]
pub fn draw() {
	C.sgl_draw()
}

