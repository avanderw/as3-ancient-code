/***************************************************************************************************************
   Vector2D Class For Actionscript 3.0
   ---------------------------------------------------------------------------------------------------------------
   method listing:
   state-altering methods:
   Vector2D(x, y)    - create vector and set the components to x and y
   Vector2D(v)     - create vector and set the components to the components of vector v
   set(x, y)     - set the components to x and y
   set(v)        - set the components to the components of vector v
   plus(v1 ... vn)   - add the components of the given vectors to the components of the vector
   minus(v1 ... vn)  - subtract the components of given vectors from the components of the vector
   times(x, y)     - multiply the components of vector by x and y
   times(scalar)   - multiply the components of vector by number scalar
   times(v)      - multiply the components of vector by the components of vector v
   invert()      - invert (or reverse) the vector
   project(v)      - set the vector to be the projection of the vector onto vector v
   reflect(v)      - reflect the vector over vector v
   rotate(a)     - rotate the vector by angle a in degrees
   swap(v)       - swap the components of the vector and vector v (note: also alters vector v)
   state-safe methods:
   getLeftNormal()   - return a new vector which is left hand normal to the vector
   getRightNormal()  - return a new vector which is right hand normal to the vector
   cross(v)      - return the magnitude of the cross product of the vector and vector v
   dot(v)        - return the dot product of the vector and vector v
   angleBetween(v)   - return the angle between the vector and vector v
   angleBetweenCos(v)  - return the cosine of the angle between the vector and vector v
   angleBetweenSin(v)  - return the sine of the angle between the vector and vector v
   comparison methods:
   isEqualTo(v)    - test for equality between the vector and vector v
   isNormalTo(v)   - test for normality between the vector and vector v
   utility methods:
   paint(mc, color)  - draw vector in given movieclip using a given color
   private methods:
   fixNumber()     - convert all inputs to a number of fixed precision
   toString()      - override of built in method to provide meaningful output
   property listing:
   x     - virtual property representing the current x component of the vector  (get/set)
   y     - virtual property representing the current y component of the vector  (get/set)
   angle   - virtual property representing the current degree angle of the vector (get/set)
   magnitude - virtual property representing the current magnitude of the vector    (get/set)

   Feel free to use this code as you wish, Have Fun!
   Please send bug reports && ( gripes || praise ) to nick[at]zambetti[dot]com
 ***************************************************************************************************************/
