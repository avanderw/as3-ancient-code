// The below code has been adapted 
// by Andrew van der Westhuizen 2012 | avanderw.co.za
/*
   Copyright (c) 2010 Wouter Visser - nuvorm.nl

   Permission is hereby granted, free of charge, to any person
   obtaining a copy of this software and associated documentation
   files (the "Software"), to deal in the Software without
   restriction, including without limitation the rights to use,
   copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following
   conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   OTHER DEALINGS IN THE SOFTWARE.
 */

package avdw.effect.explosion.capcom
{
	
	import avdw.math.rand.Rndm;
	import avdw.math.vector2d.Vec2;
	import flash.display.*
	import flash.filters.*
	import flash.geom.*;
	import flash.events.*;
	import flash.net.*;
	
	public class CapcomExplosion extends Sprite
	{
		private const rand:Rndm = new Rndm();
		private const renderSprite:Sprite = new Sprite();
		private const backLayer:Sprite = new Sprite();
		private const frontLayer:Sprite = new Sprite();
		private const frameBm:Bitmap = new Bitmap(new BitmapData(1, 1, true, 0));
		private const outputImages:Array = [];
		private const sizeSprite:Sprite = new Sprite();
		
		private var bmCount:int = 0;
		private var done:Boolean;
		
		public var seed:uint; // used to seed the explosion
		public var animation:BitmapAnimation; // used to control the animation (which is a mask over the animation strip)
		public var filmstrip:BitmapData = new BitmapData(1, 1, true, 0); // animation strip
		public var numFilms:int; // required to aid parsing the filmstrip
		public var scaleSize:Number = 1.0; // multiplier: big numbers can cause crash!
		public var fuzziness:Number = 2.0; // blur amount around all particles
		
		public var glowColor:int = 0x000000;
		public var glowSize:int = 8;
		public var glowStrength:int = 2;
		
		public var flareParticles:int = 16; // lower = quicker explosions
		public var flareDuration:int = 25; // how long will flare last for?
		public var flareEdgeColor:Vector.<uint> = Vector.<uint>([0x380000]);
		public var flareColors:Vector.<uint> = Vector.<uint>([0x380000, 0x680000, 0x983010, 0xC86020, 0xE08830, 0xF0B040, 0xF8D060, 0xF8F090, 0xF8F8F8]); // dark red thru to white
		//public var flareColors:Vector.<uint> = Vector.<uint>([0x380000, 0x681800, 0x983800, 0xC86808, 0xE88808, 0xF8B818, 0xF8D828, 0xF8F838, 0xF8F848]); // dark red thru to yellow
		
		public var smokeSize:Number = 1.0; // multiplier: big numbers can cause crash!
		public var smokeParticles:int = 16; // amount of smoke (warning: can make animation last a long time!)
		public var smokeDuration:int = 1; // higher numbers makes smoke float away more gently
		public var smokeEdgeColor:Vector.<uint> = Vector.<uint>([0x380000]);
		public var smokeColors:Vector.<uint> = Vector.<uint>([0x000000, 0x333333]); // black thru to dark grey
		//public var smokeColors:Vector.<uint> = Vector.<uint>([0x333333, 0x989898]); // dark grey thru to light grey
		
		public var explodeParticles:int = 8;
		public var explodeDuration:int = 1;
		public var explodeSpread:Number = 16; // it's random, but larger numbers permit a bigger spread of secondary explosions
		public var explodeEdgeColor:Vector.<uint> = Vector.<uint>([0x380000]);
		public var explodeColors:Vector.<uint> = Vector.<uint>([0x380000, 0x680000, 0x983010, 0xC86020, 0xE08830, 0xF0B040, 0xF8D060, 0xF8F090, 0xF8F8F8]); // dark red thru to white
		
		public var trailParticles:int = 8;
		public var trailDuration:int = 1;
		public var trailEdgeColor:Vector.<uint> = Vector.<uint>([0x380000]);
		public var trailColors:Vector.<uint> = Vector.<uint>([0x380000, 0x680000, 0x983010]); // dark red thru to dark red/orange
		
		
		public function CapcomExplosion():void
		{
			backLayer.blendMode = BlendMode.LAYER;
			frontLayer.blendMode = BlendMode.LAYER;
			renderSprite.addChild(backLayer);
			renderSprite.addChild(frontLayer);
		}
		
		public function generate():void
		{
			rand.seed = (seed == 0) ? Math.random() * uint.MAX_VALUE : seed;
			
			backLayer.filters = [new GlowFilter(glowColor, 1, glowSize, glowSize, glowStrength)];
			frontLayer.filters = [new BlurFilter(fuzziness, fuzziness, 1)];
			
			outputImages.splice(0, outputImages.length);
			
			var exploVars:SExplosion = new SExplosion();
			exploVars.colorSetBack = flareEdgeColor;
			exploVars.colorSetFront = flareColors;
			exploVars.numParticles = flareParticles;
			exploVars.size = 24;
			exploVars.startLifeTime = flareDuration;
			exploVars.randLifeTime = flareDuration * 0.5;
			exploVars.startSpeed = 0.1;
			exploVars.randSpeed = 0.9;
			exploVars.trail = true;
			exploVars.explodeChance = 10;
			exploVars.explodeChain = 3;
			exploVars.startPoint = new Vec2(0, 0);
			exploVars.frontAlpha = 1;
			exploVars.backAlpha = 1;
			
			createVisual(exploVars);
			
			done = false;
			while (!done)
			{
				_update();
			}
			
			composeImage();
		}
		
		private function createVisual(exploVars:SExplosion):void
		{
			for (var i:int = 0; i < exploVars.numParticles; i++)
			{
				var sz:Number = (exploVars.size * .25) + rand.float(exploVars.size);
				
				var relativeStartPoint:Vec2 = getRandomVector(0, Math.PI * 2, 0, 5);
				var V0:Vec2 = relativeStartPoint.clone();
				V0.normalizeSelf();
				V0.scaleSelf(exploVars.startSpeed + rand.float(exploVars.randSpeed))
				
				var lifeTime:int = int(exploVars.startLifeTime + rand.integer(exploVars.randLifeTime));
				
				var a:Sprite = new Particle(V0, exploVars.backAlpha, sz, lifeTime, exploVars.colorSetBack, rand);
				a.addEventListener("KILL_PARTICLE", killParticle);
				a.addEventListener("EXPLODE", explodeParticle);
				a.addEventListener("SMOKE", smokeParticle);
				
				if (exploVars.trail)
				{
					a.addEventListener("TRAIL", trailParticle);
				}
				
				Object(a).explodeChance = exploVars.explodeChance;
				Object(a).explodeChain = exploVars.explodeChain;
				
				var b:Sprite = new Particle(V0, exploVars.frontAlpha, sz, lifeTime, exploVars.colorSetFront, rand);
				
				exploVars.startPoint.addSelf(relativeStartPoint);
				var px:Number = exploVars.startPoint.x;
				var py:Number = exploVars.startPoint.y;
				
				b.blendMode = BlendMode.ADD;
				a.x = px;
				a.y = py;
				b.x = px;
				b.y = py;
				
				backLayer.addChild(a);
				frontLayer.addChild(b);
			}
		}
		
		private function killParticle(e:Event):void
		{
			var backPart:DisplayObject = e.target as DisplayObject;
			var indexNum:int = backLayer.getChildIndex(backPart);
			
			backPart.removeEventListener("KILL_PARTICLE", killParticle);
			backPart.removeEventListener("EXPLODE", explodeParticle);
			backPart.removeEventListener("SMOKE", smokeParticle);
			backPart.removeEventListener("TRAIL", trailParticle);
			
			backLayer.removeChildAt(indexNum);
			frontLayer.removeChildAt(indexNum);
			
			if (backLayer.numChildren == 0)
			{
				done = true;
			}
		}
		
		public function _update():void
		{
			var frontPart:Particle;
			var backPart:Particle;
			for (var i:int = 0; i < backLayer.numChildren; i++)
			{
				backPart = backLayer.getChildAt(i) as Particle;
				backPart.update();
				
				if (i < frontLayer.numChildren)
				{
					frontPart = frontLayer.getChildAt(i) as Particle;
					frontPart.update(backPart.x, backPart.y);
				}
			}
			
			var w:Number = int(renderSprite.width);
			var h:Number = int(renderSprite.height);
			
			var tx:Number = int((renderSprite.getRect(renderSprite).x) - (glowSize * .5));
			var ty:Number = int((renderSprite.getRect(renderSprite).y) - (glowSize * .5));
			
			var bd:BitmapData = new BitmapData(w + glowSize, h + glowSize, true, 0xFF0000);
			
			var mt:Matrix = new Matrix();
			mt.tx = -tx;
			mt.ty = -ty;
			bd.draw(renderSprite, mt);
			frameBm.bitmapData = bd;
			
			sizeSprite.graphics.lineStyle(1, 0x00FF00);
			sizeSprite.graphics.drawRect(tx, ty, w, h)
			
			if (bmCount > 1)
			{
				bmCount = 0
				outputImages.push([bd, tx, ty]);
			}
			bmCount++
		}
		
		private function explodeParticle(e:Event):void
		{
			var v:Vec2 = new Vec2(e.target.x, e.target.y);
			var relativePoint:Vec2 = getRandomVector(0, Math.PI * 2, explodeSpread, 0)
			v.addSelf(relativePoint);
			
			var exploVars:SExplosion = new SExplosion();
			exploVars.colorSetBack = explodeEdgeColor;
			exploVars.colorSetFront = explodeColors;
			exploVars.size = e.target.width * scaleSize;
			exploVars.startLifeTime = explodeDuration;
			exploVars.randLifeTime = 45;
			exploVars.startSpeed = 0.1;
			exploVars.randSpeed = 0.4;
			exploVars.trail = false;
			exploVars.numParticles = explodeParticles;
			exploVars.explodeChance = e.target.explodeChance * 0.5;
			exploVars.explodeChain = e.target.explodeChain - 1;
			exploVars.startPoint = v;
			exploVars.frontAlpha = 1;
			exploVars.backAlpha = .1;
			
			createVisual(exploVars);
		}
		
		private function smokeParticle(e:Event):void
		{
			var v:Vec2 = new Vec2(e.target.x, e.target.y);
			var relativePoint:Vec2 = getRandomVector(0, Math.PI * 2, 4, 0)
			v.addSelf(relativePoint);
			
			var exploVars:SExplosion = new SExplosion();
			exploVars.colorSetBack = smokeEdgeColor;
			exploVars.colorSetFront = smokeColors;
			exploVars.size = e.target.width * smokeSize;
			exploVars.startLifeTime = smokeDuration;
			exploVars.randLifeTime = 45;
			exploVars.startSpeed = 0.1;
			exploVars.randSpeed = 0.4;
			exploVars.trail = false;
			exploVars.numParticles = smokeParticles;
			exploVars.explodeChance = -1;
			exploVars.explodeChain = 0;
			exploVars.startPoint = v;
			exploVars.frontAlpha = 1;
			exploVars.backAlpha = 1;
			
			createVisual(exploVars);
		}
		
		private function trailParticle(e:Event):void
		{
			var v:Vec2 = new Vec2(e.target.x, e.target.y);
			var sz:Number = e.target.width * .5;
			var relativePoint:Vec2 = getRandomVector(0, Math.PI * 2, 2, 0)
			v.addSelf(relativePoint);
			
			var exploVars:SExplosion = new SExplosion();
			exploVars.colorSetBack = trailEdgeColor;
			exploVars.colorSetFront = trailColors;
			exploVars.size = e.target.width * scaleSize;
			exploVars.startLifeTime = trailDuration;
			exploVars.randLifeTime = 45;
			exploVars.startSpeed = 0;
			exploVars.randSpeed = 0;
			exploVars.trail = false;
			exploVars.numParticles = trailParticles;
			exploVars.numParticlesExplo = 16;
			exploVars.numParticlesSmoke = 4;
			exploVars.explodeChance = -1
			exploVars.explodeChain = 0
			exploVars.startPoint = v;
			exploVars.frontAlpha = 1;
			exploVars.backAlpha = .5;
			
			createVisual(exploVars);
		}
		
		private function getRandomVector(refAngle:Number, angleDeviation:Number, refSpeed:Number, speedDeviation:Number):Vec2
		{
			var startVector:Vec2 = new Vec2(refSpeed + rand.float(speedDeviation), 0);
			startVector.rotateSelf(refAngle - (angleDeviation * .5) + rand.float(angleDeviation));
			
			return startVector;
		}
		
		private function composeImage():void
		{
			if (animation != null)
			{
				removeChild(animation);
			}
			
			var cellWidth:Number = sizeSprite.width + glowSize;
			var cellHeight:Number = sizeSprite.height + glowSize;
			numFilms = outputImages.length;
			var sizeRect:Rectangle = sizeSprite.getBounds(sizeSprite);
			
			sizeSprite.graphics.clear();
			
			if ((cellWidth * numFilms) > 10000)
			{
				trace("warning bitmap to large");
				
				outputImages.splice(0, outputImages.length);
				
				filmstrip.dispose();
				animation = null
				return;
			}
			
			cellWidth = Math.max(1, cellWidth);
			cellHeight = Math.max(1, cellHeight);
			
			filmstrip.dispose();
			filmstrip = new BitmapData((cellWidth * numFilms), (cellHeight), true, 0x000000);
			//var bitmap:Bitmap = new Bitmap(filmstrip);
			//addChild(bitmap);
			
			for (var i:int = 0; i < numFilms; i++)
			{
				var cellBitmap:BitmapData = outputImages[i][0];
				
				var np:Point = new Point((i * cellWidth) + Math.abs(sizeRect.x - outputImages[i][1]), Math.abs(sizeRect.y - outputImages[i][2]));
				filmstrip.copyPixels(cellBitmap, new Rectangle(0, 0, cellWidth, cellHeight), np);
			}
			
			animation = new BitmapAnimation(filmstrip, numFilms)
			addChild(animation);
			animation.y = -filmstrip.height / 2;
			animation.x = -cellWidth / 2;
		}
	}
}

