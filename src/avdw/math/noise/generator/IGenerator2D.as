package avdw.math.noise.generator {
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public interface IGenerator2D {
		function set frequency(v:Number):void;
		function set lacunarity(v:Number):void;
		function set ocaves(v:Number):void;
		function set persistence(v:Number):void;
		function set seed(s:uint):void;
		function set gain(value:Number):void;
		function set offset(value:Number):void;
		function set exponent(value:Number):void;
		function set noiseFunction(v:Function):void;
		function set interpolationFunction(v:Function):void;
		function value(x:Number, y:Number):Number;
		
		
		
	}

}