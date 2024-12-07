shader_type canvas_item;

uniform float tile_factor = 10.0;
uniform float aspect_ratio = 1;

uniform vec2 time_factor = vec2(2.0, 3.0);
uniform vec2 offset_factor = vec2(7.3, 2.6);
uniform vec2 amplitude = vec2(0.002, 0.002);

void fragment() {
	vec2 tiled_uvs_raw = mod(UV * tile_factor, 2.0);
	vec2 tiled_uvs = min(tiled_uvs_raw, vec2(2) - tiled_uvs_raw);
	tiled_uvs.y *= aspect_ratio;
	
	vec2 wave_uv_offset;
	wave_uv_offset.x = sin(TIME * time_factor.x + (tiled_uvs_raw.x + tiled_uvs_raw.y) * offset_factor.x);
	wave_uv_offset.y = cos(TIME * time_factor.y + (tiled_uvs_raw.x + tiled_uvs_raw.y) * offset_factor.y);

	COLOR = texture(TEXTURE, tiled_uvs + wave_uv_offset * amplitude);
}