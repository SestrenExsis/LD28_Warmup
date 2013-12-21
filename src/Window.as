package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.*;
	
	public class Window extends FlxSprite
	{
		public var block:FlxPoint;
		public static var instance:Window;
		public static var group:FlxGroup;
		
		public static const FULL_PALETTE:uint = 0;
		public static const BACKGROUNDs:uint = 1;
		public static const SPRITES:uint = 2;
		
		public var timeClicked:int;
		
		protected var isDragging:Boolean;
		protected var label:FlxText;
		protected var rows:uint;
		protected var columns:uint;
		protected var palette:Array;
		protected var selected:Array;
		
		// Embed images into these BitmapData vars to add column and row headings to a table.
		protected var columnHeaders:BitmapData;
		protected var rowHeaders:BitmapData;
		
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
			spacing = new FlxPoint();
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
						instance = group.members[i];
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