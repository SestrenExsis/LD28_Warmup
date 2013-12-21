package
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class GameWindow extends Window
	{
		public static const screenWidth:Number = 256;
		public static const screenHeight:Number = 240;
		
		public function GameWindow(X:Number, Y:Number)
		{
			super(X, Y, "Game");
						
			//ColorTable.setBackgroundColor();
			makeGraphic(screenWidth, screenHeight, ColorTable.bgColor());
			width = 8 + screenWidth;
			height = 20 + screenHeight;
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