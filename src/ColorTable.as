package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class ColorTable extends FlxSprite
	{
		public static const FULL_PALETTE:uint = 0;
		public static const BACKGROUNDs:uint = 1;
		public static const SPRITES:uint = 2;
		
		protected var colorsPerRow:uint = 0;
		
		// The 55 colors allowed by the NES's color palette.
		public static var colors:Array = [ 
			0xFF7C7C7C, 0xFF0000FC, 0xFF0000BC, 0xFF4428BC, 0xFF940084, 0xFFA80020, 0xFFA81000, 0xFF881400, 0xFF503000, 0xFF007800, 0xFF006800, 0xFF005800, 0xFF004058, 0xFF000000,
			0xFFBCBCBC, 0xFF0078F8, 0xFF0058F8, 0xFF6844FC, 0xFFD800CC, 0xFFE40058, 0xFFF83800, 0xFFE45C10, 0xFFAC7C00, 0xFF00B800, 0xFF00A800, 0xFF00A844, 0xFF008888, 0xFF000000,
			0xFFF8F8F8, 0xFF3CBCFC, 0xFF6888FC, 0xFF9878F8, 0xFFF878F8, 0xFFF85898, 0xFFF87858, 0xFFFCA044, 0xFFF8B800, 0xFFB8F818, 0xFF58D854, 0xFF58F898, 0xFF00E8D8, 0xFF787878,
			0xFFFCFCFC, 0xFFA4E4FC, 0xFFB8B8F8, 0xFFD8B8F8, 0xFFF8B8F8, 0xFFF8A4C0, 0xFFF0D0B0, 0xFFFCE0A8, 0xFFF8D878, 0xFFD8F878, 0xFFB8F8B8, 0xFFB8F8D8, 0xFF00FCFC, 0xFFF8D8F8
		];
				
		// Each of the four sprite palettes contains 3 colors, plus an implicit transparency color
		protected var palette:Array;
		
		private var isDragging:Boolean;
		
		public function ColorTable(X:Number, Y:Number)
		{
			super(X, Y);
		}
		
		public static function randomColor():uint
		{
			return colors[(int)(FlxG.random() * colors.length)];
		}
		
		public function loadRandomPalette(NumColors:uint = 3, ColorsPerRow:uint = 3):Array
		{
			if (NumColors >= colors.length)
				NumColors = colors.length;
			colorsPerRow = ColorsPerRow;
			palette = new Array(NumColors);
			for (var i:int = 0; i < palette.length; i++)
			{
				palette[i] = (int)(FlxG.random() * (colors.length - i));
				var lastOffset:int = 0;
				var offset:int = 0;
				do
				{
					lastOffset = offset;
					offset = 0;
					for (var j:int = 0; j < i; j++)
					{
						if (palette[j] <= palette[i] + lastOffset)
							offset++;
					}
				} while (offset > lastOffset);
				palette[i] += offset;
			}
			
			var rows:uint  = (int)(palette.length / colorsPerRow);
			width = 8 + (10 * Math.max(1,colorsPerRow));
			height = 8 + (10 * Math.max(1,rows));
			
			return palette;
		}
		
		public function loadFullPalette(ColorsPerRow:uint = 14):Array
		{
			palette = new Array(colors.length);
			colorsPerRow = ColorsPerRow;
			for (var i:int = 0; i < palette.length; i++)
			{
				palette[i] = i;
			}
			
			var rows:uint  = (int)(palette.length / colorsPerRow);
			width = 8 + (10 * Math.max(1,colorsPerRow));
			height = 8 + (10 * Math.max(1,rows));
			
			return palette;
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.pressed())
			{
				if (FlxG.mouse.justPressed() && overlapsPoint(FlxG.mouse))
				{
					offset.x = FlxG.mouse.x - x;
					offset.y = FlxG.mouse.y - y;
					isDragging = true;
				}
				if (isDragging)
				{
					x = FlxG.mouse.x - offset.x;
					y = FlxG.mouse.y - offset.y;
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
			
			var rows:uint = 0;
			if (palette)
				rows = (int)(palette.length / colorsPerRow);
			
			_flashRect.x = x + 1;
			_flashRect.y = y + 1;
			_flashRect.width = width;
			_flashRect.height = height;
			FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
			
			_flashRect.x = x;
			_flashRect.y = y;
			FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
			
			if (palette)
			{
				var i:int;
				for (var _y:int = 0; _y < rows; _y++)
				{
					for (var _x:int = 0; _x < colorsPerRow; _x++)
					{
						i = _y * colorsPerRow + _x;
						
						_flashRect.x = x + 5 + 10 * _x;
						_flashRect.y = y + 5 + 10 * _y;
						_flashRect.width = _flashRect.height = 8;
						FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
						
						_flashRect.x -= 1;
						_flashRect.y -= 1;
						FlxG.camera.buffer.fillRect(_flashRect, colors[palette[i]]);
					}
				}
			}
			
			//super.draw();
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}