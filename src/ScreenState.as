package
{
	import org.flixel.*;
	
	public class ScreenState extends FlxState
	{
		
		public var colorPalette:ColorTable;
		public var bgPalettes:ColorTable;
		public var sprPalettes:ColorTable;
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = ColorTable.randomColor();
			
			colorPalette = new ColorTable(8, 8);
			colorPalette.loadFullPalette();
			add(colorPalette);
			
			bgPalettes = new ColorTable(8, 71);
			bgPalettes.loadRandomPalette(12, 3);
			add(bgPalettes);
			
			sprPalettes = new ColorTable(8, 127);
			sprPalettes.loadRandomPalette(12, 3);
			add(sprPalettes);
		}
		
		override public function update():void
		{	
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
		}

	}
}