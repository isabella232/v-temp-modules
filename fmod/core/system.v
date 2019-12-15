module core
import prime31.fmod
import prime31.fmod.core.c

pub struct System {
pub:
	sys &FMOD_SYSTEM
}

pub fn create(maxchannels int, flags int) System {
	fmod := System{&FMOD_SYSTEM(0)}
	FMOD_System_Create(&fmod.sys)
	FMOD_System_Init(fmod.sys, maxchannels, flags, C.NULL /*extradriverdata*/)
	return fmod
}

pub fn (s &System) get_version() u32 {
	ver := u32(0)
	FMOD_System_GetVersion(s.sys, &ver)
	return ver
}

pub fn (s &System) create_sound(name_or_data byteptr, mode int /* exinfo &FMOD_CREATESOUNDEXINFO */) (int, Sound) {
	return create_sound(s, name_or_data, mode)
}

pub fn (s &System) play_sound(sound &FMOD_SOUND, channelgroup ChannelGroup /* &FMOD_CHANNELGROUP */, paused int) (int, Channel) {
	channel := Channel{&FMOD_CHANNEL(0)}
	res := FMOD_System_PlaySound(s.sys, sound, channelgroup.group, paused, &channel.ch)
	return res, channel
}

pub fn (s &System) update() int {
	return FMOD_System_Update(s.sys)
}

/*
	mut data := &fmod.Channel{}
	sys.set_user_data(data)
	println('sent: ${data}')
	data = 0
	sys.get_user_data(&data)
	println('received: ${data}')
*/
pub fn (s &System) set_user_data(userdata voidptr) int {
	return FMOD_System_SetUserData(s.sys, userdata)
}

pub fn (s &System) get_user_data(userdata voidptr) int {
	return FMOD_System_GetUserData(s.sys, userdata)
}

pub fn (s &System) get_channel(channelid int, channel mut Channel) int {
	return FMOD_System_GetChannel(s.sys, channelid, &channel.ch)
}

pub fn (s &System) create_channel_group(name string) (int, ChannelGroup) {
	group := ChannelGroup{&FMOD_CHANNELGROUP(0)}
	res := FMOD_System_CreateChannelGroup(s.sys, name.str, &group.group)
	return res, group
}

pub fn (s &System) create_sound_group(name string) (int, SoundGroup) {
	group := SoundGroup{&FMOD_SOUNDGROUP(0)}
	res := FMOD_System_CreateSoundGroup(s.sys, name.str, &group.group)
	return res, group
}

pub fn (s &System) get_master_channel_group() (int, ChannelGroup) {
	group := ChannelGroup{&FMOD_CHANNELGROUP(0)}
	return FMOD_System_GetMasterChannelGroup(s.sys, &group.group), group
}

pub fn (s &System) create_dsp_by_type(typ DspType, dsp mut Dsp) int {
	return FMOD_System_CreateDSPByType(s.sys, typ, &dsp.dsp)
}

pub fn (s &System) set_file_system(useropen voidptr, userclose voidptr, userread voidptr, userseek voidptr, userasyncread voidptr, userasynccancel voidptr, blockalign int) int {
	return FMOD_System_SetFileSystem(s.sys, useropen, userclose, userread, userseek, userasyncread, userasynccancel, blockalign)
}
