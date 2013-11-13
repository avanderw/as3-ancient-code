package avdw.lsystem {
	import avdw.lsystem.LSystem;
	import avdw.lsystem.LSystemGrammar;
	import avdw.lsystem.LSystemPainter;
	import avdw.lsystem.SavedLSystem;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import utils.textField.createField;
	
	/**
	 * ...
	 * @author Andrew van der Westhuizen
	 */
	public class Main extends Sprite {
		private var savedSystem:ComboBox;
		private var drawing:Sprite;
		private var lsystemPainter:ComboBox;
		private var overrideDefault:CheckBox;
		private var lengthInput:NumericStepper;
		private var overrideSettings:Sprite;
		private var angleInput:NumericStepper;
		private var evolutionInput:NumericStepper;
		private var axiomInput:InputText;
		private const rules:Vector.<String> = new Vector.<String>();
		private const ruleInputs:Vector.<Label> = new Vector.<Label>();
		//private var removeBtn:PushButton;
		
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			CONFIG::debug {
				addChild(createField("debug mode", stage.stageWidth - 105, stage.stageHeight - 20, 100, 20, false, "Verdana", 9, 0xFF0000, TextFieldAutoSize.RIGHT));
				MonsterDebugger.initialize(this);
			}
			
			savedSystem = new ComboBox(stage, 0, 0, "Saved System", SavedLSystem.SystemList);
			savedSystem.addEventListener(Event.SELECT, setupSystemState);
			savedSystem.addEventListener(Event.SELECT, stateChanged);
			
			lsystemPainter = new ComboBox(stage, savedSystem.x + savedSystem.width, savedSystem.y, "Painter", [new LSystemPainter(), new LSystemAnimatedPainter()]);
			lsystemPainter.addEventListener(Event.SELECT, stateChanged);
			
			overrideDefault = new CheckBox(stage, lsystemPainter.x + lsystemPainter.width, lsystemPainter.y, "override default settings", stateChanged);
			overrideSettings = new Sprite();
			overrideSettings.x = savedSystem.x;
			overrideSettings.y = savedSystem.y + savedSystem.height;
			addChild(overrideSettings);
			lengthInput = new NumericStepper(overrideSettings, 0, 0, stateChanged);
			lengthInput.value = 1;
			new Label(overrideSettings, lengthInput.x + lengthInput.width, 0, " : Step Length");
			angleInput = new NumericStepper(overrideSettings, lengthInput.x, lengthInput.y + lengthInput.height, stateChanged);
			new Label(overrideSettings, angleInput.x + angleInput.width, angleInput.y, " : Rotation Angle (Degrees)");
			evolutionInput = new NumericStepper(overrideSettings, 0, angleInput.y + angleInput.height, stateChanged);
			evolutionInput.minimum = 0;
			new Label(overrideSettings, evolutionInput.x + evolutionInput.width, evolutionInput.y, " : Expansions");
			axiomInput = new InputText(overrideSettings, 0, evolutionInput.y + evolutionInput.height, "", stateChanged);
			new Label(overrideSettings, axiomInput.x + axiomInput.width, axiomInput.y, " : Axiom");
			//removeBtn = new PushButton(overrideSettings, 0, axiomInput.y + axiomInput.height, "-", removeRule);
			//new PushButton(overrideSettings, removeBtn.x + removeBtn.width, removeBtn.y, "+", addRule);
			
			drawing = new Sprite();
			drawing.x = stage.stageWidth / 2;
			drawing.y = stage.stageHeight / 2;
			addChild(drawing);
			
			overrideSettings.visible = overrideDefault.selected;
		}
		
		private function addRule(e:Event = null, rule:String = ""):void {
			rules.push(rule);
			renderRules();
		}
		
		private function removeRule(e:Event = null, rule:String = ""):void {
			if (rules.length > 1) {
				rules.splice(0, 1);
			}
			renderRules();
		}
		
		private function renderRules():void {
			for each (var ruleInput:Label in ruleInputs) {
				overrideSettings.removeChild(ruleInput);
			}
			if (ruleInputs != null) {
				ruleInputs.splice(0, ruleInputs.length);
			}
			var i:int = 0;
			for each (var rule:String in rules) {
				ruleInputs.push(new Label(overrideSettings, 0, axiomInput.y + axiomInput.height + axiomInput.height * i, rule));
				i++;
			}
		}
		
		private function setupSystemState(e:Event):void {
			overrideDefault.selected = false;
			lengthInput.value = savedSystem.selectedItem.length;
			angleInput.value = savedSystem.selectedItem.angle;
			evolutionInput.value = savedSystem.selectedItem.evolve;
			axiomInput.text = savedSystem.selectedItem.axiom;
			rules.splice(0, rules.length);
			for each (var rule:String in savedSystem.selectedItem.rules) {
				addRule(null, rule);
			}
		}
		
		private function stateChanged(e:Event = null):void {
			overrideSettings.visible = overrideDefault.selected;
			
			drawing.graphics.clear();
			
			var lsystem:LSystem;
			var painter:LSystemPainter;
			if (savedSystem.selectedItem != null && lsystemPainter.selectedItem != null) {
				
				painter = lsystemPainter.selectedItem as LSystemPainter;
				if (overrideDefault.selected) {
					lsystem = new LSystem(axiomInput.text, savedSystem.selectedItem.rules, savedSystem.selectedItem.grammar);
					lsystem.evolve(evolutionInput.value);
					painter.setup(lengthInput.value, angleInput.value);
				} else {
					lsystem = new LSystem(savedSystem.selectedItem.axiom, savedSystem.selectedItem.rules, savedSystem.selectedItem.grammar);
					lsystem.evolve(savedSystem.selectedItem.evolve);
					painter.setup(savedSystem.selectedItem.length, savedSystem.selectedItem.angle);
				}
				painter.paint(lsystem, drawing);
			}
		}
	
	}

}