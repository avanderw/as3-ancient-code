package avdw.lsystem {
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class SavedLSystem {
		static public const FRACTAL_PLANT:SavedLSystem = new SavedLSystem("X", ["X->F-[[X]+X]+F[+FX]-X", "F->FF"], LSystemGrammar.DEFAULT, 25, 1, 6, "Fractal Plant");
		static public const DRAGON_CURVE:SavedLSystem = new SavedLSystem("FX", ["X->X+YF", "Y->FX-Y"], LSystemGrammar.DEFAULT, 90, 5, 10, "Dragon Curve");
		static public const KOCK_CURVE:SavedLSystem = new SavedLSystem("F", ["F->F+F-F-F+F"], LSystemGrammar.DEFAULT, 90, 4, 3, "Kock Curve");
		static public const SIERPINSKI_TRIANGLE_01:SavedLSystem = new SavedLSystem("F", ["F->G-F-G", "G->F+G+F"], LSystemGrammar.DEFAULT, 60, 5, 5, "Sierpinski Triangle 1");
		static public const SIERPINSKI_TRIANGLE_02:SavedLSystem = new SavedLSystem("F-G-G", ["F->F-G+F+G-F", "G->GG"], LSystemGrammar.DEFAULT, 120, 10, 4, "Sierpinski Triangle 2");
		static public const JOINED_CROSS_CURVES:SavedLSystem = new SavedLSystem("XYXYXYX+XYXYXYX+XYXYXYX+XYXYXYX", ["F->", "X->FX+FX+FXFY-FY-", "Y->+FX+FXFY-FY-FY"], LSystemGrammar.DEFAULT, 90, 3, 3, "Joined Cross Curves");
		
		static public const SystemList:Array = new Array();
		
		{
			SystemList.push(FRACTAL_PLANT);
			SystemList.push(DRAGON_CURVE);
			SystemList.push(KOCK_CURVE);
			SystemList.push(SIERPINSKI_TRIANGLE_01);
			SystemList.push(SIERPINSKI_TRIANGLE_02);
			SystemList.push(JOINED_CROSS_CURVES);
		}
		
		public var label:String;
		public var axiom:String;
		public var rules:Array;
		public var grammar:Array;
		public var angle:Number;
		public var evolve:int;
		public var length:Number;
		
		public function SavedLSystem(axiom:String, rules:Array, grammar:Array, angle:Number, length:Number, evolve:int, name:String) {
			this.axiom = axiom;
			this.rules = rules;
			this.grammar = grammar;
			this.angle = angle;
			this.length = length;
			this.evolve = evolve;
			this.label = name;
		}
	}

}