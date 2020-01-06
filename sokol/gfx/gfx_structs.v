module gfx

pub struct C.sg_desc {
    _start_canary u32
    buffer_pool_size int
    image_pool_size int
    shader_pool_size int
    pipeline_pool_size int
    pass_pool_size int
    context_pool_size int
    /* GL specific */
    gl_force_gles2 bool
    /* Metal-specific */
    mtl_device voidptr
    mtl_renderpass_descriptor_cb fn() voidptr
    mtl_drawable_cb fn() voidptr
    // (*mtl_renderpass_descriptor_cb)(void) voidptr
    // (*mtl_drawable_cb)(void) voidptr
    mtl_global_uniform_buffer_size int
    mtl_sampler_cache_size int
    /* D3D11-specific */
    d3d11_device voidptr
    d3d11_device_context voidptr
    d3d11_render_target_view_cb fn() voidptr
    d3d11_depth_stencil_view_cb fn() voidptr
    // (*d3d11_render_target_view_cb)(void) voidptr
    // (*d3d11_depth_stencil_view_cb)(void) voidptr
    _end_canary u32
}

pub struct C.sg_pipeline_desc {
pub mut:
	_start_canary u32
    layout C.sg_layout_desc
    shader C.sg_shader
    primitive_type PrimitiveType
    index_type IndexType
    depth_stencil C.sg_depth_stencil_state
    blend C.sg_blend_state
    rasterizer C.sg_rasterizer_state
    label byteptr
    _end_canary u32
}

pub struct C.sg_pipeline_info {

}

pub struct C.sg_pipeline {
    id u32
}

pub struct C.sg_bindings {
pub mut:
    _start_canary u32
    vertex_buffers [8]sg_buffer
    vertex_buffer_offsets [8]int
    index_buffer sg_buffer
    index_buffer_offset int
    vs_images [8]sg_image
    fs_images [8]sg_image
    _end_canary u32
}

pub struct C.sg_shader_desc {
pub mut:
    _start_canary u32
    attrs [16]sg_shader_attr_desc
    vs C.sg_shader_stage_desc
    fs C.sg_shader_stage_desc
    label byteptr
    _end_canary u32
}

pub struct C.sg_shader_attr_desc {
    name byteptr           /* GLSL vertex attribute name (only required for GLES2) */
    sem_name byteptr       /* HLSL semantic name */
    sem_index int              /* HLSL semantic index */
}

pub struct C.sg_shader_stage_desc {
pub mut:
    source byteptr
    byte_code &byte
    byte_code_size int
    entry byteptr
    uniform_blocks [4]sg_shader_uniform_block_desc
    images [12]sg_shader_image_desc
}

pub struct C.sg_shader_uniform_block_desc {
pub mut:
    size int
    uniforms [16]sg_shader_uniform_desc
}

pub struct C.sg_shader_uniform_desc {
pub mut:
    name byteptr
    @type UniformType
    array_count int
}

pub struct C.sg_shader_image_desc {
    name byteptr
    @type ImageType
}

pub struct C.sg_shader_info {

}

pub struct C.sg_context {
    id u32
}

pub struct C.sg_shader {
    id u32
}

pub struct C.sg_pass_desc {
pub mut:
    _start_canary u32
    color_attachments [4]sg_attachment_desc
    depth_stencil_attachment C.sg_attachment_desc
    label byteptr
    _end_canary u32
}

pub struct C.sg_pass_info {
    info C.sg_slot_info
}

pub struct C.sg_pass_action {
pub mut:
    _start_canary u32
    colors [4]sg_color_attachment_action
    depth sg_depth_attachment_action
    stencil sg_stencil_attachment_action
    _end_canary u32
}

pub struct C.sg_pass {
    id u32
}

pub struct C.sg_buffer_desc {
    _start_canary u32
    size int
    @type BufferType
    usage Usage
    content byteptr
    label byteptr
    /* GL specific */
    gl_buffers [2]u32
    /* Metal specific */
    mtl_buffers [2]voidptr
    /* D3D11 specific */
    d3d11_buffer voidptr
    _end_canary u32
}

pub struct C.sg_buffer_info {

}

pub struct C.sg_buffer {
    id u32
}

pub struct C.sg_image_desc {
pub mut:
    _start_canary u32
    @type ImageType
    render_target bool
    width int
    height int
    depth int
    // union {
    //     int depth;
    //     int layers;
    // };
    num_mipmaps int
    usage Usage
    pixel_format PixelFormat
    sample_count int
    min_filter Filter
    mag_filter Filter
    wrap_u Wrap
    wrap_v Wrap
    wrap_w Wrap
    border_color BorderColor
    max_anisotropy u32
    min_lod f32
    max_lod f32
    content C.sg_image_content
    label byteptr
    /* GL specific */
    gl_textures [2]u32
    /* Metal specific */
    mtl_textures [2]voidptr
    /* D3D11 specific */
    d3d11_texture voidptr
    _end_canary u32
}

