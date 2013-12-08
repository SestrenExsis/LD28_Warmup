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
			
			Palette.bgColor = Palette.randomColors(1)[0];
			FlxG.bgColor = Palette.colors[Palette.bgColor];

			Palette.backgrounds[0] = Palette.randomColors(3).slice();
			Palette.backgrounds[1] = Palette.randomColors(3).slice();
			Palette.backgrounds[2] = Palette.randomColors(3).slice();
			Palette.backgrounds[3] = Palette.randomColors(3).slice();
			
			Palette.sprites[0] = Palette.randomColors(3).slice();
			Palette.sprites[1] = Palette.randomColors(3).slice();
			Palette.sprites[2] = Palette.randomColors(3).slice();
			Palette.sprites[3] = Palette.randomColors(3).slice();
		}
		
		override public function update():void
		{	
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
			for (var y:int = 0; y < Palette.backgrounds.length; y++)
			{
				for (var x:int = 0; x < Palette.backgrounds[y].length; x++)
				{
					Palette.fillRect.x = 16 + 12 * x;
					Palette.fillRect.y = 16 + 12 * y;
					FlxG.camera.buffer.fillRect(Palette.fillRect, Palette.colors[Palette.backgrounds[y][x]]);
					
					Palette.fillRect.x = 16 + 12 * (x + 4);
					FlxG.camera.buffer.fillRect(Palette.fillRect, Palette.colors[Palette.sprites[y][x]]);
				}
			}
		}

	}
}