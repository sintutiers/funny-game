shader_type canvas_item;

void fragment() {
    // Invert the RGB values
    COLOR.rgb = 1.0 - COLOR.rgb;
}