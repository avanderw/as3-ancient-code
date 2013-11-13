package avdw.lsystem {
	
	public class LSystem {
		public var grammar:LSystemGrammar;
		public var expansion:String;
		
		private var _rules:Object = new Object();
		private var _axiom:String;
		
		public function LSystem(axiom:String, rules:Array, grammar:Array) {
			_axiom = axiom;
			
			var rule:String;
			for each (rule in rules) {
				_rules[rule.substr(0, rule.indexOf("->"))] = rule.substr(rule.indexOf("->") + 2);
			}
			
			expansion = _axiom;
			this.grammar = new LSystemGrammar(grammar);
		}
		
		public function evolve(generations:int = 1):LSystem {
			expansion = _axiom;
			
			var i:int;
			for (i = 0; i < generations; i++) {
				expand();
			}
			
			return this;
		}
		
		private function expand():void {
			var index:String;
			var tmp:String = "";
			
			var exp:Array = expansion.split("");
			for (index in exp) {
				if (_rules[exp[index]] != undefined) {
					tmp += _rules[exp[index]];
				} else {
					tmp += exp[index];
				}
			}
			expansion = tmp;
		}
	}

}