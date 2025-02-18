#define NUM_LIGHTS 32

struct Light {
    vec2 position;
    vec3 diffuse;
    float power;
};

extern Light lights[NUM_LIGHTS];
extern int num_lights;
extern vec2 screenSize;

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    vec2 normPixelPos = screen_coords / screenSize;
    vec3 diffuse = vec3(0);

    for(int i = 0; i<num_lights; i++){
        Light light = lights[i];

        vec2 normPosition = light.position / screenSize;
        float distance = length(normPosition - normPixelPos) * light.power;
        float attenuation = 1.0 / (constant + linear * distance + quadratic * (distance * distance));
        diffuse += light.diffuse * attenuation;
    }
    diffuse = clamp(diffuse, 0, 1);

    vec4 pixel = Texel(image, uvs);  // get current pixel

    return pixel * color * vec4(diffuse, 1);
}