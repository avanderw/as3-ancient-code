package avdw.playground.minesweeper
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class ECell
	{
		public static const Empty:ECell = new ECell("Empty", GraphicAsset.CellEmpty);
		public static const Mine:ECell = new ECell("Mine", GraphicAsset.CellMine);
		public static const One:ECell = new ECell("One", GraphicAsset.CellOne);
		public static const Two:ECell = new ECell("Two", GraphicAsset.CellTwo);
		public static const Three:ECell = new ECell("Three", GraphicAsset.CellThree);
		public static const Four:ECell = new ECell("Four", GraphicAsset.CellFour);
		public static const Five:ECell = new ECell("Five", GraphicAsset.CellFive);
		public static const Six:ECell = new ECell("Six", GraphicAsset.CellSix);
		public static const Seven:ECell = new ECell("Seven", GraphicAsset.CellSeven);
		public static const Eight:ECell = new ECell("Eight", GraphicAsset.CellEight);
		
		public var Type:String; // makes debugging easier
		public var Graphic:BitmapData;
		
		public function ECell(type:String, graphic:BitmapData)
		{
			Type = type;
			Graphic = graphic;
		}
		
		public static function number(num:int):ECell
		{
			switch (num)
			{
				case 0: 
					return Empty;
				case 1: 
					return One;
				case 2: 
					return Two;
				case 3: 
					return Three;
				case 4: 
					return Four;
				case 5: 
					return Five;
				case 6: 
					return Six;
				case 7: 
					return Seven;
				case 8: 
					return Eight;
				default: 
					throw new Error("number is too-large or -small");
			}
		}
	
	}

}