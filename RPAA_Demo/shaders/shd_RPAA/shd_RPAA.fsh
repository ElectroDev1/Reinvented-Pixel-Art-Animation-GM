//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D sourceTexture;
uniform sampler2D lookupTexture;

void main()
{
	
	vec4 sourceColor = texture2D( sourceTexture, v_vTexcoord ) ;

	vec4 finalColor = texture2D( lookupTexture,  vec2(sourceColor.r,sourceColor.g) );

    gl_FragColor = finalColor; 
	
}
