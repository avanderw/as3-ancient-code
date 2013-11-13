package avdw.font.dsdigital {
	public class DSDigitalFontNormal {
		[Embed(source = "DS-DIGI.TTF",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "ds-digital",
			fontStyle = "normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
			)]
		private const normal:Class;
		public static const FONT_NAME:String = "ds-digital";
	}
}