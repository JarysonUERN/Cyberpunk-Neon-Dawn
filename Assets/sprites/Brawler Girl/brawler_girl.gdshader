shader_type canvas_item;

uniform vec4 new_color: source_color;


void fragment() {
	vec4 curr_color = texture(TEXTURE, UV);
	if(curr_color.r < 0.85 && curr_color.b < 0.28){
		COLOR.rgb = new_color.rgb * curr_color.rgb;
	}
}