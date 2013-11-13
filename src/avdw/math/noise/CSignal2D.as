package avdw.math.noise {
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CSignal2D {
		private static const X_NOISE_GEN:int = 1619;
		private static const Y_NOISE_GEN:int = 31337;
		private static const SEED_NOISE_GEN:int = 1013;
		private static const SHIFT_NOISE_GEN:int = 13;
		
		public static const GRADIENT:Function = function(x:Number, y:Number, seed:uint, interp:Function):Number {
			// create unit-length square around the point
			var x0:Number = Math.floor(x);
			var y0:Number = Math.floor(y);
			var x1:Number = x0 + 1;
			var y1:Number = y0 + 1;
			
			// map the difference to the coordinate s-curve
			var xs:Number = interp(x - x0);
			var ys:Number = interp(y - y0);
			
			// create noise for each vertex
			var n0:Number = gradient(x, y, x0, y0, seed);
			var n1:Number = gradient(x, y, x1, y0, seed);
			var ix0:Number = CInterpolate.linearInterpolate(n0, n1, xs);
			
			n0 = gradient(x, y, x0, y1, seed);
			n1 = gradient(x, y, x1, y1, seed);
			var ix1:Number = CInterpolate.linearInterpolate(n0, n1, xs);
			
			return CInterpolate.linearInterpolate(ix0, ix1, ys);
		};
		
		public function CSignal2D() {
		
		}
		
		private static function gradient(x:Number, y:Number, ix:int, iy:int, seed:uint):Number {
			// select gradients
			var index:int = (X_NOISE_GEN * ix + Y_NOISE_GEN * iy + SEED_NOISE_GEN * seed) & 0xffffffff;
			index ^= (index >> SHIFT_NOISE_GEN);
			index &= 0xff;
			
			var xvGradient:Number = CLookup.randomVector3D[(index << 2)];
			var yvGradient:Number = CLookup.randomVector3D[(index << 2) + 1];
			
			// setup another vector equal to the distance of the two vectors passed in
			var xvPoint:Number = x - ix;
			var yvPoint:Number = y - iy;
			
			// dot product and scale to [-1:1]
			return (xvGradient * xvPoint + yvGradient * yvPoint) * 2.12;
		}
	}

}