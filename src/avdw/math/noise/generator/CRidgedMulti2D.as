package avdw.math.noise.generator {
	import avdw.math.noise.CInterpolate;
	import avdw.math.noise.CSignal2D;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class CRidgedMulti2D implements IGenerator2D {
		private static const RIDGED_MAX_OCTAVE:uint = 30;
		private var _spectralWeights:Vector.<Number>;
		private var _frequency:Number = 1;
		private var _lacunarity:Number = 2;
		private var _ocaves:Number = 6;
		private var _seed:uint = 0;
		private var _offset:Number = 1;
		private var _gain:Number = 2;
		private var _exponent:Number = 1;
		private var _interpolationFunction:Function = CInterpolate.HERMITE;
		private var _noiseFunction:Function = CSignal2D.GRADIENT;
		
		public function CRidgedMulti2D() {
			calcSpectralWeights();
		}
		
		public function set frequency(value:Number):void {
			_frequency = value;
			calcSpectralWeights();
		}
		
		public function set lacunarity(value:Number):void {
			_lacunarity = value;
			calcSpectralWeights();
		}
		
		public function set ocaves(value:Number):void {
			_ocaves = value;
		}
		
		public function set persistence(value:Number):void {
			// not used
		}
		
		public function set seed(value:uint):void {
			_seed = value;
		}
		
		public function set offset(value:Number):void {
			_offset = value;
		}
		
		public function set gain(value:Number):void {
			_gain = value;
		}
		
		public function set exponent(value:Number):void {
			_exponent = value;
			calcSpectralWeights();
		}
		
		public function set interpolationFunction(value:Function):void {
			_interpolationFunction = value;
		}
		
		public function set noiseFunction(value:Function):void {
			_noiseFunction = value;
		}
		
		public function value(x:Number, y:Number):Number {
			var value:Number = 0;
			var signal:Number = 0;
			var weight:Number = 1.0;
			var seed:uint;
			
			x *= _frequency;
			y *= _frequency;
			
			for (var curOctave:int = 0; curOctave < _ocaves; curOctave++) {
				seed = (_seed + curOctave) & 0x7fffffff;
				signal = _noiseFunction(x, y, seed, _interpolationFunction);
				
				signal = _offset - Math.abs(signal);
				signal *= signal;
				signal *= weight;
				
				weight = signal * _gain;
				weight = Math.max(0, Math.min(1, weight));
				
				value += signal * _spectralWeights[curOctave];
				
				x *= _lacunarity;
				y *= _lacunarity;
			}
			
			return Math.min(1, Math.max(-1, (value * 1.25) - 1.0));
		}
		
		private function calcSpectralWeights():void {
			_spectralWeights = new Vector.<Number>();
			
			var freq:Number = _frequency;
			for (var i:int = 0; i < RIDGED_MAX_OCTAVE; i++) {
				_spectralWeights.push(Math.pow(freq, -_exponent));
				freq *= _lacunarity;
			}
		}
	}

}