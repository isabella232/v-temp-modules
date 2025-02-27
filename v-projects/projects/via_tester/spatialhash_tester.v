import via
import via.math
import via.time
import via.input
import via.debug
import via.graphics
import via.collections
import via.libs.imgui

struct Sprite {
pub mut:
	col collections.Collider = collections.Collider{
		w: 32.0
		h: 32.0
	}
	vx f32
	vy f32
	id int
}

struct AppState {
mut:
	dude_tex graphics.Texture
	sprites []&Sprite
	space &collections.SpatialHash = &collections.SpatialHash(0)
}

const (
	width = 1024.0
	height = 768.0
	sprite_cnt = 100
)

fn main() {
	state := AppState{
		space: collections.spatialhash(150)
	}

	via.run(via.ViaConfig{
		win_resizable: false
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.dude_tex = graphics.new_texture('assets/dude.png')

	for _ in 0..sprite_cnt {
		state.add_sprite(math.range(0, width), math.range(0, height))
	}
}

fn (state mut AppState) add_sprite(x, y f32) {
	mut sprite := &Sprite {
		vx: math.range(-150, 150)
		vy: math.range(-150, 150)
	}
	sprite.col.x = x
	sprite.col.y = y
	sprite.id = state.space.add(sprite.col)
	state.sprites << sprite
}

pub fn (state mut AppState) update() {
	dt := time.dt()
	for i, _ in state.sprites {
		mut s := state.sprites[i]
		s.col.x += s.vx * dt
		s.col.y += s.vy * dt

		if s.col.x + s.col.w > width {
			s.vx *= -1
			s.col.x = width - s.col.w
		} else 	if s.col.x < 0 {
			s.vx *= -1
			s.col.x = 0
		}
		if s.col.y + s.col.h > height {
			s.vy *= -1
			s.col.y = height - s.col.h
		} else if s.col.y < 0 {
			s.vy *= -1
			s.col.y = 0
		}

		state.space.update(s.id, s.col)
	}
}

pub fn (state mut AppState) draw() {
	graphics.begin_pass({color:math.rgba(0.5, 0.4, 0.8, 1.0)})

	mut batch := graphics.spritebatch()
	for s in state.sprites {
		batch.draw(state.dude_tex, {x:s.col.x, y:s.col.y})
	}

	state.space.debug_draw()
	batch.draw_text('FPS: $time.fps()', {x:0 y:0 align:.top sx:4 sy:4 color:math.blue()})
	graphics.end_pass()

	debug.draw_text('shit', 0, 40, math.red())

	graphics.blit_to_screen(math.rgba(0.0, 0.0, 0.0, 1.0))
}