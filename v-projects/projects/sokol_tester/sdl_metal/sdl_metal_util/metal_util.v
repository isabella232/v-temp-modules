module sdl_metal_util

#flag -I./sdl_metal_util
#flag darwin -framework Metal -framework Cocoa -framework MetalKit -framework QuartzCore

#include "metal_util.h"

fn C.mu_create_metal_layer(window voidptr, is_high_dpi bool)
fn C.mu_get_metal_device() voidptr
fn C.mu_get_render_pass_descriptor() voidptr
fn C.mu_get_drawable() voidptr
fn C.mu_set_framebuffer_only(framebuffer_only bool)
fn C.mu_set_drawable_size(width int, height int)
fn C.mu_set_display_sync_enabled(enabled bool)

pub fn init_metal(window voidptr) {
	C.mu_create_metal_layer(window)
}

pub fn get_metal_device() voidptr {
	return C.mu_get_metal_device()
}

pub fn set_framebuffer_only(framebuffer_only bool) {
    C.mu_set_framebuffer_only(framebuffer_only)
}

pub fn set_drawable_size(width int, height int) {
    C.mu_set_drawable_size(width, height)
}

pub fn set_display_sync_enabled(enabled bool) {
	C.mu_set_display_sync_enabled(enabled)
}