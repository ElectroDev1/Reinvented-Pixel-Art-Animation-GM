draw_set_halign(fa_left); draw_set_valign(fa_top);
draw_text(10,10,"Reinvented Pixel Art Animation in Gamemaker\nOriginal concept by @aarthificial");

var _image = floor( image_index / 6 );

/*
This object shows all steps of the process
*/

//Icons
var _ogSprite = new Icon(105, room_height - 140, spr_player_colored, 10);
var _baseMap = new Icon(355, room_height - 400, spr_map_base, 10);
var _baseMappedSprite = new Icon(355, room_height - 140, spr_player_mapped, 10);
var _sourceSprite = new Icon(855, room_height - 140, sourceSprite, 10);
var _lookup = new Icon(605, room_height - 400, spr_player_map, 10);
var _result = new Icon(855, room_height - 400, sourceSprite, 10);
var _process = new Icon(605, room_height - 140, spr_gmlogo, 0.32);

//Let the user change the image
_mapImg += keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
_mapImg = clamp(_mapImg, 0, sprite_get_number(spr_player_map)-1 );

//Draw original sprite icon
with(_ogSprite){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());
	
	draw_sprite_ext(sprite, _image, x, y, scale,scale, 0,c_white,1);
	
	draw_set_halign(fa_center);
	draw_text(x, y + h*scale/2 + 10, "Original");
	
	draw_arrow(x + w*scale/2+10, y, _baseMappedSprite.x - _baseMappedSprite.w*_baseMappedSprite.scale/2-10,
	_baseMappedSprite.y, scale*2);

}

//Draw map icon
with(_baseMap){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());

	draw_sprite_ext(sprite, _image, x-w/2*scale, y - h/2*scale, scale,scale, 0,c_white,1);
	
	draw_set_halign(fa_center);
	draw_text(x, y + h*scale/2 + 10, "Map");
	
	draw_arrow(x, y + h/2*scale + 40, _baseMappedSprite.x,
	_baseMappedSprite.y - _baseMappedSprite.h/2*scale-10, scale*2);

}

//Draw player mapped icon
with(_baseMappedSprite){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());


	draw_sprite_ext(sprite, _image, x, y, scale,scale, 0,c_white,1);
	
	
	draw_set_halign(fa_center);

	draw_text(x, y + h*scale/2 + 10, "Overlay");
	
	
	draw_arrow(x + w*scale/2+10, y, _process.x - _process.w*_process.scale/2-10,
	_process.y, scale*2);

}

//Draw player mapped icon
with(_process){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());

	gpu_set_tex_filter(1)
	draw_sprite_ext(sprite, _image, x, y, scale,scale, 0,c_white,1);
	gpu_set_tex_filter(0)	
	
	draw_set_halign(fa_center);

	draw_text(x, y + h*scale/2 + 10, "Generator");
	
	
	draw_arrow(x + w*scale/2+10, y, _sourceSprite.x - _sourceSprite.w*_sourceSprite.scale/2-10,
	_sourceSprite.y, 20);
	
}

//Draw source icon
with(_sourceSprite){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());


	draw_sprite_ext(sprite,_image, x, y, scale,scale, 0,c_white,1);
	
	
	draw_set_halign(fa_center);

	
	draw_text(x, y + h*scale/2 + 10, "Source");
	
	draw_arrow(x, y - h/2*scale - 10 , x,
	_result.y+_result.h/2*_result.scale + 40, scale*2);

}

//Draw lookup icon
with(_lookup){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());


	draw_sprite_ext(sprite,other._mapImg, x-w/2*scale, y - h/2*scale, scale,scale, 0,c_white,1);
	
	
	draw_set_halign(fa_center);

	draw_text(x, y + h*scale/2 + 10, "Lookup");
	
	draw_arrow(x + w*scale/2+10, y, _result.x - _result.w*_result.scale/2-10,
	_result.y, scale*2);
	
}

//Draw result icon
with(_result){

	matrix_set(matrix_world, matrix_build( x-(w/2)*scale ,y-h/2*scale,0,0,0,0, scale, scale, 0 ) );
		draw_sprite_stretched(spr_baseGrid,0, 0, 0, w, h);
	matrix_set(matrix_world,matrix_build_identity());	
	
	RPAA_draw_start( sprite_get_texture(other.sourceSprite,_image), sprite_get_texture(spr_player_map,other._mapImg) ); 
	
		draw_sprite_ext(sprite,_image,x,y,scale,scale,0,c_white,1);
	
	RPAA_draw_end();

	draw_set_halign(fa_center);
	draw_text(x, y + h*scale/2 + 10, "Result");
	
}