import avdw.math.vector2d.Vec2;
import com.adobe.images.PNGEncoder;

class SExplosion
{
	public var colorSetBack:Vector.<uint>;
	public var colorSetFront:Vector.<uint>;
	public var numParticles:int;
	public var size:Number;
	public var startLifeTime:int;
	public var randLifeTime:int;
	public var startSpeed:Number;
	public var randSpeed:Number;
	public var trail:Boolean;
	public var explodeChance:int;
	public var explodeChain:int;
	public var startPoint:Vec2;
	public var frontAlpha:Number;
	public var backAlpha:Number;
	public var numParticlesExplo:int;
	public var numParticlesSmoke:int;
}

/*
   Copyright (c) 2010 Wouter Visser - nuvorm.nl

   Permission is hereby granted, free of charge, to any person
   obtaining a copy of this software and associated documentation
   files (the "Software"), to deal in the Software without
   restriction, including without limitation the rights to use,
   copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the
   Software is furnished to do so, subject to the following
   conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   OTHER DEALINGS IN THE SOFTWARE.
 */

import avdw.math.rand.Rndm;
import avdw.math.vector2d.Vec2;
import flash.display.*;
import flash.events.*;
import flash.utils.*;
import flash.net.FileReference;
import avdw.effect.explosion.capcom.Main;

