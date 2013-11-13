package avdw.font.dsdigital {
	public class DSDigitalFontBold {
		[Embed(source = "DS-DIGIB.TTF",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "ds-digital",
			fontStyle = "normal",
			fontWeight = "bold",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
			)]
		private const bold:Class;
		public static const FONT_NAME:String = "ds-digital";
	}
}