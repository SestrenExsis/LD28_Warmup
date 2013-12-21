package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class PatternTable extends Window
	{
		public static const WHITE:uint = 0xffffffff;
		public static const GRAY:uint = 0xff808080;
		public static const BLACK:uint = 0xff000000;
		public static const TRANSPARENT:uint = 0x00000000;
						
		public function PatternTable(X:Number, Y:Number)
		{
			super(X, Y, "Patterns");
			
			rows = columns = 16;
			width = 8 + (8 + spacing) * columns;
			height = 16 + (8 + spacing) * rows;
			_pixels = FlxG.createBitmap(16 * 8, 16 * 8, 0x00000000);
			loadRandomPattern();
		}
		
		public function loadRandomPattern():BitmapData
		{
			_flashRect.x = _flashRect.y = 0;
			_flashRect.width = _flashRect.height = 8;
			
			for (var _y:int = 0; _y < rows; _y++)
			{
				for (var _x:int = 0; _x < columns; _x++)
				{
					_flashPoint.x = 8 * _x;
					_flashPoint.y = 8 * _y;
					_pixels.copyPixels(randomBrush(), _flashRect, _flashPoint, null, null, false);
				}
			}
			return _pixels;
		}
		
		public function randomBrush():BitmapData
		{
			if((framePixels == null) || (framePixels.width != width) || (framePixels.height != height))
				framePixels = new BitmapData(width,height);
			
			var _randColor:uint;
			var _index:int;
			for (var _y:int = 0; _y < framePixels.height; _y++)
			{
				for (var _x:int = 0; _x < framePixels.width; _x++)
				{
					_index = (int)(FlxG.random() * 4);
					switch (_index)
					{
						case 0:
							_randColor = WHITE;
							break;
						case 1:
							_randColor = GRAY;
							break;
						case 2:
							_randColor = BLACK;
							break;
						default:
							_randColor = TRANSPARENT;
							break;
					}
					framePixels.setPixel32(_x, _y, _randColor);
				}
			}
			return framePixels;
		}

		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE"))
				loadRandomPattern();
		}
		
		override public function draw():void
		{
			super.draw();
			
			var hover:Boolean = false;
			for (var _y:int = 0; _y < rows; _y++)
			{
				for (var _x:int = 0; _x < columns; _x++)
				{
					_flashRect.x = x + 4 + (8 + spacing) * _x;
					_flashRect.y = y + 12 + (8 + spacing) * _y;
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