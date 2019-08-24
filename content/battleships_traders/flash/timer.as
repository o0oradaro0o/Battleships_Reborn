package  {
	
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	
	public class timer extends MovieClip {
		var gameAPI:Object;
		var globals:Object;
		
		public function timer() {
			//this.empireGoldTimer.Text = "Empire Gold In: ";
			//this.nextCreepSpawn.Text = "Next Creep Wave In: ";
		}
		
		public function setup(api:Object, globals:Object) {
			this.gameAPI = api;
			this.globals = globals;
			
			this.gameAPI.SubscribeToGameEvent( "bsui_timer_data", getTimerValues );
		}
		
		public function getTimerValues( eventData:Object ):void {
			var tEmpire = (eventData.nEmpire / 60).toString() + ":" + (eventData.nEmpire % 60).toString();
			var tCreep  = (eventData.nCreep / 60).toString() + ":" + (eventData.nCreep % 60).toString();
			
			this.timerValues.text = tEmpire + "<br />" + tCreep;
		}
		public function screenResize(stageX:int, stageY:int, scaleRatio:Number){
			//position 'this', being this module, at the center of the screen
			this.x = stageX/2;
			this.y = stageY/2;
			
			
			//save this movieClip's original scale
			if(this["originalXScale"] == null)
			{
				this["originalXScale"] = this.scaleX;
				this["originalYScale"] = this.scaleY;
			}
    
			//Scale this module/movieClip by the scaleRatio
			this.scaleX = this["originalXScale"] * scaleRatio;
			this.scaleY = this["originalYScale"] * scaleRatio;
		}
	}
}