class Particle extends Sprite
{
	private var speedvector:Vec2;
	private var colArray:Vector.<uint>;
	private var graphicAlpha:Number;
	private var size:Number;
	private var lifeTime:int;
	
	private var explodeAt:int = -1;
	private var lifeTimeCount:Number = 0;
	private var trailTime:int = 4;
	private var trailCount:int = 0;
	
	private var rand:Rndm;
	
	public static var GRAVITY:Vec2 = new Vec2(0, -.01);
	// TODO: consider adding other types of velocities
	
	// get set
	private var _explodeChance:int = -1;
	private var _explodeChain:int = 0;
	
	private var _degreelist:Array = [];
	
	public function Particle(tvector:Vec2, _alpha:Number, _size:Number, _lifeTime:int, _colArray:Vector.<uint>, _rand:Rndm)
	{
		colArray = _colArray
		graphicAlpha = _alpha;
		size = _size;
		speedvector = tvector;
		lifeTime = _lifeTime;
		rand = _rand;
		
		drawGraphic();
	}
	
	public function drawGraphic():void
	{
		this.graphics.clear();
		
		var colLength:int = colArray.length;
		var colorSize:Number = size;
		
		var i:int;
		for (i = 0; i < colLength; i++)
		{
			this.graphics.beginFill(colArray[i], graphicAlpha)
			
			this.graphics.drawEllipse(-colorSize * .5, -colorSize * .5, colorSize, colorSize)
			colorSize *= .85;
		}
	}
	
