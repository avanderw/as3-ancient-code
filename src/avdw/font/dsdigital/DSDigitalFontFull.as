package avdw.font.dsdigital {
	public class DSDigitalFontFull {
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