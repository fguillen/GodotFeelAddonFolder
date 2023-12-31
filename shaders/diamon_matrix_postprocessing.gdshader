/*
From: https://docs.godotengine.org/en/stable/tutorials/shaders/custom_postprocessing.html
*/


shader_type canvas_item;

uniform float size : hint_range(1, 100, 1) = 1;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
        vec2 norm_size = vec2(size * SCREEN_PIXEL_SIZE.x, size * SCREEN_PIXEL_SIZE.y);
        bool half = mod(SCREEN_UV.y / 2.0, norm_size.y) / norm_size.y < 0.5;
        vec2 uv = SCREEN_UV + vec2(norm_size.x * 0.5 * float(half), 0.0);
        vec2 center_uv = floor(uv / norm_size) * norm_size;
        vec2 norm_uv = mod(uv, norm_size) / norm_size;
        center_uv += 
			mix(
				vec2(0.0, 0.0),
                mix(
					mix(
						vec2(norm_size.x, -norm_size.y),
                        vec2(0.0, -norm_size.y),
                        float(norm_uv.x < 0.5)),
                        mix(
							vec2(0.0, -norm_size.y),
                            vec2(-norm_size.x, -norm_size.y),
                            float(norm_uv.x < 0.5)),
                            float(half)
						),
                        float(norm_uv.y < 0.3333333) * float(norm_uv.y / 0.3333333 < (abs(norm_uv.x - 0.5) * 2.0)
					)
				);

        COLOR = textureLod(screen_texture, center_uv, 0.0);
}