	public function update(xpos:Number = NaN, ypos:Number = NaN):void
	{
		if (isNaN(xpos))
		{
			this.x += speedvector.x;
			this.y += speedvector.y;
			
			speedvector.addSelf(GRAVITY);
		}
		else
		{
			this.x = xpos;
			this.y = ypos;
		}
		
		var timePercent:Number = 1 - (lifeTimeCount / lifeTime)
		
		if (lifeTimeCount >= explodeAt && explodeAt != -1)
		{
			if (explodeChain > 0)
			{
				dispatchEvent(new Event("EXPLODE"));
				explodeChain--;
			}
		}
		if (lifeTimeCount >= (lifeTime * .7) && explodeChain > 0)
		{
			explodeChain--;
			
			dispatchEvent(new Event("SMOKE"));
		}
		
		this.width = size * timePercent;
		this.height = size * timePercent;
		
		speedvector.scaleSelf(.99);
		
		this.alpha = timePercent;
		
		if (lifeTimeCount >= lifeTime)
		{
			dispatchEvent(new Event("KILL_PARTICLE"));
		}
		
		if (trailCount >= trailTime)
		{
			dispatchEvent(new Event("TRAIL"));
			trailCount = 0;
		}
		
		lifeTimeCount++;
		trailCount++
	}
	
