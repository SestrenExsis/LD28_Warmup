package
{
	import org.flixel.*;
	
	public class ScreenState extends FlxState
	{
		
		public function ScreenState()
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			Palette.randomizeBackgroundPalette(0);
			Palette.randomizeBackgroundPalette(1);
			Palette.randomizeBackgroundPalette(2);
			Palette.randomizeBackgroundPalette(3);
			var _palette:uint = (uint)(FlxG.random() * Palette.backgrounds.length);
			var _index:uint = (uint)(FlxG.random() * Palette.backgrounds[_palette].length);
			FlxG.bgColor = Palette.colors[Palette.backgrounds[_palette][_index]];
		}
		
		override public function update():void
		{	
			super.update();
		}

	}
}