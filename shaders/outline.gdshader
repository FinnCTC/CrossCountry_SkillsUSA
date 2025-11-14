shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 OUTLINE_COLOR : source_color;
uniform float OUTLINE_WIDTH = 2.0;

void fragment() {
	vec4 pixalated_txt = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixal_size = 1.0 / VIEWPORT_SIZE;
	ALBEDO = pixalated_txt.rgb;

	for (int y = -1*int(OUTLINE_WIDTH); y <= 1*int(OUTLINE_WIDTH); y++)
	for (int x  = -1*int(OUTLINE_WIDTH); x <= 1*int(OUTLINE_WIDTH); x++){
		vec4 txt = texture(SCREEN_TEXTURE, SCREEN_UV + vec2 (float(x), float(y))*pixal_size);
		if (txt.a == 0.0 &&
		SCREEN_UV.x + float(x) * pixal_size.x < 1.0 &&
		SCREEN_UV.x + float(x) * pixal_size.x > 0.0 &&
		SCREEN_UV.x + float(y) * pixal_size.y < 1.0 &&
		SCREEN_UV.x + float(y) * pixal_size.y > 0.0) {
			ALBEDO = OUTLINE_COLOR.rgb;
			ALPHA = 1.0;
		}
	}
}