	public function set explodeChance(v:int):void
	{
		_explodeChance = v;
		var shortLifetime:int = int(lifeTime * .70);
		
		var eenProcent:Number = shortLifetime / 100;
		var treshold:Number = eenProcent * v;
		
		if (rand.integer(shortLifetime) <= treshold)
		{
			explodeAt = rand.float(shortLifetime);
		}
	}
	
	public function get explodeChance():int
	{
		return _explodeChance;
	}
	
	public function set explodeChain(v:int):void
	{
		_explodeChain = v
	}
	
	public function get explodeChain():int
	{
		return _explodeChain;
	}
}

class BitmapAnimation extends Sprite
{
	private var myBitmap:Bitmap;
	private var myBitmapData:BitmapData;
	private var animationTimer:Timer;
	private var masker:Sprite;
	private var cellWidth:Number = 0;
	private var cellHeight:Number = 0;
	private var infiniteLoop:Boolean = false;
	private var loop:int;
	private var _delay:int = 36;
	
	public function BitmapAnimation(sourceData:BitmapData, numFilms:int)
	{
		cellWidth = (sourceData.width / numFilms);
		cellHeight = sourceData.height
		
		masker = new Sprite();
		masker.graphics.beginFill(0, 1);
		masker.graphics.drawRect(0, 0, cellWidth, cellHeight);
		addChild(masker)
		this.mask = masker;
		
		myBitmapData = sourceData.clone();
		
		myBitmap = new Bitmap(myBitmapData);
		addChild(myBitmap)
		
		animationTimer = new Timer(delay, numFilms);
		animationTimer.addEventListener(TimerEvent.TIMER, animate);
		animationTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animateComplete);
		
		myBitmap.visible = false;
	}
	
	public function save():void {
		var ba:ByteArray = PNGEncoder.encode(myBitmapData);
		new FileReference().save(ba, "explosion_"+cellWidth+"x"+cellHeight+".png");
	}
	
	private function animate(e:TimerEvent):void
	{
		myBitmap.x -= cellWidth;
	}
	
	private function animateComplete(e:TimerEvent):void
	{
		myBitmap.x = 0;
		loop--;
		if (loop <= 0)
		{
			if (infiniteLoop)
			{
				animationTimer.reset();
				animationTimer.start();
			}
			else
			{
				playEnd();
			}
		}
		else
		{
			animationTimer.reset();
			animationTimer.start();
		}
	
	}
	
	private function playEnd():void
	{
		myBitmap.visible = false;
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	///////////////////////////////////
	//
	// publics
	//
	///////////////////////////////////
	
	public function play(_loop:int = 1):void
	{
		myBitmap.visible = true;
		loop = _loop;
		if (loop == 0)
		{
			infiniteLoop = true;
		}
		
		myBitmap.x = 0;
		animationTimer.reset();
		animationTimer.start();
	}
	
	public function stop():void
	{
		animationTimer.stop();
	}
	
	///////////////////////////////////
	//
	// getters setters
	//
	///////////////////////////////////
	
	public function set delay(v:int):void
	{
		_delay = v;
		animationTimer.delay = v
	}
	
	public function get delay():int
	{
		return _delay;
	}
}