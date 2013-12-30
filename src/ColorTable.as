package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class ColorTable extends Window
	{
		[Embed(source="../assets/images/paletteColumnHeaders.png")] public var imgColumnHeaders:Class;
		[Embed(source="../assets/images/paletteRowHeaders.png")] public var imgRowHeaders:Class;
		
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
			
			setBackgroundColor();
			
			spacing.x = 0;
			spacing.y = 0;
		}
		
		public function setBackgroundColor(Index:int = -1):void
		{
			// When changing the background color, the tileset graphic needs to be refreshed. This is currently not implemented.
			
			if (Index >= colors.length) return;
			if (Index < 0) _bgColor = (int)(FlxG.random() * colors.length);
			else _bgColor = Index;
			
			if (elements)
			{
				for (var i:int = 0; i < columns; i++)
				{
					elements[i] = _bgColor;
				}
			}
			FlxG.bgColor = bgColor();
		}
		
		public static function bgColor():uint
		{
			return colors[_bgColor];
		}
		
		public static function randomColor():uint
		{
			return colors[(int)(FlxG.random() * colors.length)];
		}
		
		public function getColorPalette():Array
		{
			var _column:int = lastSelectedIndex % columns;
			var paletteArray:Array = new Array(rows);
			for (var i:int = 0; i < paletteArray.length; i++)
			{
				paletteArray[i] = colors[elements[_column + columns * i]];
			}
			return paletteArray;
		}
		
		public function loadPalette(NumColors:uint = 3, Columns:uint = 3):Array
		{
			ID = PALETTES;
			if (NumColors >= colors.length)
				NumColors = colors.length;
			
			elements = new Array(NumColors);
			selected = new Array(NumColors);
			columns = Columns;
			rows = Math.ceil(elements.length / columns);
			
			columnHeaders = FlxG.addBitmap(imgColumnHeaders);
			rowHeaders = FlxG.addBitmap(imgRowHeaders);
			partitionSize = new FlxPoint()
			partitionSize.x = Math.min(columns, (int)(columnHeaders.width / block.x));
			partitionSize.y = Math.min(rows, (int)(rowHeaders.height / block.y));
			partitions = new FlxPoint(Math.ceil(columns / partitionSize.x), Math.ceil(rows / partitionSize.y));
			
			spacing.x = 2;
			spacing.y = 0;
			buffer.x = 2;
			buffer.y = 2;

			width = 2 * buffer.x + (block.x + spacing.x) * Math.max(2, columns + partitions.x) - spacing.x;
			height = titleBarHeight + 2 * buffer.y + (block.y + spacing.y) * (rows + partitions.y) - spacing.y;

			randomize(0, NumColors);
			clearSelections();
			selectTableElement(ID, 0);

			return elements;
		}
		
		public function loadTileEditor():Array
		{
			ID = TILE_EDITOR;
			
			elements = new Array(64);
			selected = new Array(64);
			columns = 8;
			rows = 8;
			
			/*columnHeaders = FlxG.addBitmap(imgColumnHeaders);
			rowHeaders = FlxG.addBitmap(imgRowHeaders);
			partitionSize = new FlxPoint()
			partitionSize.x = Math.min(columns, (int)(columnHeaders.width / block.x));
			partitionSize.y = Math.min(rows, (int)(rowHeaders.height / block.y));
			partitions = new FlxPoint(Math.ceil(columns / partitionSize.x), Math.ceil(rows / partitionSize.y));*/
			
			spacing.x = 1;
			spacing.y = 1;
			buffer.x = 2;
			buffer.y = 2;
			
			width = 2 * buffer.x + (block.x + spacing.x) * Math.max(2, columns + partitions.x) - spacing.x;
			height = titleBarHeight + 2 * buffer.y + (block.y + spacing.y) * (rows + partitions.y) - spacing.y;
			
			for (var i:int = 0; i < elements.length; i++)
			{
				elements[i] = PatternTable.INDEX0;
				selected[i] = false;
			}
			return elements;
		}
		
		public function randomize(StartingIndex:uint = 0, EndingIndex:uint = 1):void
		{
			if (!elements) return;
			if (EndingIndex < StartingIndex) EndingIndex = StartingIndex;
			if (EndingIndex > elements.length) return;
			
			for (var i:int = StartingIndex; i <= EndingIndex; i++)
			{
				if (i < columns) elements[i] = _bgColor;
				else 
				{
					elements[i] = (int)(FlxG.random() * (colors.length - i));
					var lastOffset:int = 0;
					var offset:int = 0;
					do
					{
						lastOffset = offset;
						offset = 0;
						for (var j:int = 0; j < i; j++)
						{
							if (elements[j] <= elements[i] + lastOffset)
								offset++;
						}
					} while (offset > lastOffset);
					elements[i] += offset;
				}
			}
		}
		
		public function loadColors(Columns:uint = 14):Array
		{
			ID = COLORS;
			elements = new Array(colors.length);
			selected = new Array(colors.length);
			columns = Columns;
			rows = (int)(elements.length / columns);
			partitions = null;
			spacing.x = 0;
			spacing.y = 0;
			
			for (var i:int = 0; i < elements.length; i++)
			{
				elements[i] = i;
				selected[i] = false;
			}
			buffer.x = 2;
			buffer.y = 2;
			width = 2 * buffer.x + (block.x + spacing.x) * Math.max(2, columns) - spacing.x
			height = titleBarHeight + 2 * buffer.y + (block.y + spacing.y) * rows - spacing.y;
			
			return elements;
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function drawElement(ElementIndex:int):void
		{
			FlxG.camera.buffer.fillRect(_flashRect, colors[elements[ElementIndex]]);
		}
		
		override public function draw():void
		{
			super.draw();
		}
	}
}