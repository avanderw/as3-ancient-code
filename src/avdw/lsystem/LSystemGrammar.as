package avdw.lsystem {
	
	public class LSystemGrammar {
		
		static public const DEFAULT:Array = [["F", LSystemPainter.DRAW], ["G", LSystemPainter.DRAW], ["+", LSystemPainter.ROTATE_LEFT], ["-", LSystemPainter.ROTATE_RIGHT], ["[", LSystemPainter.STATE_SAVE], ["]", LSystemPainter.STATE_RESTORE], ["X", LSystemPainter.DO_NOTHING], ["Y", LSystemPainter.DO_NOTHING]];
		
		public const actions:Object = new Object();
		
		public function LSystemGrammar(actions:Array) {
			var action:Array;
			
			for each (action in actions) {
				this.actions[action[0]] = action[1];
			}
		}
	}
}