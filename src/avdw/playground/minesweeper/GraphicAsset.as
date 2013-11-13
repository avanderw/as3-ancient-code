package avdw.playground.minesweeper
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class GraphicAsset
	{
		[Embed(source="hidden.png")]
		private static const CellHiddenGfx:Class;
		[Embed(source="empty.png")]
		private static const CellEmptyGfx:Class;
		[Embed(source="mine.png")]
		private static const CellMineGfx:Class;
		[Embed(source="one.png")]
		private static const CellOneGfx:Class;
		[Embed(source="two.png")]
		private static const CellTwoGfx:Class;
		[Embed(source="three.png")]
		private static const CellThreeGfx:Class;
		[Embed(source="four.png")]
		private static const CellFourGfx:Class;
		[Embed(source="five.png")]
		private static const CellFiveGfx:Class;
		[Embed(source="six.png")]
		private static const CellSixGfx:Class;
		[Embed(source="seven.png")]
		private static const CellSevenGfx:Class;
		[Embed(source="eight.png")]
		private static const CellEightGfx:Class;
		[Embed(source="speculate.png")]
		private static const CellSpeculationGfx:Class;
		[Embed(source="highlight.png")]
		private static const CellHighlightGfx:Class;
		
		public static const CellHidden:BitmapData = getBitmapData(new CellHiddenGfx());
		public static const CellEmpty:BitmapData = getBitmapData(new CellEmptyGfx());
		public static const CellMine:BitmapData = getBitmapData(new CellMineGfx());
		public static const CellOne:BitmapData = getBitmapData(new CellOneGfx());
		public static const CellTwo:BitmapData = getBitmapData(new CellTwoGfx());
		public static const CellThree:BitmapData = getBitmapData(new CellThreeGfx());
		public static const CellFour:BitmapData = getBitmapData(new CellFourGfx());
		public static const CellFive:BitmapData = getBitmapData(new CellFiveGfx());
		public static const CellSix:BitmapData = getBitmapData(new CellSixGfx());
		public static const CellSeven:BitmapData = getBitmapData(new CellSevenGfx());
		public static const CellEight:BitmapData = getBitmapData(new CellEightGfx());
		public static const CellSpeculation:BitmapData = getBitmapData(new CellSpeculationGfx());
		public static const CellHighlight:BitmapData = getBitmapData(new CellHighlightGfx());
		
		public function GraphicAsset()
		{
		}
		
		private static function getBitmapData(bitmap:Bitmap):BitmapData
		{
			return bitmap.bitmapData;
		}
	
	}

}