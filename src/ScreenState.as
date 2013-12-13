package
{
	import org.flixel.*;
	
	public class ScreenState extends FlxState
	{
		public var gameScreen:FlxSprite;
		public var window:Window;
		public var windows:FlxGroup;
		//public var pattern:PatternTable;
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			windows = new FlxGroup();
			
			window = new GameWindow(FlxG.width - 256 - 8, 0.5 * (FlxG.height - 240));
			windows.add(window);
			
			window = new ColorTable(8, 8, "All");
			(window as ColorTable).loadFullPalette();
			windows.add(window);
			
			window = new ColorTable(8, 71, "Bkgrnd");
			(window as ColorTable).loadRandomPalette(12, 3);
			windows.add(window);
			
			window = new ColorTable(8, 135, "Sprite");
			(window as ColorTable).loadRandomPalette(12, 3)
			windows.add(window);
			
			windows.add(new PatternTable(8, 199));
			
			Window.group = windows;
			add(windows);
			FlxG.bgColor = 0xFF787878;
		}
		
		override public function update():void
		{	
			super.update();
			
			if (FlxG.mouse.justPressed())
				windows.sort("timeClicked");
		}
		
		override public function draw():void
		{
			super.draw();
		}

	}
}