shader_type canvas_item;

uniform vec4 old_color:source_color;
uniform vec4 new_color:source_color;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);

    if (current_color == old_color) {
        COLOR = new_color;
    } else {
        COLOR = current_color;
    }
}