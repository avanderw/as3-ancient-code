package avdw.math.noise {
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CInterpolate {
		public static const NONE:Function = function(t:Number):Number {
			return 0;
		};
		public static const LINEAR:Function = function(t:Number):Number {
			return t;
		};
		public static const HERMITE:Function = function(t:Number):Number {
			return (t * t * (3 - 2 * t));
		};
		public static const QUINTIC:Function = function(t:Number):Number {
			return t * t * t * (t * (t * 6 - 15) + 10);
		};
		
		public function CInterpolate() {
		
		}
		
		public static function linearInterpolate(n0:Number, n1:Number, a:Number):Number {
			return ((1.0 - a) * n0) + (a * n1);
		}
	
	}

}