pub struct C.sg_image_info {
pub mut:
    slot C.sg_slot_info            /* resource pool slot info */
    upd_frame_index u32            /* frame index of last sg_update_image() */
    num_slots int                  /* number of renaming-slots for dynamically updated images */
    active_slot int                /* currently active write-slot for dynamically updated images */
}

pub struct C.sg_image {
    id u32
}

pub struct C.sg_image_content {
pub mut:
    subimage [6][16]sg_subimage_content
}
// pub fn (ic  C.sg_image_content) set_shit() {
//     wtf := ic.subimage[0]
// }

pub struct C.sg_subimage_content {
pub mut:
    ptr voidptr     /* pointer to subimage data */
    size int        /* size in bytes of pointed-to subimage data */
}

pub struct C.sg_features {
pub:
    instancing bool
    origin_top_left bool
    multiple_render_targets bool
    msaa_render_targets bool
    imagetype_3d bool          /* creation of SG_IMAGETYPE_3D images is supported */
    imagetype_array bool       /* creation of SG_IMAGETYPE_ARRAY images is supported */
    image_clamp_to_border bool /* border color and clamp-to-border UV-wrap mode is supported */
}

pub struct C.sg_limits {
pub:
    max_image_size_2d u32         /* max width/height of SG_IMAGETYPE_2D images */
    max_image_size_cube u32       /* max width/height of SG_IMAGETYPE_CUBE images */
    max_image_size_3d u32         /* max width/height/depth of SG_IMAGETYPE_3D images */
    max_image_size_array u32
    max_image_array_layers u32
    max_vertex_attrs u32          /* <= SG_MAX_VERTEX_ATTRIBUTES (only on some GLES2 impls) */
}

pub struct C.sg_layout_desc {
pub mut:
    buffers [8]sg_buffer_layout_desc
    attrs [16]sg_vertex_attr_desc
}

pub struct C.sg_buffer_layout_desc {
pub mut:
    stride int
    step_func VertexStep
    step_rate int
}

pub struct C.sg_vertex_attr_desc {
pub mut:
    buffer_index int
    offset int
    format VertexFormat
}

pub struct C.sg_depth_stencil_state {
    stencil_front sg_stencil_state
    stencil_back sg_stencil_state
    depth_compare_func CompareFunc
    depth_write_enabled bool
    stencil_enabled bool
    stencil_read_mask byte
    stencil_write_mask byte
    stencil_ref byte
}

pub struct C.sg_stencil_state {
    fail_op StencilOp
    depth_fail_op StencilOp
    pass_op StencilOp
    compare_func CompareFunc
}

pub struct C.sg_blend_state {
    enabled bool
    src_factor_rgb BlendFactor
    dst_factor_rgb BlendFactor
    op_rgb BlendOp
    src_factor_alpha BlendFactor
    dst_factor_alpha BlendFactor
    op_alpha BlendOp
    color_write_mask byte
    color_attachment_count int
    color_format PixelFormat
    depth_format PixelFormat
    blend_color [4]f32
}

pub struct C.sg_rasterizer_state {
pub mut:
    alpha_to_coverage_enabled bool
    cull_mode CullMode
    face_winding FaceWinding
    sample_count int
    depth_bias f32
    depth_bias_slope_scale f32
    depth_bias_clamp f32
}


pub struct C.sg_color_attachment_action {
pub mut:
    action Action
    val [4]f32
}

pub fn (action mut C.sg_color_attachment_action) set_color_values(r, g, b, a f32) {
    action.val[0] = r
    action.val[1] = g
    action.val[2] = b
    action.val[3] = a
}

pub struct C.sg_depth_attachment_action {
pub mut:
    action Action
    val f32
}

pub struct C.sg_stencil_attachment_action {
pub mut:
    action Action
    val byte
}

pub struct C.sg_pixelformat_info {
pub:
    sample bool        /* pixel format can be sampled in shaders */
    filter bool        /* pixel format can be sampled with filtering */
    render bool        /* pixel format can be used as render target */
    blend bool         /* alpha-blending is supported */
    msaa bool          /* pixel format can be used as MSAA render target */
    depth bool         /* pixel format is a depth format */
}

pub struct C.sg_attachment_desc {
pub mut:
    image C.sg_image
    mip_level int
    face int

    // image sg_image
    // mip_level int
    // union {
    //     face int
    //     layer int
    //     slice int
    // }
}