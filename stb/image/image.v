module image
import filepath

#flag -I @VMOD/prime31/stb/image/thirdparty


// #define STBI_NO_STDIO
#define STBI_NO_GIF
#define STBI_NO_LINEAR
#define STBI_NO_HDR
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"


pub enum Channels {
	default int
	grey int
	grey_alpha int
	rgb int
	rgb_alpha int
}

pub struct Image {
mut:
	width int
	height int
	channels int
	data voidptr
}

pub fn (i Image) str() string { return 'w=$i.width, h=$i.height, channels=$i.channels' }

fn C.stbi_load(filename byteptr, x &int, y &int, channels_in_file &int, desired_channels int) voidptr
fn C.stbi_load_from_memory(buffer &byte, len int, x &int, y &int, channels_in_file &int, desired_channels int) voidptr

fn C.stbi_image_free(retval_from_stbi_load voidptr)

fn C.stbi_info(filename byteptr, x &int, y &int, comp &int) int
fn C.stbi_info_from_memory(buffer &byte, len int, x &int, y &int, comp &int) int

fn C.stbi_set_flip_vertically_on_load(flag_true_if_should_flip int)
fn C.stbi_failure_reason() byteptr


pub fn set_flip_vertically_on_load(val bool) {
	C.stbi_set_flip_vertically_on_load(val)
}

pub fn load(path string) Image { return load_channels(path, .default) }

pub fn load_channels(path string, channels Channels) Image {
	mut img := Image{data: 0}

	img.data = C.stbi_load(path.str, &img.width, &img.height, &img.channels, int(channels))
	if isnil(img.data) {
		println('stbi image failed to load: ${C.stbi_failure_reason()}')
		exit(1)
	}
	return img
}

pub fn get_info(filename string) (int, int, int) {
	w := 0
	h := 0
	comp := 0
	C.stbi_info(filename.str, &w, &h, &comp)
	return w, h, comp
}

pub fn load_from_memory(buffer voidptr, len int) Image { return load_channels_from_memory(buffer, len, .default) }

pub fn load_channels_from_memory(buffer voidptr, len int, channels Channels) Image {
	mut img := Image{data: 0}

	img.data = C.stbi_load_from_memory(buffer, len, &img.width, &img.height, &img.channels, int(channels))
	if isnil(img.data) {
		println('stbi image failed to load: ${C.stbi_failure_reason()}')
		exit(1)
	}
	return img
}

pub fn get_info_from_memory(buffer voidptr, len int) (int, int, int) {
	w := 0
	h := 0
	comp := 0
	C.stbi_info_from_memory(buffer, len, &w, &h, &comp)
	return w, h, comp
}

pub fn (img Image) free() {
	C.stbi_image_free(img.data)
}