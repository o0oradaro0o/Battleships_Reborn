package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class timer extends MovieClip {
		var gameAPI:Object;
		var globals:Object;
		var first;
		var origx;
		var origy;
		var showingzoom;
		public function timer() {
			//this.empireGoldTimer.Text = "Empire Gold In: ";
			//this.nextCreepSpawn.Text = "Next Creep Wave In: ";
		}
		
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			origx = this.scaleX;
			origy = this.scaleY;
			showingzoom=false;
			
			//empGoldLbl.text = globals.instance.GameInterface.Translate("#empLabel");
			//creepLabel.text = globals.instance.GameInterface.Translate("#creepLabel");
			
			
			this.zoomBtn.addEventListener(MouseEvent.CLICK, onButtonClicked);
			
			var scaleRatioX = stage.stageWidth/1900;
			var scaleRatioY = stage.stageHeight/1200;
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			this.gameAPI.SubscribeToGameEvent( "bsui_timer_data", getTimerValues );
			this.SliderHolder.setup(api, globals);
			this.SliderHolder.visible=false;
		}
		
		private function onButtonClicked(event:MouseEvent) : void {
            if (showingzoom)
			{
				this.SliderHolder.visible=false;
				showingzoom=false;
			}
			else
			{
				this.SliderHolder.visible=true;
				showingzoom=true;
			}
			
        }
		
		public function getTimerValues( eventData:Object ):void {
			
			var tEmpire = (Math.floor(eventData.nEmpire/60)) + ":" + (eventData.nEmpire % 60 >= 10 ? "": "0") +  (eventData.nEmpire % 60);                 
			var tCreep = (Math.floor(eventData.nCreep/60)) + ":" + (eventData.nCreep % 60 >= 10 ? "": "0") +  (eventData.nCreep % 60);  
			
			this.timerValues.text = tEmpire + "\n" + tCreep;
			
		}
		public function screenResize(stageX:int, stageY:int, scaleRatioX:Number, scaleRatioY:Number){
			//position 'this', being this module, at the center of the screen
			this.x = stageX;
			//position 'this', being this module, at the center of the screen
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			
		}
	}
}
