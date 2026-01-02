#version 320 es
precision mediump float;

// Input from the vertex shader
in vec2 v_textureCoordinates;

// The final color of the pixel
out vec4 out_color;

// The texture we're manipulating (the blurred background)
uniform sampler2D u_texture;

void main() {
    // Just sample the texture at the given coordinate and output the color.
    // This is the simplest possible fragment shader.
    out_color = texture(u_texture, v_textureCoordinates);
}