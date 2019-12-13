import prime31.fmod
import time

fn main() {
	sys := fmod.create(32, C.FMOD_INIT_NORMAL)
	println('fmod version=${sys.get_version()}')

	_, snd := sys.create_sound('skid.wav'.str, C.FMOD_DEFAULT)
	len := snd.get_length(.ms)
	println('snd len=$len')

	_, snd_group := sys.create_sound_group("snd gruoper")
	println('snd_group=$snd_group.group')

	_, group := sys.create_channel_group("tester")
	_, channel := snd.play_in_group(group, 0)
	_, _ := snd.play(0)
	channel.set_pitch(1.2)
	println('group=${group.group}, channel=${channel.ch}')

	_, master_group := sys.get_master_channel_group()
	println('master_group=${master_group.group}')

	dsp := fmod.Dsp{}
	sys.create_dsp_by_type(.flange, mut dsp)
	master_group.add_dsp(0, dsp)
	// master_group.remove_dsp(dsp)

	active := -1
	act_res := FMOD_DSP_GetActive(dsp.dsp, &active)
	println('dsp active=$active, res=$act_res')

	res, state, percent_buffered, starving, diskbusy := snd.get_open_state()
	println('state=$state, res=$res, buff=$percent_buffered')

	_, name := snd.get_name()
	println('name=$name')

	println('tick')
	time.sleep_ms(5000)
}

//type FileOpenCallback fn(name byteptr, filesize &u32, handle &voidptr, userdata voidptr) int
fn file_open_cb(name byteptr, filesize &u32, handle &voidptr, userdata voidptr) int {
	println('----------- open da file $name')
	if name != byteptr(0) {
		fp := C.fopen(name, 'rb')
		if fp == voidptr(0) {
			return int(fmod.Result.err_file_notfound)
		}

		C.fseek(fp, 0, C.SEEK_END)
		//*filesize = C.ftell(fp)
		C.fseek(fp, 0, C.SEEK_SET)

		//*userdata = voidptr(0x12345678)
		//*handle = fp

		println('fp=$fp, size=${*filesize}')
	}

	return int(fmod.Result.ok)
}

//type FileCloseCallback fn(handle voidptr, userdata voidptr) int
fn file_close_cb(handle voidptr, userdata voidptr) int {
	println('----------- close da file')
	return int(fmod.Result.ok)
}

fn file_read_cb(handle voidptr, buffer voidptr, sizebytes u32, bytesread &int, userdata voidptr) int {
	println('----------- read_cb')
	return int(fmod.Result.ok)
}

fn file_seek_cb(handle voidptr, pos u32, userdata voidptr) int {
	println('----------- seek_cb')
	return int(fmod.Result.ok)
}


fn C.ftell() int