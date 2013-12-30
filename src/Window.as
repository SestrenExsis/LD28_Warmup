package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class Window extends FlxSprite
	{
		public var block:FlxPoint;
		public static var group:FlxGroup;
		
		public static const UNDEFINED:int = 999;
		public static const COLORS:int = 0;
		public static const PALETTES:int = 1;
		public static const TILESET:int = 2;
		public static const TILE_EDITOR:int = 3;
		
		public var timeClicked:int;
		
		protected var isDragging:Boolean;
		protected var label:FlxText;
		protected var rows:uint;
		protected var columns:uint;
		protected var elements:Array;
		public var selected:Array;
		public var lastSelectedIndex:uint;
		
		// Embed images into these BitmapData vars to add column and row headings to a table.
		protected var columnHeaders:BitmapData;
		protected var rowHeaders:BitmapData;
		
		public var titleBarHeight:Number = 12;
		public var buffer:FlxPoint;
		public var spacing:FlxPoint;
		public var partitions:FlxPoint;
		public var partitionSize:FlxPoint;
				
		public function Window(X:Number, Y:Number, Label:String = "")
		{
			super(X, Y);
			
			block = new FlxPoint(8, 8);
			label = new FlxText(X, Y, 72, Label);
			label.color = 0x000000;
			
			timeClicked = getTimer();
			buffer = new FlxPoint(2, 2);
			spacing = new FlxPoint();
			
			ID = UNDEFINED;
		}
		
		protected static function selectTableElement(TableID:int, Element:int):Boolean
		{
			var member:Window = getTableByID(TableID);
			member.clearSelections();
			member.selected[Element] = true;
			member.lastSelectedIndex = Element;
			
			var _currentPalette:Array
			if (member.ID == PALETTES)
			{
				selectTableElement(COLORS, member.elements[Element]);
				_currentPalette = (member as ColorTable).getColorPalette();
				member = getTableByID(TILESET);
				(member as PatternTable).changePalette(_currentPalette);
			}
			else if (member.ID == COLORS)
			{
				changeTableElement(PALETTES, member.elements[Element]);
				//selectTableElement(PALETTES, member.elements[Element]);
				member = getTableByID(PALETTES);
				_currentPalette = (member as ColorTable).getColorPalette();
				member = getTableByID(TILESET);
				(member as PatternTable).changePalette(_currentPalette);
			}
			
			return true;
		}
		
		protected static function changeTableElement(TableID:int, NewValue:int):Boolean
		{
			var member:Window = getTableByID(TableID);
			
			var _valueChanged:Boolean = false;
			var _oldValue:int;
			var element:int;
			for (var i:int = 0; i < member.elements.length; i++)
			{
				if (member.selected[i])
				{
					_oldValue = member.elements[i];
					member.elements[i] = NewValue;
					if (_oldValue != NewValue)
						_valueChanged = true;
					
					// If we're changing one of the fixed colors (like the background or sprite transparency color), then change
					// the displayed background color and all other fixed colors.
					if (TableID == PALETTES)
					{
						if (i < member.columns)
							(member as ColorTable).setBackgroundColor(NewValue);
					}
				}
			}
			
			return _valueChanged;
		}
		
		protected static function getTableByID(TableID:int):Window
		{
			var i:int;
			var member:Window;
			do
			{
				member = group.members[i] as Window;
				i++;
			} while (member.ID != TableID && i < group.members.length);
			if (member.ID == TableID)
				return member;
			else
				return null;
		}
		
		protected function clearSelections():Boolean
		{
			var _selectionChanged:Boolean = false;
			if (selected)
			{
				for (var i:int = 0; i < elements.length; i++)
				{
					if (selected[i] == true)
						_selectionChanged = true;
					selected[i] = false;
				}
			}
			
			return _selectionChanged;
		}
		
		override public function update():void
		{
			super.update();
			
			var _currentHeight:Number = height;
			height = 12;
			var _overlaps:Boolean = overlapsPoint(FlxG.mouse);
			height = _currentHeight;
			
			if (FlxG.mouse.justPressed() && _overlaps)
			{
				var maxTime:int = 0;
				if (group)
				{
					for (var i:uint = 0; i < group.length; i++)
					{
						var instance:Window = group.members[i];
						_overlaps = instance.overlapsPoint(FlxG.mouse);
						if (_overlaps && instance.timeClicked > maxTime)
							maxTime = instance.timeClicked;
					}
				}
				if (timeClicked >= maxTime)
				{
					offset.x = FlxG.mouse.x - x;
					offset.y = FlxG.mouse.y - y;
					isDragging = true;
					timeClicked = getTimer();
				}
			}
			if (isDragging)
			{
				label.x = x = FlxG.mouse.x - offset.x;
				label.y = y = FlxG.mouse.y - offset.y;
			}
			if (FlxG.mouse.justReleased())
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
			FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
			
			_flashRect.x = x + 1;
			_flashRect.y = y + 8;
			_flashRect.width -= 2;
			_flashRect.height = 3;
			FlxG.camera.buffer.fillRect(_flashRect, 0xFFA4E4FC);
			
			label.draw();
			
			if (elements)
			{				
				var partitionX:int = 0;
				var partitionY:int = 0;
				var i:int;
				for (var _y:int = 0; _y < rows; _y++)
				{
					for (var _x:int = 0; _x < columns; _x++)
					{
						i = _y * columns + _x;
						
						_flashRect.width = block.x;
						_flashRect.height = block.y;
						
						// if row or column headers are present, then move drawn segments over based on what partition they are in
						if (partitionSize)
						{
							partitionX = (int)(_x / partitionSize.x) + 1;
							partitionY = (int)(_y / partitionSize.y) + 1;
						}
						
						if (partitions)
						{
							if ((_y % partitionSize.y) == 0)
							{
								_flashPoint.x = x + buffer.x + (block.x + spacing.x) * (_x + partitionX);
								_flashPoint.y = y + titleBarHeight + buffer.y + (block.y + spacing.y) * (_y + partitionY - 1);
								_flashRect.x = (_x % partitionSize.x) * block.x;
								_flashRect.y = ((partitionY - 1) % partitionSize.y) * block.y;
								FlxG.camera.buffer.copyPixels(columnHeaders, _flashRect, _flashPoint, null, null, true);
							}
							if ((_x % partitionSize.x) == 0)
							{
								_flashPoint.x = x + buffer.x + (block.x + spacing.x) * (_x + partitionX - 1);
								_flashPoint.y = y + titleBarHeight + buffer.y + (block.y + spacing.y) * (_y + partitionY);
								_flashRect.x = ((partitionX - 1) % partitionSize.x) * block.x;
								_flashRect.y = (_y % partitionSize.y) * block.y;
								FlxG.camera.buffer.copyPixels(rowHeaders, _flashRect, _flashPoint, null, null, true);
							}
						}
						
						_flashRect.x = x + buffer.x + (block.x + spacing.x) * (_x + partitionX);
						_flashRect.y = y + titleBarHeight + buffer.y + (block.y + spacing.y) * (_y + partitionY);
						
						drawElementBackground(i);
						
						// Place a selection box around the last color clicked on
						if (selected)
						{
							if (FlxG.mouse.x >= _flashRect.x && FlxG.mouse.x <= _flashRect.x + _flashRect.width &&
								FlxG.mouse.y >= _flashRect.y && FlxG.mouse.y <= _flashRect.y + _flashRect.height)
							{
								if (FlxG.mouse.justPressed())
									selectTableElement(ID, i);
							}
							
							if (selected[i])
							{
								FlxG.camera.buffer.fillRect(_flashRect, 0xff000000);
								_flashRect.x += 1;
								_flashRect.y += 1;
								_flashRect.width -= 2;
								_flashRect.height -= 2;
								FlxG.camera.buffer.fillRect(_flashRect, 0xffffffff);
								_flashRect.x += 1;
								_flashRect.y += 1;
								_flashRect.width -= 2;
								_flashRect.height -= 2;
							}
						}
						
						drawElement(i);
					}
				}
			}
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
		
		public function drawElementBackground(ElementIndex:int):void
		{

		}
		
		public function drawElement(ElementIndex:int):void
		{
			
		}
	}
}