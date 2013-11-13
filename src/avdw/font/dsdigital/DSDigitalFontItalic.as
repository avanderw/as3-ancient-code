package avdw.font.dsdigital {
	public class DSDigitalFontItalic {
		[Embed(source = "DS-DIGII.TTF",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "ds-digital",
			fontStyle = "italic",
			fontWeight = "normal",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
			)]
		private const italic:Class;
		public static const FONT_NAME:String = "ds-digital";
	}
}