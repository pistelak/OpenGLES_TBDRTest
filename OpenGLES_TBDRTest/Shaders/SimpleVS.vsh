// Vertex shader

static const char* SimpleVS = STRINGIFY
(
 // Atributtes
 attribute vec4 in_position;
 
 // Uniforms
 uniform highp mat4 u_projectionMatrix;
 
 // Varying
 
 void main(void)
{
    gl_Position = u_projectionMatrix * in_position;
}
 
 );