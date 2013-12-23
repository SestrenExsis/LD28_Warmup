package
{
	import org.flixel.*;
	
	public class ScreenState extends FlxState
	{
		public var gameScreen:FlxSprite;
		public var windows:FlxGroup;
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFF787878;
			
			var colorTable:ColorTable;
			var patternTable:PatternTable;

			windows = new FlxGroup();
			Window.group = windows;
			add(windows);
			
			windows.add(new GameWindow(FlxG.width - GameWindow.screenWidth - 8, 0.5 * (FlxG.height - GameWindow.screenHeight)));
			
			colorTable = new ColorTable(8, 8, "Colors");
			windows.add(colorTable);
			colorTable.loadColors();
			
			patternTable = new PatternTable(8, 122);
			windows.add(patternTable);
			
			colorTable = new ColorTable(8, 61, "Palettes");
			windows.add(colorTable);
			colorTable.loadPalette(32, 8);
			
			patternTable.changePalette(colorTable.getColorPalette());
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