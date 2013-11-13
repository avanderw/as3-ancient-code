package avdw.playground.minesweeper
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import stateMachine.StateMachine;
	import stateMachine.StateMachineEvent;
	import utils.error.getStackTrace;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Cell extends Sprite
	{
		private static const Hidden:String = "hidden";
		private static const Visible:String = "visible";
		private static const Speculation:String = "speculation";
		private static const Waiting:String = "waiting";
		private const bitmap:Bitmap = new Bitmap();
		private const highlight:Bitmap = new Bitmap(GraphicAsset.CellHighlight);
		private const state:StateMachine = new StateMachine();
		private var _type:ECell = ECell.Empty;
		private var timer:Timer = new Timer(500);
		private var prevState:String;
		public var col:int;
		public var row:int;
		
		public function Cell()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function get type():ECell
		{
			return _type;
		}
		
		public function set type(value:ECell):void
		{
			_type = value;
		}
		
		public function show():void
		{
			state.changeState(Visible);
		}
		
		public function isVisible():Boolean
		{
			return (state.state == Visible);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			addChild(bitmap);
			
			state.addState(Hidden, {enter: onEnterHidden, from: [Waiting]});
			state.addState(Visible, {enter: onEnterVisible, from: [Waiting, Hidden]});
			state.addState(Speculation, {enter: onEnterSpeculation, from: [Waiting]});
			state.addState(Waiting, {enter: onEnterWaiting, exit: onExitWaiting, from: [Hidden, Speculation]});
			
			state.initialState = Hidden;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if (prevState == Speculation)
				state.changeState(Hidden);
			else
				state.changeState(Speculation);
		}
		
		/*
		 * mouse event listeners
		 */
		
		private function onMouseDown(e:MouseEvent):void
		{
			state.changeState(Waiting);
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			addChild(highlight);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeChild(highlight);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			state.changeState(Visible);
		}
		
		/*
		 * state enter/exit methods
		 */
		private function onEnterWaiting(e:StateMachineEvent):void
		{
			prevState = e.fromState;
			timer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onExitWaiting(e:StateMachineEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			timer.reset();
		}
		
		private function onEnterSpeculation(e:StateMachineEvent):void
		{
			bitmap.bitmapData = GraphicAsset.CellSpeculation;
		}
		
		private function onEnterVisible(e:StateMachineEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			if (contains(highlight))
			{
				removeChild(highlight);
			}
			bitmap.bitmapData = type.Graphic;
		}
		
		private function onEnterHidden(e:StateMachineEvent):void
		{
			bitmap.bitmapData = GraphicAsset.CellHidden;
		}
	
	}

}
