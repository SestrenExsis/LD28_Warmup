package
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class GameWindow extends Window
	{				
		public function GameWindow(X:Number, Y:Number)
		{
			super(X, Y, "Game");
						
			rows = columns = 1;
			ColorTable.setBackgroundColor();
			makeGraphic(256, 240, ColorTable.bgColor());
			width = 8 + 256;
			height = 20 + 240;
		}

		override public function update():void
		{
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
			
			_flashPoint.x = x + 4;
			_flashPoint.y = y + 16;
			_flashRect.x = _flashRect.y = 0;
			_flashRect.width = frameWidth;
			_flashRect.height = frameHeight;
			
			FlxG.camera.buffer.copyPixels(pixels, _flashRect, _flashPoint, null, null, true);
		}
	}
}