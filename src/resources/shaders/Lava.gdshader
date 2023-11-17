// 2D liquid inside 'sphere' shader.

// Original Author: Mirza Beig
// Godot Implementation: RuverQ

// https://twitter.com/TheMirzaBeig
// https://www.youtube.com/@MirzaBeig

// https://twitter.com/RuverQuack

// Feel free troveto use this however you want.
// Modify, learn from it, copy-paste, etc...

// Original Shadertoy: https://www.shadertoy.com/view/Ds3BRN

shader_type canvas_item;

const float PI = 3.14;

uniform sampler2D mask_texture;
//uniform float tile_factor = 10.0;
//uniform float aspect_ratio = 0.5;
uniform vec2 time_factor = vec2(1.0, 2.0);
uniform vec2 offset_factor = vec2(5.0, 2.0);
uniform vec2 amplitude = vec2(0.02, 0.02);
uniform bool enabled = false;

void fragment() {
	if (enabled) {
		
	    vec2 uv = UV / -.1;//((UV / -0.10)) + vec2(1.25,1.25);

	    float
			//sdf=length(uv),
			//c=1.0,//step(sdf,.85),

	        vB=smoothstep(.1,.9,sin(uv.x+(PI*.5))-.3),
			vBA=vB*sin(TIME*4.)*.08,

	        fW=(sin(((TIME*2.)+uv.x)*2.)*.05)+vBA,
			bW=(sin(((TIME*-2.)+uv.x)*2.+PI)*.05)-vBA,

	        fA=(sin(TIME*4.)*.05)*vB,

	        fP=(sin((TIME)*PI)*.1) - 0.2,

	        fF=step(uv.y,(fA+fW)+fP),//fF=step(uv.y,(fA+fW)+fP)*c,
			bF=step(uv.y,(-fA+bW)+fP);//bF=step(uv.y,(-fA+bW)+fP)*c;

	//    COLOR =
	//		vec4(
	//			0.12//(step(sdf,1.)-step(sdf,.9)) 
	//			+ (fF+(clamp(bF-fF,0.,1.)*.8))
	//			+ clamp(pow((.01) * ((1.-(fF+bF))),5.), //+ clamp(pow((sdf+.01) * ((1.-(fF+bF))),5.), //+ clamp(pow((sdf+.01) * ((1.-(fF+bF))*c),5.), 
	//		0., 
	//		1.));

	//	COLOR.a = 0.12//(step(sdf,1.)-step(sdf,.9)) 
	//			+ (fF+(clamp(bF-fF,0.,1.)*.8))
	//			+ clamp(pow((.01) * ((1.-(fF+bF))),5.), //+ clamp(pow((sdf+.01) * ((1.-(fF+bF))),5.), //+ clamp(pow((sdf+.01) * ((1.-(fF+bF))*c),5.), 
	//		0., 
	//		1.);



		
		vec2 tiled_uvs = UV;// * tile_factor;
		//tiled_uvs.y *= aspect_ratio;
		
		vec2 wave_uv_offset;
		wave_uv_offset.x += sin(TIME * time_factor.x + (tiled_uvs.x + tiled_uvs.y) * offset_factor.x);
		wave_uv_offset.y += cos(TIME * time_factor.y + (tiled_uvs.x + tiled_uvs.y) * offset_factor.y);
		
		//COLOR = texture(TEXTURE, tiled_uvs + wave_uv_offset * amplitude);


		vec4 colour = texture(TEXTURE, tiled_uvs + wave_uv_offset * amplitude);

		//vec4 colour = texture(TEXTURE, UV);
		colour.a *= 0.//(step(sdf,1.)-step(sdf,.9)) 
				+ (fF+(clamp(bF-fF,0.,1.)*.58))
				+ clamp(pow((.01) * ((1.-(fF+bF))),5.), //+ clamp(pow((sdf+.01) * ((1.-(fF+bF))),5.), //+ clamp(pow((sdf+.01) * ((1.-(fF+bF))*c),5.), 
			0., 
			1.);

		COLOR = colour;
	
	}
	
}

//const float PI = 3.14;
//// fV = fill value
//uniform float fV;
//void fragment() {
//    vec2 uv = ((UV / -0.10)) + vec2(1.25,1.25);
//
//    float
//		sdf=length(uv),c=step(sdf,.85),
//
//        vB=smoothstep(.1,.9,sin(uv.x+(PI*.5))-.3),
//		vBA=vB*sin(TIME*4.)*.1,
//
//        fW=(sin(((TIME*2.)+uv.x)*2.)*.05)+vBA,
//		bW=(sin(((TIME*-2.)+uv.x)*2.+PI)*.05)-vBA,
//
//        fA=(sin(TIME*4.)*.05)*vB,
//
//        fP=fV * 2.3 +(sin((TIME)*PI)*.1) - 1.1,
//
//        fF=step(uv.y,(fA+fW)+fP)*c,
//		bF=step(uv.y,(-fA+bW)+fP)*c;
//
//    COLOR =
//		vec4(
//			(step(sdf,1.)-step(sdf,.9)) + (fF+(clamp(bF-fF,0.,1.)*.8))
//		+ clamp(pow((sdf+.01) * ((1.-(fF+bF))*c),5.), 0., 1.));
//}

//uniform sampler2D mask_texture;
//void fragment() {
//	vec4 colour = texture(TEXTURE, UV);
//	colour.a *= texture(mask_texture, UV).a;
//
//	COLOR = colour;
//}


//uniform float progress: hint_range(0.0, 1.0) = 0.5;
//uniform vec4 bg_color;//: source_color;
//uniform vec4 wave_1_color;//: source_color;
//uniform vec4 wave_2_color;//: source_color;
//uniform float wave_1_speed = -1.0;
//uniform float wave_2_speed = 1.0;
//
//vec4 wave( vec2 uv, vec4 wave_color, float level, float freq, float amp, float sin_shift, float speed ){
//	float sinus = sin( (uv.x + sin_shift + TIME * speed) * freq) * amp;
//	float shifted_level = ( 1.0 + 2.0 * amp ) * level - amp; //shift to completely hide or fill
//	float treshold = step( 1.0 - sinus - shifted_level, uv.y);
//	return wave_color * treshold;
//}
//
//void fragment() {
//
//	vec4 wave1 = wave(UV, wave_1_color, progress, 2.5, 0.13, 0.0, wave_1_speed);
//	vec4 wave2 = wave(UV, wave_2_color, progress, 2.0, 0.1, 0.7785*TIME, wave_2_speed);
//
//	vec4 combined_waves = mix(wave1, wave2, wave2.a);
//	COLOR.rgb = mix( bg_color, combined_waves, combined_waves.a ).rgb;
//}

