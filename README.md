# Reinvented Pixel Art Animation GM
 A rectreation of <a href="https://github.com/aarthificial">aarthificial</a>'s <a href="https://www.youtube.com/watch?v=HsOKwUwL1bE&t=2s">"Reinvented Pixel Art Animation" system</a> in Gamemaker
 
 <hr>
 
# Setup and Usage
To start using RPAAGM, <a href="https://github.com/ElectroDev1/Reinvented-Pixel-Art-Animation-GM/releases/tag/v1.0.0">download the .yymps</a> and drag the file in your project.<br>
The system requires a few sprites to be used, check out the system's <a href="https://www.youtube.com/watch?v=HsOKwUwL1bE&t=2s">original video</a> and the demo project in the repository for some examples on how to set them up.<br>
RPAAGM uses generated source sprites to determine the final colors, to generate these you have to use the following function:<br>
```gml
 sourceSprite = RPAA_generate_source(mapped sprite, map);
```
`sourceSprite` will now contain the index to a new sprite whose colors will determine the colors of the final result, all that needs to be done is draw it:
```gml
 RPAA_draw_start(source texture, lookup texture);
 
      *draw the mapped sprite*
      
 RPAA_draw_end();
```
If everything was set up correctly you should now be able to see the sprite in its proper colors! You can simply change the two arguments to change the sprite's look
