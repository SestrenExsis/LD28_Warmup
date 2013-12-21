package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class ColorTable extends Window
	{
		public static const COLORS:uint = 0;
		public static const PALETTES:uint = 1;
		
		protected static var _bgColor:uint;
		
		// The 55 colors allowed by the NES's color palette.
		public static var colors:Array = [ 
			0xFF7C7C7C, 0xFF0000FC, 0xFF0000BC, 0xFF4428BC, 0xFF940084, 0xFFA80020, 0xFFA81000, 0xFF881400, 0xFF503000, 0xFF007800, 0xFF006800, 0xFF005800, 0xFF004058, 0xFF000000,
			0xFFBCBCBC, 0xFF0078F8, 0xFF0058F8, 0xFF6844FC, 0xFFD800CC, 0xFFE40058, 0xFFF83800, 0xFFE45C10, 0xFFAC7C00, 0xFF00B800, 0xFF00A800, 0xFF00A844, 0xFF008888, 0xFF000000,
			0xFFF8F8F8, 0xFF3CBCFC, 0xFF6888FC, 0xFF9878F8, 0xFFF878F8, 0xFFF85898, 0xFFF87858, 0xFFFCA044, 0xFFF8B800, 0xFFB8F818, 0xFF58D854, 0xFF58F898, 0xFF00E8D8, 0xFF787878,
			0xFFFCFCFC, 0xFFA4E4FC, 0xFFB8B8F8, 0xFFD8B8F8, 0xFFF8B8F8, 0xFFF8A4C0, 0xFFF0D0B0, 0xFFFCE0A8, 0xFFF8D878, 0xFFD8F878, 0xFFB8F8B8, 0xFFB8F8D8, 0xFF00FCFC, 0xFFF8D8F8
		];
		
		public function ColorTable(X:Number, Y:Number, Label:String = "")
		{
			super(X, Y, Label);
			
			spacing.x = 0;
			spacing.y = 0;
		}
		
		public function setBackgroundColor(Index:int = -1):void
		{
			if (Index >= colors.length) return;
			if (Index < 0) _bgColor = (int)(FlxG.random() * colors.length);
			else _bgColor = Index;
			
			if (palette)
			{
				for (var i:int = 0; i < selected.length; i++)
				{
					selected[i] = false;
				}
			}
		}
		
		public static function bgColor():uint
		{
			return colors[_bgColor];
		}
		
		public static function randomColor():uint
		{
			return colors[(int)(FlxG.random() * colors.length)];
		}
		
		public function loadPalette(NumColors:uint = 3, ColorsPerRow:uint = 3):Array
		{
			if (NumColors >= colors.length)
				NumColors = colors.length;
			columns = ColorsPerRow;
			palette = new Array(NumColors);
			selected = new Array(NumColors);
			for (var i:int = 0; i < selected.length; i++)
			{
				selected[i] = false;
			}
			randomize(0, NumColors);
			
			rows = (int)(palette.length / columns);
			width = 16 + ((8 + spacing.x) * Math.max(2, columns));
			height = 16 + ((8 + spacing.y) * Math.max(1, rows));
			
			// Adjust width and height for divider
			divider.x = 4;
			divider.y = -1;
			if (divider.x >= 0)
				width += 4;
			if (divider.y >= 0)
				height += 4;
			
			return palette;
		}
		
		public function randomize(StartingIndex:uint = 0, EndingIndex:uint = 1):void
		{
			if (!palette) return;
			if (EndingIndex < StartingIndex) EndingIndex = StartingIndex;
			if (EndingIndex > palette.length) return;
			
			for (var i:int = StartingIndex; i <= EndingIndex; i++)
			{
				if (i < columns) palette[i] = _bgColor;
				else 
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
			}
			spacing.x = 2;
		}
		
		public function loadColors(Columns:uint = 14):Array
		{
			columns = Columns;
			palette = new Array(colors.length);
			selected = new Array(colors.length);
			for (var i:int = 0; i < palette.length; i++)
			{
				palette[i] = i;
				selected[i] = false;
			}
			
			rows = (int)(palette.length / columns);
			width = 8 + ((8 + spacing.x) * Math.max(4,columns));
			height = 16 + ((8 + spacing.y) * Math.max(1,rows));
			
			// Adjust width and height for divider, if any
			if (divider.x >= 0)
				width += 4;
			if (divider.y >= 0)
				height += 4;
			
			return palette;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
			
			if (palette)
			{
				var i:int;
				for (var _y:int = 0; _y < rows; _y++)
				{
					for (var _x:int = 0; _x < columns; _x++)
					{
						i = _y * columns + _x;
						if (divider.x >= 0 && _x >= divider.x) _flashRect.x = 4;
						else _flashRect.x = 0;
						if (divider.y >= 0 && _y >= divider.y) _flashRect.y = 4;
						else _flashRect.y = 0;
						
						_flashRect.x += x + 4 + (8 + spacing.x) * _x;
						_flashRect.y += y + 12 + (8 + spacing.y) * _y;
						_flashRect.width = _flashRect.height = 9;
						
						if (selected)
						{
							if (FlxG.mouse.x >= _flashRect.x && FlxG.mouse.x <= _flashRect.x + _flashRect.width &&
								FlxG.mouse.y >= _flashRect.y && FlxG.mouse.y <= _flashRect.y + _flashRect.height)
							{
								if (FlxG.mouse.justPressed())
									selected[i] = !selected[i];
							}
						}
						_flashRect.x += 1;
						_flashRect.y += 1;
						_flashRect.width = _flashRect.height = 8;
						if (!selected || !selected[i])
						{
							FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
							_flashRect.x -= 1;
							_flashRect.y -= 1;
						}
						FlxG.camera.buffer.fillRect(_flashRect, colors[palette[i]]);
					}
				}
			}
		}
	}
}