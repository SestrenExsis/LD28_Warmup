package
{
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	
	public class Palette
	{
		public static var fillRect:Rectangle = new Rectangle(0, 0, 8, 8);
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
		
		public static var bgColor:uint;
		
		// Each of the four background palettes contains 3 colors, plus an implicit transparency color
		// which will let the bgColor show through
		public static var backgrounds:Array = new Array();
		backgrounds[0] = new Array( 0, 0, 0 );
		backgrounds[1] = new Array( 0, 0, 0 );
		backgrounds[2] = new Array( 0, 0, 0 );
		backgrounds[3] = new Array( 0, 0, 0 );
		
		// Each of the four sprite palettes contains 3 colors, plus an implicit transparency color
		public static var sprites:Array = new Array();
		sprites[0] = new Array( 0, 0, 0 );
		sprites[1] = new Array( 0, 0, 0 );
		sprites[2] = new Array( 0, 0, 0 );
		sprites[3] = new Array( 0, 0, 0 );
		
		public static function randomColors(NumColors:uint = 3):Array
		{
			if (NumColors >= colors.length) NumColors = colors.length;
			var colorArray:Array = new Array(NumColors);
			
			for (var i:int = 0; i < colorArray.length; i++)
			{
				colorArray[i] = (int)(FlxG.random() * colors.length - i);
				var lastOffset:int = 0;
				var offset:int = 0;
				do
				{
					lastOffset = offset;
					offset = 0;
					for (var j:int = 0; j < i; j++)
					{
						if (colorArray[j] <= colorArray[i] + lastOffset)
							offset++;
					}
				} while (offset > lastOffset);
				colorArray[i] += offset;
			}
			return colorArray;
		}
	}
}