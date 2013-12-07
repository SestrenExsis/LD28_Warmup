package
{
	import org.flixel.*;
	
	public class Palette
	{
		// The 55 colors allowed by the NES's color palette.
		public static var colors:Array = [ 
			0xFF000000, 0xFF0000BC, 0xFF0000FC, 0xFF004058, 0xFF005800,
			0xFF0058F8, 0xFF006800, 0xFF007800, 0xFF0078F8, 0xFF008888,
			0xFF00A800, 0xFF00A844, 0xFF00B800, 0xFF00E8D8, 0xFF00FCFC,
			0xFF3CBCFC, 0xFF4428BC, 0xFF503000, 0xFF58D854, 0xFF58F898,
			0xFF6844FC, 0xFF6888FC, 0xFF787878, 0xFF7C7C7C, 0xFF881400,
			0xFF940084, 0xFF9878F8, 0xFFA4E4FC, 0xFFA80020, 0xFFA81000,
			0xFFAC7C00, 0xFFB8B8F8, 0xFFB8F818, 0xFFB8F8B8, 0xFFB8F8D8,
			0xFFBCBCBC, 0xFFD800CC, 0xFFD8B8F8, 0xFFD8F878, 0xFFE40058,
			0xFFE45C10, 0xFFF0D0B0, 0xFFF83800, 0xFFF85898, 0xFFF87858,
			0xFFF878F8, 0xFFF8A4C0, 0xFFF8B800, 0xFFF8B8F8, 0xFFF8D878,
			0xFFF8D8F8, 0xFFF8F8F8, 0xFFFCA044, 0xFFFCE0A8, 0xFFFCFCFC
		];
		
		//Each of the four 4-color background palettes must share at least one color in common.
		public static var _commonBackgroundColor:uint;
		public static var backgrounds:Array = new Array();
		backgrounds[0] = new Array( 0, 0, 0, 0 );
		backgrounds[1] = new Array( 0, 0, 0, 0 );
		backgrounds[2] = new Array( 0, 0, 0, 0 );
		backgrounds[3] = new Array( 0, 0, 0, 0 );
		
		//Each of the four 4-color sprite palettes must designate one color to be the transparent color.
		public static var _commonSpriteColor:uint;
		public static var sprites:Array = new Array();
		sprites[0] = new Array( 0, 0, 0, 0 );
		sprites[1] = new Array( 0, 0, 0, 0 );
		sprites[2] = new Array( 0, 0, 0, 0 );
		sprites[3] = new Array( 0, 0, 0, 0 );
		
		public static function get commonBackgroundColor():uint
		{
			return colors[_commonBackgroundColor];
		}
		
		public static function set commonBackgroundColor(Value:uint):void
		{
			if (Value >= colors.length)
				Value = 0;
			_commonBackgroundColor = Value;
			for (var i:uint = 0; i < backgrounds.length; i++)
			{
				backgrounds[i] = _commonBackgroundColor;
			}
		}
		
		public static function get commonSpriteColor():uint
		{
			return _commonSpriteColor;
		}
		
		public static function set commonSpriteColor(Value:uint):void
		{
			if (Value >= colors.length)
				Value = 0;
			_commonSpriteColor = Value;
			for (var i:uint = 0; i < sprites.length; i++)
			{
				sprites[i] = _commonSpriteColor;
			}
		}
		
		public static function randomizeBackgroundPalette(Palette:uint):void
		{
			if (Palette >= backgrounds.length)
				return;
			for (var i:uint = 0; i < backgrounds[Palette].length; i++)
			{
				backgrounds[Palette][i] = (uint)(FlxG.random() * colors.length);
			}
		}
		
		public static function randomizeSpritePalette(Palette:uint):void
		{
			if (Palette >= sprites.length)
				return;
			for (var i:uint = 0; i < sprites[Palette].length; i++)
			{
				sprites[Palette][i] = (uint)(FlxG.random() * colors.length);
			}
		}
	}
}