package avdw.math.vector2d
{
	
	public class Vector2D
	{
		// instance properties
		private var xValue:Number = 0;
		private var yValue:Number = 0;
		
		//
		// description: constructor for Vector2D
		// parameters: x:Number, y:Number || v:Vector2D
		// returns: reference to the new instance
		function Vector2D(... args)
		{
			this.xValue = 0;
			this.yValue = 0;
			
			if (2 == args.length)
			{
				// x and y were passed
				this.xValue = this.fixNumber(args[0]);
				this.yValue = this.fixNumber(args[1]);
			}
			else if (1 == args.length)
			{
				if (args[0] is Vector2D)
				{
					// an existing vector was passed
					this.xValue = args[0].x;
					this.yValue = args[0].y;
				}
			}
		}
		
		//
		// description: sets the properties of the vector
		// parameters: x:Number, y:Number || v:Vector2D
		// returns: reference to the vector
		public function set(... args):Vector2D
		{
			this.xValue = 0;
			this.yValue = 0;
			
			if (2 == args.length)
			{
				// x and y were passed
				this.xValue = this.fixNumber(args[0]);
				this.yValue = this.fixNumber(args[1]);
			}
			else if (1 == args.length)
			{
				if (args[0] is Vector2D)
				{
					// an existing vector was passed
					this.xValue = args[0].x;
					this.yValue = args[0].y;
				}
			}
			return this;
		}
		
		//
		// description: adds given vectors to the vector
		// parameters: v1:Vector2D ... vn;Vector2D
		// returns: reference to the vector
		public function plus(... args):Vector2D
		{
			for (var i = 0; i < args.length; ++i)
			{
				if (args[i] is Vector2D)
				{
					this.xValue += args[i].xValue;
					this.yValue += args[i].yValue;
				}
			}
			this.xValue = this.fixNumber(this.xValue);
			this.yValue = this.fixNumber(this.yValue);
			return this;
		}
		
		//
		// description: subtracts given vectors from the vector
		// parameters: v1:Vector2D ... vn:Vector2D
		// returns: reference to the vector
		public function minus(... args):Vector2D
		{
			for (var i = 0; i < args.length; ++i)
			{
				if (args[i] is Vector2D)
				{
					this.xValue -= args[i].xValue;
					this.yValue -= args[i].yValue;
				}
			}
			this.xValue = this.fixNumber(this.xValue);
			this.yValue = this.fixNumber(this.yValue);
			return this;
		}
		
		//
		// description: multiplies the components by the x and y args or by the given vector
		// parameters: x:number, y:number || scalar:number || v:Vector2D
		// returns: reference to the vector
		public function times(... args):Vector2D
		{
			if (1 == args.length)
			{
				if (args[0] is Vector2D)
				{
					this.xValue *= args[0].xValue;
					this.yValue *= args[0].yValue;
				}
				else
				{
					if (isNaN(Number(args[0])))
					{
						this.xValue = this.yValue = 0;
					}
					else
					{
						this.xValue *= Number(args[0]);
						this.yValue *= Number(args[0]);
					}
				}
			}
			else if (2 == args.length)
			{
				isNaN(Number(args[0])) ? this.xValue = 0 : this.xValue *= Number(args[0]);
				isNaN(Number(args[1])) ? this.yValue = 0 : this.yValue *= Number(args[1]);
			}
			this.xValue = this.fixNumber(this.xValue);
			this.yValue = this.fixNumber(this.yValue);
			return this;
		}
		
		//
		// description: rotates the vector by the given angle (in degrees)
		// parameters: rotationAngle:Number
		// returns: reference to the vector
		public function rotate(rotationAngle:Number):Vector2D
		{
			if (isNaN(Number(rotationAngle)))
			{
				return this;
			}
			var currentMagnitude:Number = Math.sqrt(Math.pow(this.xValue, 2) + Math.pow(this.yValue, 2));
			var newAngleRadians:Number = ((Math.atan2(this.yValue, this.xValue) * (180 / Math.PI)) + Number(rotationAngle)) * (Math.PI / 180);
			this.xValue = this.fixNumber(currentMagnitude * Math.cos(newAngleRadians));
			this.yValue = this.fixNumber(currentMagnitude * Math.sin(newAngleRadians));
			return this;
		}
		
		//
		// description: inverts the vector
		// parameters: none
		// returns: reference to the vector
		public function invert():Vector2D
		{
			this.xValue *= -1;
			this.yValue *= -1;
			return this;
		}
		
		//
		// description: projects the vector onto vector v
		// parameters: v:Vector2D
		// returns: reference to the vector
		public function project(v:Vector2D):Vector2D
		{
			if (v is Vector2D)
			{
				var scalar:Number = this.dot(v) / Math.pow(v.magnitude, 2);
				this.set(v);
				this.times(scalar);
			}
			return this;
		}
		
		//
		// description: relects the vector over vector v
		// parameters: v:Vector2D
		// returns: reference to the vector
		public function reflect(v:Vector2D):Vector2D
		{
			if (v is Vector2D)
			{
				var vAfterHorizReflect:Vector2D = new Vector2D(v.yValue, -v.xValue);
				var rotationAngle:Number = 2 * this.angleBetween(v);
				if (0 >= this.angleBetweenCos(vAfterHorizReflect))
				{
					rotationAngle *= -1;
				}
				this.rotate(rotationAngle);
			}
			return this;
		}
		
		//
		// description: calculates the dot product of the vector and vector v
		// parameters: v:Vector2D
		// returns: number
		public function dot(v:Vector2D):Number
		{
			if (v is Vector2D)
			{
				return this.fixNumber((this.xValue * v.xValue) + (this.yValue * v.yValue));
			}
			return 0;
		}
		
		//
		// description: calculates the cross product of the vector and vector v
		// parameters: v:Vector2D
		// returns: number (representing the magnitude of the theoretical vector result)
		public function cross(v:Vector2D):Number
		{
			if (v is Vector2D)
			{
				return Math.abs(this.fixNumber((this.xValue * v.yValue) - (this.yValue * v.xValue)));
			}
			return 0;
		}
		
		//
		// description: calculates the the angle between the vector and vector v in degrees
		// parameters: v:Vector2D
		// returns: number
		public function angleBetween(v:Vector2D):Number
		{
			if (v is Vector2D)
			{
				return this.fixNumber(Math.acos(this.dot(v) / (this.magnitude * v.magnitude)) * (180 / Math.PI));
			}
			return 0;
		}
		
		//
		// description: calculates the sine of the angle between the vector and vector v
		// parameters: v:Vector2D
		// returns: number
		public function angleBetweenSin(v:Vector2D):Number
		{
			if (v is Vector2D)
			{
				return this.fixNumber(this.cross(v) / (this.magnitude * v.magnitude));
			}
			return 0;
		}
		
		//
		// description: calculates the cosine of the angle between the vector and vector v
		// parameters: v:Vector2D
		// returns: number
		public function angleBetweenCos(v:Vector2D):Number
		{
			if (v is Vector2D)
			{
				return this.fixNumber(this.dot(v) / (this.magnitude * v.magnitude));
			}
			return 0;
		}
		
		//
		// description: exchanges data of the vector and the given vector
		// parameters: v:Vector2D
		// returns: reference to the vector
		public function swap(v:Vector2D):Vector2D
		{
			if (v is Vector2D)
			{
				var tempX:Number = this.xValue;
				var tempY:Number = this.yValue;
				this.xValue = v.xValue;
				this.yValue = v.yValue;
				v.xValue = tempX;
				v.yValue = tempY;
			}
			return this;
		}
		
		//
		// description: creates a new vector which is normal (clockwise) to the vector
		// parameters: none
		// returns: reference to the newly created vector
		public function getRightNormal():Vector2D
		{
			return new Vector2D(this.yValue, -this.xValue);
		}
		
		//
		// description: creates a new vector which is normal (anti-clockwise) to the vector
		// parameters: none
		// returns: reference to the newly created vector
		public function getLeftNormal():Vector2D
		{
			return new Vector2D(-this.yValue, this.xValue);
		}
		
		//
		// description: tests if two vectors are normal to each other
		// parameters: v:Vector2D
		// returns: boolean indicating normality
		public function isNormalTo(v:Vector2D):Boolean
		{
			if (v is Vector2D)
			{
				return (this.dot(v) === 0);
			}
			else
			{
				return false;
			}
		}
		
		//
		// description: tests if two vectors are equal to each other
		// parameters: v:Vector2D
		// returns: boolean indicating equality
		public function isEqualTo(v:Vector2D):Boolean
		{
			if (v is Vector2D)
			{
				if ((this.xValue === v.xValue) && (this.yValue === v.yValue))
				{
					return true;
				}
			}
			return false;
		}
		
		//
		// description: retrieves the current x value of the vector
		// parameters: none
		// returns: current value of x
		public function get x():Number
		{
			return this.xValue;
		}
		
		//
		// description: sets x value of the vector
		// parameters: newX:Number
		// returns: value of x BEFORE precision fix
		
		public function set x(newX:Number):void
		{
			this.xValue = this.fixNumber(newX);
		}
		
		//
		// description: retrieves the current y value of the vector
		// parameters: none
		// returns: current value of y
		public function get y():Number
		{
			return this.yValue;
		}
		
		//
		// description: sets y value of the vector
		// parameters: newY:Number
		// returns: value of y BEFORE precision fix
		public function set y(newY:Number):void
		{
			this.yValue = this.fixNumber(newY);
		}
		
		//
		// description: calculates the angle of the vector
		// parameters: none
		// returns: number representing angle in degrees
		public function get angle():Number
		{
			return this.fixNumber(Math.atan2(this.yValue, this.xValue) * (180 / Math.PI));
			//return this.fixNumber(((Math.atan2(this.yValue, this.xValue)*(180/Math.PI))+360)%360);
		}
		
		//
		// description: sets the angle of the vector to the given angle (in degrees)
		// parameters: newAngle:Number
		// returns: number representing angle in degrees BEFORE precision fix
		public function set angle(newAngle:Number):void
		{
			var angleRadians:Number = 0;
			if (!isNaN(Number(newAngle)))
			{
				angleRadians = Number(newAngle) * (Math.PI / 180);
			}
			var currentMagnitude:Number = Math.sqrt(Math.pow(this.xValue, 2) + Math.pow(this.yValue, 2));
			this.xValue = this.fixNumber(currentMagnitude * Math.cos(angleRadians));
			this.yValue = this.fixNumber(currentMagnitude * Math.sin(angleRadians));
		}
		
		//
		// description: returns the magnitude of the vector (aka: length)
		// parameters: none
		// returns: 0 <= number
		public function get magnitude():Number
		{
			return this.fixNumber(Math.sqrt(Math.pow(this.xValue, 2) + Math.pow(this.yValue, 2)));
		}
		
		//
		// description: sets the magnitude (aka: length) to the given scalar
		// parameters: newMagnitude:Number
		// returns: magnitude after set operation
		public function set magnitude(newMagnitude:Number):void
		{
			if (isNaN(Number(newMagnitude)))
			{
				this.xValue = this.yValue = 0;
			}
			var currentMagnitude:Number = Math.sqrt(Math.pow(this.xValue, 2) + Math.pow(this.yValue, 2));
			if (0 < currentMagnitude)
			{
				this.times(Number(newMagnitude) / currentMagnitude);
			}
			else
			{
				this.yValue = 0;
				this.xValue = this.fixNumber(newMagnitude);
			}
		}
		
		//
		// description: draws a vector in a given mc using a given color
		// parameters: mc|movieClipReference color|hexNumber
		// returns: nothing
		public function paint(mc:Object, color:Number)
		{
			mc.graphics.lineStyle(0, color);
			mc.graphics.moveTo(0, 0);
			mc.graphics.lineTo(this.xValue, this.yValue);
		}
		
		//
		// description: converts all numeric inputs to a number of fixed precision
		// parameters: numberValue:Number
		// returns: number rounded to a fixed precision
		private function fixNumber(numberValue:Number):Number
		{
			return isNaN(Number(numberValue)) ? 0 : Math.round(Number(numberValue) * 100000) / 100000;
		}
		
		//
		// description: override of toString() that produces meaningful output
		// parameters: none
		// returns: string
		public function toString():String
		{
			return "[" + this.xValue + "," + this.yValue + "]";
		}
	}

}