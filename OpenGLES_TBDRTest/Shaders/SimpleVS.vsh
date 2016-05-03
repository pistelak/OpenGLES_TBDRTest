// Vertex shader

const char* SimpleVS = GLSL(300 es,
                            
precision mediump float;

// Uniforms
uniform highp mat4 u_projectionMatrix;
                            
// Attributes
in vec4 in_position;
                            
void main(void)
{
    gl_Position = u_projectionMatrix * in_position;
}
 
);