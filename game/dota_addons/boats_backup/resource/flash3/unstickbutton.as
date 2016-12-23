package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class UnstickButton extends MovieClip {
		
		var gameAPI:Object;
		var globals:Object;
		var first;
		var origx;
		var origy;
		public function UnstickButton(api:Object, globals:Object) {
			
		}
		public function setup(api:Object, globals:Object) {
			// constructor code
			this.gameAPI = api;
			this.globals = globals;
			this.UnstickMe.addEventListener(MouseEvent.CLICK, onButtonClicked);
			origx = this.scaleX;
			origy = this.scaleY;
			
			var scaleRatioX = stage.stageWidth/1900;
			var scaleRatioY = stage.stageHeight/1200;
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			 
		}
		private function onButtonClicked(event:MouseEvent) : void {
            this.gameAPI.SendServerCommand("UnstickMe 1");
        }
		
		public function screenResize(stageX:int, stageY:int, scaleRatioX:Number, scaleRatioY:Number){
			//position 'this', being this module, at the center of the screen
			this.x = stageX;
			this.y = stageY;
			//position 'this', being this module, at the center of the screen
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			
		}
		
	}
	
}
