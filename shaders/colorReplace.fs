extern vec3 sColor;
extern vec3 rColor;
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    vec4 pixel = Texel(image, uvs);  // get current pixel

    // match color
    if(pixel.r == sColor.r && pixel.g == sColor.g && pixel.b == sColor.b){
        pixel.r = rColor.r;
        pixel.g = rColor.g;
        pixel.b = rColor.b;
    }
    return pixel;
}