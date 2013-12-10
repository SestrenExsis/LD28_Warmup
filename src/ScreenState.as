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
			
			palette = new ColorTable(8, 8, "All");
			palette.loadFullPalette();
			palettes.add(palette);
			
			palette = new ColorTable(8, 71, "BG");
			palette.loadRandomPalette(12, 3);
			palettes.add(palette);
			
			palette = new ColorTable(8, 135, "Spr");
			palette.loadRandomPalette(12, 3)
			palettes.add(palette);
			
			palette = new ColorTable(8, 199, "Test");
			palette.loadRandomPalette(0, 0)
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