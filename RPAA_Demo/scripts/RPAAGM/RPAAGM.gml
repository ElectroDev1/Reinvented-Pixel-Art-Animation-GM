globalvar U_SOURCE;
U_SOURCE = shader_get_sampler_index(shd_RPAA,"sourceTexture");

globalvar U_LOOKUP;
U_LOOKUP = shader_get_sampler_index(shd_RPAA,"lookupTexture");

/// @function					__RPAA_sprite_to_buffer(sprite,image);
/// @param {Asset.GMSprite}		sprite									The sprite to use to create the buffer
/// @param {Real}				image									The sprite's image index
/// @description				Turns a sprite's image into a buffer
function __RPAA_sprite_to_buffer(sprite,image){
	
		gml_pragma("forceinline");
	
		//Get the size of the sprite
		var sprW = sprite_get_width(sprite);
		var sprH = sprite_get_height(sprite);

		//Draw the sprite into a surface
		var _surf = surface_create(sprW, sprH);
		
		surface_set_target(_surf);
		
			draw_sprite(sprite,image,sprite_get_xoffset(sprite),sprite_get_yoffset(sprite));
			
		surface_reset_target();
		
		//Get the color data into a surface
		var _sprBuff = buffer_create(sprW * sprH * 4, buffer_fixed, 1);
		buffer_get_surface(_sprBuff, _surf, 0);
		
		//Free the surface and return the buffer
		surface_free(_surf);
		
		return _sprBuff;

}

/// @function					__RPAA_buffer_to_sprite(buffer,width,height,xorig,yorig);
/// @param {Id.Buffer}			buffer	The buffer to use to create the sprite
/// @param {Real}				width	The width of the sprite
/// @param {Real}				height	The height of the sprite
/// @param {Real}				xorig	The x origin of the sprite
/// @param {Real}				yorig	The y origin of the sprite
/// @description				Turns a sprite's image into a buffer
function __RPAA_buffer_to_sprite(buffer,width,height,xorig,yorig){

	gml_pragma("forceinline");

	//Create a surface and apply the buffer's color information
	var _surf = surface_create(width,height);
	
	buffer_set_surface(buffer,_surf,0);
	
	//Create a sprite from the surface
	var _spr = sprite_create_from_surface(_surf,0,0,width,height,0,0,xorig,yorig);
	
	//Free the surface and return the sprite
	surface_free(_surf);
	
	return _spr;
		
}

/// @function							__RPAA_buffer_vec4_to_array(buffer,offset,type);
/// @param {Id.Buffer}					buffer	The buffer to use to get the values
/// @param {Real}						offset	The offset position to start from
/// @param {Constant.BufferDataType}	type	The data type that will be returned
/// @description						Returns a 4 entry array from a buffer position
function __RPAA_buffer_vec4_to_array(buffer, offset, type){
	
	gml_pragma("forceinline");

	return	[
					buffer_peek(buffer, offset, type),
					buffer_peek(buffer, offset + 1, type),
					buffer_peek(buffer, offset + 2, type),
					buffer_peek(buffer, offset + 3, type)
			];

}

/// @function					RPAA_generate_source(sprite,baseMap);
/// @param {Asset.GMSprite}		sprite The sprite to use as a base
/// @param {Asset.GMSprite}		map	   The sprite to use as a map
function RPAA_generate_source(sprite,map){
	
	show_debug_message("\nGenerating RPAA source")

	//Get the necessary information
	var sprW = sprite_get_width(sprite);
	var sprH = sprite_get_height(sprite);
	
	var mapW = sprite_get_width(map);
	var mapH = sprite_get_height(map);
	var _mapBuff = __RPAA_sprite_to_buffer(map, 0);
	
	var _finalSprite = -1;

	#region Loop through the images and apply the correct data
	
		for(var i = 0; i < sprite_get_number(sprite); i++){
		
			var _sourceBuff = buffer_create(sprW*sprH*4, buffer_fixed, 1);

			//Create a buffer with the sprite's color information
			var _sprBuff = __RPAA_sprite_to_buffer(sprite, i);
			show_debug_message("		Checking image "+string(i))
		
			//Go through every pixel
			for(var a=0; a<buffer_get_size(_sprBuff)/4; a++){
		
				var _bufferSpritePos = a * 4;
			
				var _sprCol = __RPAA_buffer_vec4_to_array(_sprBuff, _bufferSpritePos, buffer_u8);
			
				var _match = -1;
			
				//Find a matching color in the map
				for(var b = 0; b < buffer_get_size(_mapBuff)/4; b++){
			
					var _bufferMapPos = b * 4;
				
					var _mapCol = __RPAA_buffer_vec4_to_array(_mapBuff, _bufferMapPos, buffer_u8);
					
					if array_equals(_sprCol,_mapCol){ _match = b; break; }
						
				}
			
				//If a match has been found, apply the correct uv coordinate colors
				if(_match>-1){
	
					buffer_seek(_sourceBuff, buffer_seek_start, _bufferSpritePos);
					buffer_write(_sourceBuff, buffer_u8, _match mod sprW * sprW); 
					buffer_write(_sourceBuff, buffer_u8, _match div sprH * sprH);
					buffer_write(_sourceBuff, buffer_u8, 0.0 );
					buffer_write(_sourceBuff, buffer_u8, _sprCol[3] );		
			
				}
		
			}

			//With the new _sprBuff color data, apply them to a new sprite
			var _mappedSprite = __RPAA_buffer_to_sprite(_sourceBuff, sprW, sprH, sprite_get_xoffset(sprite), sprite_get_yoffset(sprite));
		
			//Apply the new sprite to the source
			if(sprite_exists(_finalSprite)){
			
				sprite_merge(_finalSprite, _mappedSprite);
				sprite_delete(_mappedSprite);
			
			}else{
		
				_finalSprite = _mappedSprite;
		
			}

			buffer_delete(_sourceBuff);
			buffer_delete(_sprBuff);
		
		}
	
	#endregion

	buffer_delete(_mapBuff);
	
	show_debug_message("\nGenerated RPAA source")
	
	return _finalSprite;

}

function RPAA_draw_start(sourceTexture, lookupTexture){
	
	shader_set(shd_RPAA);
	texture_set_stage( U_SOURCE, sourceTexture );
	texture_set_stage( U_LOOKUP, lookupTexture );	
	
}

function RPAA_draw_end(){

	gml_pragma("forceinline");

	shader_reset();

}