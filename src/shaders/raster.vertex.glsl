uniform mat4 u_matrix;
uniform vec2 u_tl_parent;
uniform float u_scale_parent;
uniform float u_buffer_scale;
uniform sampler2D u_dem;
uniform vec4 u_dem_unpack;
uniform vec3 u_tl_scale_dem;

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

    vec2 pos = (v_pos0 * u_tl_scale_dem.z) + u_tl_scale_dem.xy;
    vec4 dem = texture2D(u_dem, pos) * 255.0;
    // Convert encoded elevation value to meters
    dem.a = -1.0;
    float elevation = dot(dem, u_dem_unpack) * 2.0; // Exaggerate, a bit.
    gl_Position = u_matrix * vec4(a_pos, elevation, 1);
}
