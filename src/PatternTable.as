package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class PatternTable extends Window
	{
		[Embed(source="../assets/images/tilemap.png")] public var imgPattern:Class;
				
		public function PatternTable(X:Number, Y:Number)
		{
			super(X, Y, "Patterns");
						
			rows = columns = 16;
			width = 8 + 10 * columns;
			height = 16 + 10 * rows;
			_pixels = FlxG.addBitmap(imgPattern);
		}

		override public function update():void
		{
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
			
			var hover:Boolean = false;
			for (var _y:int = 0; _y < rows; _y++)
			{
				for (var _x:int = 0; _x < columns; _x++)
				{
					_flashRect.x = x + 4 + 10 * _x;
					_flashRect.y = y + 12 + 10 * _y;
					_flashRect.width = _flashRect.height = 8;
					FlxG.camera.buffer.fillRect(_flashRect, ColorTable.bgColor());
					
					_flashPoint.x = _flashRect.x;
					_flashPoint.y = _flashRect.y;
					_flashRect.x = 8 * _x;
					_flashRect.y = 8 * _y;
					FlxG.camera.buffer.copyPixels(pixels, _flashRect, _flashPoint, null, null, true);
				}
			}
		}
	}
}