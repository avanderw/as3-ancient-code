package avdw.tool.geminirue {
	import avdw.preloader.SimplePreloader;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Preloader extends SimplePreloader {
		public function Preloader() {
			super();
		}
		
		override protected function startup():void {
			addChild(new Main() as DisplayObject);
		}
	}

}