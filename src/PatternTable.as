package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class PatternTable extends FlxSprite
	{
		[Embed(source="../assets/images/tilemap.png")] public var imgPattern:Class;
		
		public static const FULL_PALETTE:uint = 0;
		public static const BACKGROUNDs:uint = 1;
		public static const SPRITES:uint = 2;
		
		protected var isDragging:Boolean;
		protected var label:FlxText;
		protected var columns:uint;
		protected var rows:uint;
		protected var palette:Array;
		protected var locked:Array;
				
		public function PatternTable(X:Number, Y:Number)
		{
			super(X, Y);
			
			label = new FlxText(X, Y, 72, "Pattern");
			label.color = 0x000000;
			
			rows = columns = 16;
			width = 8 + 10 * columns;
			height = 16 + 10 * rows;
			//loadGraphic(imgPattern);
			_pixels = FlxG.addBitmap(imgPattern);
		}

		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.pressed())
			{
				var _height:Number = height;
				height = 12;
				if (FlxG.mouse.justPressed() && overlapsPoint(FlxG.mouse))
				{
					offset.x = FlxG.mouse.x - x;
					offset.y = FlxG.mouse.y - y;
					isDragging = true;
				}
				height = _height;
				if (isDragging)
				{
					label.x = x = FlxG.mouse.x - offset.x;
					label.y = y = FlxG.mouse.y - offset.y;
				}
			}
			else if (FlxG.mouse.justReleased())
			{
				offset.x = offset.y = 0;
				isDragging = false;
			}
		}
		
		override public function draw():void
		{
			_flashRect.x = x + 1;
			_flashRect.y = y + 1;
			_flashRect.width = width;
			_flashRect.height = height;
			FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
			
			_flashRect.x = x;
			_flashRect.y = y;
			FlxG.camera.buffer.fillRect(_flashRect, 0xFFF8D8F8);
			
			_flashRect.x = x + 1;
			_flashRect.y = y + 8;
			_flashRect.width -= 2;
			_flashRect.height = 3;
			FlxG.camera.buffer.fillRect(_flashRect, 0xFFA4E4FC);
			
			var hover:Boolean = false;
			for (var _y:int = 0; _y < rows; _y++)
			{
				for (var _x:int = 0; _x < columns; _x++)
				{
					_flashRect.x = x + 4 + 10 * _x;
					_flashRect.y = y + 12 + 10 * _y;
					_flashRect.width = _flashRect.height = 8;
					FlxG.camera.buffer.fillRect(_flashRect, FlxG.bgColor);
					
					_flashPoint.x = _flashRect.x;
					_flashPoint.y = _flashRect.y;
					_flashRect.x = 8 * _x;
					_flashRect.y = 8 * _y;
					FlxG.camera.buffer.copyPixels(pixels, _flashRect, _flashPoint, null, null, true);
				}
			}
			label.draw();
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
			{
				drawDebug(FlxG.camera);
				label.drawDebug(FlxG.camera);
			}
		}
	}
}