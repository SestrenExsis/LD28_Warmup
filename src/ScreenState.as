package
{
	import org.flixel.*;
	
	public class ScreenState extends FlxState
	{
		public var gameScreen:FlxSprite;
		public var window:Window;
		public var windows:FlxGroup;
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFF787878;

			windows = new FlxGroup();
			Window.group = windows;
			add(windows);
			
			windows.add(new GameWindow(FlxG.width - GameWindow.screenWidth - 8, 0.5 * (FlxG.height - GameWindow.screenHeight)));
			
			window = new ColorTable(8, 8, "Colors");
			windows.add(window);
			(window as ColorTable).loadColors();
			
			window = new ColorTable(8, 61, "Palettes");
			windows.add(window);
			(window as ColorTable).loadPalette(32, 8);
			
			windows.add(new PatternTable(8, 122));
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