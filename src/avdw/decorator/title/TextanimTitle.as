package avdw.decorator.title {
	import avdw.font.dsdigital.DSDigitalFontNormal;
	import avdw.math.rand.Rndm;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimBlock;
	import flupie.textanim.TextAnimEvent;
	import flupie.textanim.TextAnimMode;
	
	public class TextanimTitle extends Sprite {
		private static const _name:String = "TextanimTitle";
		private static const chars:String = "^-.*@#$%!&543210";
		private static var inner:Boolean = false;
		
		private const rand:Rndm = new Rndm(Math.random() * uint.MAX_VALUE);
		private var remove:Boolean = false;
		
		private var isLightBackground:Boolean;
		private var anim:TextAnim;
		private var title:String;
		private var glow:GlowFilter;
		private var align:String;
		private var space:int;
		
		public function TextanimTitle(title:String, size:int = 24, isLightBackground:Boolean = true, align:String = StageAlign.BOTTOM_RIGHT, space:int = 10, width:int = NaN, height:int = NaN) {
			if (!inner) {
				throw new Error("you should be using the addTo method");
			}
			this.space = space;
			this.align = align;
			this.title = title;
			this.isLightBackground = isLightBackground;
			this.name = _name;
			
			var color:uint = isLightBackground ? 0x333333 : 0xC9F1FA;
			glow = new GlowFilter(color, .4, 6, 6);
			
			var text:TextField = new TextField();
			text.embedFonts = true;
			text.autoSize = TextFieldAutoSize.LEFT;
			text.defaultTextFormat = new TextFormat(DSDigitalFontNormal.FONT_NAME, size, color);
			text.text = title;
			text.selectable = false;
			
			switch (align) {
				case StageAlign.TOP: 
					text.x = (width - text.width) / 2;
					text.y = this.space;
					break;
				case StageAlign.TOP_LEFT: 
					text.x = this.space;
					text.y = this.space;
					break;
				case StageAlign.TOP_RIGHT: 
					text.x = width - text.textWidth - this.space;
					text.y = this.space;
					break;
				case StageAlign.RIGHT: 
					text.x = this.space;
					text.y = (height - text.textHeight) / 2;
					break;
				case StageAlign.LEFT: 
					text.x = width - text.textWidth - this.space;
					text.y = (height - text.textHeight) / 2;
					break;
				case StageAlign.BOTTOM: 
					text.x = (width - text.width) / 2;
					text.y = height - text.textHeight - this.space;
					break;
				case StageAlign.BOTTOM_LEFT: 
					text.x = this.space;
					text.y = this.space;
					break;
				case StageAlign.BOTTOM_RIGHT: 
					text.x = width - text.textWidth - this.space;
					text.y = height - text.textHeight - this.space;
					break;
				default: 
					text.x = (width - text.width) / 2;
					text.y = (height - text.textHeight) / 2;
					break;
			}
			
			addChild(text);
			anim = new TextAnim(text);
			anim.interval = 50;
			anim.effects = shuffleEffect;
			anim.filters = [glow];
			anim.mode = TextAnimMode.RANDOM;
			anim.blocksVisible = false;
			anim.start(1000);
			
			anim.addEventListener(TextAnimEvent.COMPLETE, onComplete);
		}
		
		private function onComplete(e:Event):void {
			remove = !remove;
			anim.effects = remove ? removeEffect : shuffleEffect;
			anim.start(remove ? 6000 : 2000);
		}
		
		private function removeEffect(b:TextAnimBlock):void {
			TweenLite.to(b, rand.float(0.2, 0.6), {scaleX: 0, scaleY: 0});
		}
		
		private function shuffleEffect(b:TextAnimBlock):void {
			b.vars.char = b.text;
			
			TweenLite.to(b, rand.float(0.4, 0.6), {scaleX: 1, scaleY: 1, onUpdate: updateChars, onUpdateParams: [b], onComplete:completeRandom, onCompleteParams:[b] } );
		}
		
		private function updateChars(b:TextAnimBlock):void {
			var index:int = Math.round(Math.random() * chars.length);
			b.text = chars.slice(index, index + 1);
		}
		
		private function completeRandom(b:TextAnimBlock):void {
			b.text = b.vars.char;
		}
		
		public static function addTo(display:*, title:String, size:int = 24, isLightBackground:Boolean = true, align:String = StageAlign.BOTTOM_RIGHT, space:int = 10):void {
			var width:int = display is Stage ? display.stageWidth : display.width;
			var height:int = display is Stage ? display.stageHeight : display.height;
			
			inner = true;
			display.addChild(new TextanimTitle(title, size, isLightBackground, align, space, width, height));
			inner = false;
		}
		
		public static function removeFrom(display:*):void {
			if (display.getChildByName(_name) != null) {
				display.removeChild(display.getChildByName(_name));
			}
		}
	}

}