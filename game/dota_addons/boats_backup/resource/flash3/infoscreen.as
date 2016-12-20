package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class InfoScreen extends MovieClip {
		var gameAPI:Object;
		var globals:Object;
		var first;
		var origx;
		var origy;
		
		public function InfoScreen(api:Object, globals:Object) {
			// constructor code
		}
		public function setup(api:Object, globals:Object) {
			// constructor code
			this.gameAPI = api;
			this.globals = globals;
			this.InfoClose.addEventListener(MouseEvent.CLICK, onButtonClicked);
			this.InfoClose2.addEventListener(MouseEvent.CLICK, onButtonClicked);
			origx = this.scaleX;
			origy = this.scaleY;
			
			var scaleRatioX = stage.stageWidth/1900;
			var scaleRatioY = stage.stageHeight/1200;
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			 
		}
		private function onButtonClicked(event:MouseEvent) : void {
            this.visible = false;
        }
		public function screenResize(stageX:int, stageY:int, scaleRatioX:Number, scaleRatioY:Number){
			//position 'this', being this module, at the center of the screen
			this.x = 0;
			this.y = 0;
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			
		}
	}
}
