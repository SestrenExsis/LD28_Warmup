package
{
	import org.flixel.*;
	
	public class ScreenState extends FlxState
	{
		public var palette:ColorTable;
		public var palettes:FlxGroup;
		
		public var full:ColorTable;
		public var background:ColorTable;
		public var sprite:ColorTable;
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			palettes = new FlxGroup();
			
			palette = new ColorTable(8, 8);
			palette.loadFullPalette();
			palettes.add(palette);
			
			palette = new ColorTable(8, 71);
			palette.loadRandomPalette(12, 3);
			palettes.add(palette);
			
			palette = new ColorTable(8, 127);
			palette.loadRandomPalette(12, 3)
			palettes.add(palette);
			
			add(palettes);
			
			FlxG.bgColor = ColorTable.randomColor();
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