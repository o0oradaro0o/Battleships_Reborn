package  {
	
	import flash.display.MovieClip;
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	public class bsui extends MovieClip
	{
		// element details filled out by game engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		public function bsui() { }
		
		 //constructor, you usually will use onLoaded() instead
        public function CustomUI() : void {
        }
		
		// called by the game engine when this .swf has finished loading
		public function onLoaded():void
		{
			//Makes UI Visible
			visible = true;
			//Allows resizing of window, and sets listener for it
			Globals.instance.resizeManager.AddListener(this);
			//Subscribes to objects passed from game engine to our UI for updates
			this.modTimers.setup(this.gameAPI, this.globals);
		}
		
		public function onResize(re:ResizeManager) : * {
            //Calculate scale ratio
			var scaleRatioY:Number = re.ScreenHeight/768;
			
			//If the screen is bigger than our stage, keep elements the same size (you can remove this)
			if (re.ScreenHeight > 768){
				scaleRatioY = 1;
			}
			this.modTimers.screenResize(re.ScreenWidth, re.ScreenHeight, scaleRatioY);
		}
	}
}
