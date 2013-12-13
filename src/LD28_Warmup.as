package
{
	import org.flixel.FlxGame;
	[SWF(width="900", height="600", backgroundColor="#888888")]
	
	public class LD28_Warmup extends FlxGame
	{
		public function LD28_Warmup()
		{
			super(450, 300, ScreenState, 2.0, 60, 60, true);
			forceDebugger = true;
		}
	}
}