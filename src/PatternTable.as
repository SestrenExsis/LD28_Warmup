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
			super(X, Y, "Tileset");
			
			rows = columns = 16;
			
			spacing.x = 0;
			spacing.y = 0;
			
			elements = new Array(rows * columns);
			selected = new Array(rows * columns);
			for (var i:int = 0; i < elements.length; i++)
			{
				elements[i] = i;
				selected[i] = false;
			}
			
			buffer.x = 2;
			buffer.y = 2;
			width = 2 * buffer.x + (block.x + spacing.x) * Math.max(2, columns) - spacing.x
			height = titleBarHeight + 2 * buffer.y + (block.y + spacing.y) * rows - spacing.y;
			
			//width = 8 + (block.x + spacing.x) * columns;
			//height = 16 + (block.y + spacing.y) * rows;
			_pixels = FlxG.createBitmap(columns * block.x, rows * block.y, 0x00000000);
			loadRandomPattern();
		}
		
		public function loadRandomPattern():BitmapData
		{
			_flashRect.x = _flashRect.y = 0;
			_flashRect.width = block.x;
			_flashRect.height = block.y;
			
			for (var _y:int = 0; _y < rows; _y++)
			{
				for (var _x:int = 0; _x < columns; _x++)
				{
					_flashPoint.x = block.x * _x;
					_flashPoint.y = block.y * _y;
					_pixels.copyPixels(randomBrush(), _flashRect, _flashPoint, null, null, false);
				}
			}
			return _pixels;
		}
		
		/**
		 * Create a random 8px by 8px bitmap using four colors (TRANSPARENT, WHITE, GRAY, and BLACK).
		 * 
		 * @param	Seed	Pass a seed value when generating the random bitmap.
		 * 
		 * @return	The 8px by 8px bitmap.
		 */
		public function randomBrush(Seed:Number = -1):BitmapData
		{
			if((framePixels == null) || (framePixels.width != width) || (framePixels.height != height))
				framePixels = new BitmapData(width,height);
			
			var _randColor:uint;
			var _index:int;
			for (var _y:int = 0; _y < framePixels.height; _y++)
			{
				for (var _x:int = 0; _x < framePixels.width; _x++)
				{
					if (Seed >= 0 && Seed <= 1) _index = FlxU.srand(Seed)
					else _index = (int)(FlxG.random() * 4);
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
		
		override public function drawElementBackground(ElementIndex:int):void
		{
			FlxG.camera.buffer.fillRect(_flashRect, ColorTable.bgColor());
		}
		
		override public function drawElement(ElementIndex:int):void
		{
			var _x:int = ElementIndex % columns;
			var _y:int = (int)(ElementIndex / columns);
			_flashPoint.x = _flashRect.x;
			_flashPoint.y = _flashRect.y;
			_flashRect.x = block.x * _x;
			_flashRect.y = block.y * _y;
			
			FlxG.camera.buffer.copyPixels(pixels, _flashRect, _flashPoint, null, null, true);
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}