package
{
	import org.flixel.FlxGame;
	[SWF(width="512", height="480", backgroundColor="#888888")]
	
	public class LD28_Warmup extends FlxGame
	{
		public function LD28_Warmup()
		{
			super(256, 240, ScreenState, 2.0, 60, 60, true);
			forceDebugger = true;
		}
	}
}