// Shader that can desaturate sprites  based on life values
#define NUM_LIGHTS 32

// struct DesaturatePoint {
//     vec2 position;
// }
struct Light {
    vec2 position;
    vec3 diffuse;
    float power;
};

extern Light lights[NUM_LIGHTS];
extern int num_lights;
extern vec2 screenSize;
extern vec3 globalDiffuse;

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;

vec4 effect(vec4 color, Image image, vec2 texture_coords, vec2 screen_coords){

    vec2 normScreeCoords = screen_coords/ screenSize;
    vec3 diffuse = globalDiffuse; // vec3(0);

    // calculate light level for pixel
    for(int i = 0; i<num_lights; i++){
        Light light = lights[i];

        vec2 normPosition = light.position / screenSize;
        float distance = length(normPosition - normScreeCoords) * light.power;
        float attenuation = 1.0 / (constant + linear * distance + quadratic * (distance * distance));
        diffuse += light.diffuse * attenuation;
    }
    diffuse = clamp(diffuse, 0, 1);

    // get current pixel
    vec4 pixel = Texel(image, texture_coords);
    float avg = (pixel.r + pixel.g + pixel.b) / 3.0;
    float r = pixel.r;
    float g = pixel.g;
    float b = pixel.b;
    // if(g + b > 0.5){
    //     r = pixel.r + 0.3;
    //     g = pixel.g - 0.2;
    //     b = pixel.b - 0.5;
    // }

    vec4 newPixel = vec4(r, g, b, pixel.a);


    // return pixel;
    return newPixel * vec4(diffuse, 1);
}
