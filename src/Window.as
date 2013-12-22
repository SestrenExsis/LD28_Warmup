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
		
		public var timeClicked:int;
		
		protected var isDragging:Boolean;
		protected var label:FlxText;
		protected var rows:uint;
		protected var columns:uint;
		protected var palette:Array;
		public var selected:Array;
		
		// Embed images into these BitmapData vars to add column and row headings to a table.
		protected var columnHeaders:BitmapData;
		protected var rowHeaders:BitmapData;
		
		public var titleBarHeight:Number = 10;
		public var buffer:FlxPoint;
		public var spacing:FlxPoint;
		public var partitions:FlxPoint;
		public var partitionSize:FlxPoint;
				
		public function Window(X:Number, Y:Number, Label:String = "")
		{
			super(X, Y);
			
			block = new FlxPoint(8, 8);
			//labels = new FlxGroup();
			//labels.add(label);
			
			//var label:FlxText = new FlxText(X, Y, 48, Label);
			label = new FlxText(X, Y, 48, Label);
			label.color = 0x000000;
			
			timeClicked = getTimer();
			buffer = new FlxPoint(2, 2);
			spacing = new FlxPoint();
			
			ID = UNDEFINED;
		}
		
		protected static function selectTableElement(TableID:int, Element:int):Boolean
		{
			var i:int;
			var member:Window;
			do
			{
				member = group.members[i] as Window;
				i++;
			} while (member.ID != TableID);
			
			member.clearSelections();
			member.selected[Element] = true;
			
			if (member.ID == PALETTES)
			{
				selectTableElement(COLORS, member.palette[Element]);
			}
			else if (member.ID == COLORS)
			{
				changeTableElement(PALETTES, member.palette[Element]);
			}
			
			return true;
		}
		
		protected static function changeTableElement(TableID:int, NewValue:int):Boolean
		{
			var i:int;
			var member:Window;
			do
			{
				member = group.members[i] as Window;
				i++;
			} while (member.ID != TableID);
			
			var _valueChanged:Boolean = false;
			var _oldValue:int;
			var element:int;
			for (i = 0; i < member.palette.length; i++)
			{
				if (member.selected[i])
				{
					_oldValue = member.palette[i];
					member.palette[i] = NewValue;
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
		
		protected function clearSelections():Boolean
		{
			var _selectionChanged:Boolean = false;
			if (selected)
			{
				for (var i:int = 0; i < palette.length; i++)
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
			
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(FlxG.camera);
		}
	}
}