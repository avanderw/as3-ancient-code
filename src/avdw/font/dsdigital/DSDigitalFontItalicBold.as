package avdw.font.dsdigital {
	public class DSDigitalFontItalicBold {
		[Embed(source = "DS-DIGIT.TTF",
			mimeType = "application/x-font",
			advancedAntiAliasing = "true",
			fontName = "ds-digital",
			fontStyle = "italic",
			fontWeight = "bold",
			embedAsCFF = "false",
			unicodeRange = "U+0020-007E"
			)]
		private const italic_bold:Class;
		public static const FONT_NAME:String = "ds-digital";
	}
}