uniform mat4 u_matrix;
uniform vec2 u_tl_parent;
uniform float u_scale_parent;
uniform float u_buffer_scale;
uniform sampler2D u_image2;

attribute vec2 a_pos;
attribute vec2 a_texture_pos;

varying vec2 v_pos0;
varying vec2 v_pos1;

void main() {
    // We are using Int16 for texture position coordinates to give us enough precision for
    // fractional coordinates. We use 8192 to scale the texture coordinates in the buffer
    // as an arbitrarily high number to preserve adequate precision when rendering.
    // This is also the same value as the EXTENT we are using for our tile buffer pos coordinates,
    // so math for modifying either is consistent.
    v_pos0 = (((a_texture_pos / 8192.0) - 0.5) / u_buffer_scale ) + 0.5;
    v_pos1 = (v_pos0 * u_scale_parent) + u_tl_parent;

    vec4 dem = texture2D(u_image2, v_pos0);
    // TODO: 1x1 zero elevation texture (r = 0, g = 0, b = 1) to avoid length == 0 check.
    float elevation = dot(dem, dem) == 0.0 ?
        0.0 : (dot(dem, vec4(255.0, 255.0 * 256.0, 255.0 * 256.0 *256.0, 0.0)) - 65536.0) * 2.5; // Exaggerate, a bit.
    gl_Position = u_matrix * vec4(a_pos, elevation, 1);
}
