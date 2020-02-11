import via
import via.math
import via.time
import via.input
import via.debug
import via.window
import via.graphics
import via.collections
import via.libs.flecs
import via.libs.imgui

struct Sprite {
pub mut:
	col collections.Collider = collections.Collider{
		w: 32.0
		h: 32.0
	}
	tex graphics.Texture
	vx f32
	vy f32
	id int
}

struct AppState {
mut:
	dude_tex graphics.Texture
	space &collections.SpatialHash = &collections.SpatialHash(0)
	world flecs.World
	sprite_entity flecs.Entity
}

const (
	width = 512.0
	height = 384.0
	sprite_cnt = 200
)

fn main() {
	state := AppState{
		space: collections.spatialhash(150)
	}

	via.run(via.ViaConfig{
		max_quads: sprite_cnt + 1
		win_resizable: false
	}, mut state)
}

pub fn (state mut AppState) initialize() {
	state.dude_tex = graphics.new_texture('assets/dude.png')

	// setup ecs
	state.world = flecs.init_world()
	state.world.set_context(state)

	// components
	state.sprite_entity = flecs.new_comp<Sprite>(state.world)

	// systems
	move_set_sys := state.world.new_system('AddMoveSystem', .on_set, 'Sprite', move_set)
	move_sys := state.world.new_system('MoveSystem', .on_update, 'Sprite', move)
	state.world.new_system('RenderSystem', .on_update, 'Sprite', render)

	state.world.set_system_context(move_set_sys.id, state.space)
	state.world.set_system_context(move_sys.id, state.space)

	for _ in 0..sprite_cnt {
		state.add_sprite(math.range(-width, width), math.range(-height, height))
	}
}

fn (state &AppState) add_sprite(x, y f32) {
	mut sprite := Sprite {
		tex: state.dude_tex
		vx: math.range(-150, 150)
		vy: math.range(-150, 150)
	}
	sprite.col.x = x
	sprite.col.y = y

	entity := state.world.new_entity('A Sprite $x,$y', 'Sprite')
	entity.set_ptr_t(state.sprite_entity, sprite)
}

pub fn (state mut AppState) update() {
	w, h := window.drawable_size()
	trans_mat := math.mat32_translate(w/2, h/2)
	graphics.begin_pass({color:math.color_from_floats(0.5, 0.4, 0.8, 1.0) trans_mat:&trans_mat})

	state.world.progress(time.dt())

	state.space.debug_draw()
	debug.draw_text(-width, -height, 'FPS: $time.fps()', {align:.top scale:4 color:math.color_blue()})
	graphics.end_pass()

	graphics.blit_to_screen(math.color_from_floats(0.0, 0.0, 0.0, 1.0))
}

pub fn (state &AppState) draw() {}

fn move_set(rows &C.ecs_rows_t) {
	mut space := &collections.SpatialHash(C.ecs_get_system_context(rows.world, rows.system))
	mut sprites := flecs.column<Sprite>(rows, 1)

	for i in 0..int(rows.count) {
		sprites[i].id = space.add(sprites[i].col)
	}
}

fn move(rows &C.ecs_rows_t) {
	mut space := &collections.SpatialHash(C.ecs_get_system_context(rows.world, rows.system))
	sprites := flecs.column<Sprite>(rows, 1)

	dt := time.dt()
	for i := 0; i < int(rows.count); i++ {
		mut s := &sprites[i]
		s.col.x += s.vx * dt
		s.col.y += s.vy * dt

		if s.col.x + s.col.w > width {
			s.vx *= -1
			s.col.x = width - s.col.w
		} else 	if s.col.x < -width {
			s.vx *= -1
			s.col.x = -width
		}
		if s.col.y + s.col.h > height {
			s.vy *= -1
			s.col.y = height - s.col.h
		} else if s.col.y < -height {
			s.vy *= -1
			s.col.y = -height
		}

		space.update(s.id, s.col)
	}
}

fn render(rows &C.ecs_rows_t) {
	mut batch := graphics.spritebatch()
	sprites := flecs.column<Sprite>(rows, 1)

	for i in 0..int(rows.count) {
		batch.draw(sprites[i].tex, {x:sprites[i].col.x, y:sprites[i].col.y})
	}
}