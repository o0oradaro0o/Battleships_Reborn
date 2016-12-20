package  {
    import flash.display.MovieClip;
    import scaleform.clik.events.*;
    import flash.utils.getDefinitionByName;
    import flash.events.*; 

    import ValveLib.*;
    import flash.text.TextFormat;

    //import some stuff from the valve lib
    import ValveLib.Globals;
    import ValveLib.ResizeManager;

    public class Options extends MovieClip {

        public var gameAPI:Object
        public var globals:Object
        var _camDistSlider:Object
        var currCamDist:int = 2000
        var currDistLabelT:String // currDistLabel translated
		var first;
		var origx;
		var origy;
		var ops:Object = null;
        public function Options() {
            // constructor code
        }

        //set initialise this instance's gameAPI
        public function setup(api:Object, globals:Object) {
            this.gameAPI = api;
            this.globals = globals;

            // set this to at least 2000 above the max slider value.
            // it's necessary for the game to render properly while zooming
            Globals.instance.GameInterface.SetConvar("r_farz", "6000")

            addEventListener(Event.ENTER_FRAME, myEnterFrame)

            //camDistLabel.text = Globals.instance.GameInterface.Translate("#CamDistLabel")
            //currDistLabelT = Globals.instance.GameInterface.Translate("#CurrDistLabel")
            //currDistLabel.text = currDistLabelT

            _camDistSlider = replaceWithValveComponent(camDistSlider, "Slider_New", true)
            _camDistSlider.minimum = 900
            _camDistSlider.maximum = 4000
			
			ops = Globals.instance.GameInterface.LoadKVFile('scripts/bships_options.kv');
			if (ops.CamDist != null)
			{
				_camDistSlider.value = int(ops.CamDist);
				currCamDist = int(ops.CamDist)
			}
			else
			{;
           		_camDistSlider.value = 2000
			}
            _camDistSlider.snapInterval = 50
            _camDistSlider.addEventListener( SliderEvent.VALUE_CHANGE, onCamDistSliderChanged )
			
			origx = this.scaleX;
			origy = this.scaleY;
			
			var scaleRatioX = stage.stageWidth/1900;
			var scaleRatioY = stage.stageHeight/1200;
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			
            trace("##Called Options Setup!");
        }

        public function onCamDistSliderChanged(e:SliderEvent) {
            var currVal:int = _camDistSlider.value
            trace("Current value: " + currVal)
            currCamDist = currVal
			ops.CamDist = String(currCamDist);
			Globals.instance.GameInterface.SaveKVFile(ops, 'scripts/bships_options.kv', 'Options');
        }

        private function myEnterFrame(e:Event) : void {
            //trace("myEnterFrame Options")
            Globals.instance.GameInterface.SetConvar("dota_camera_distance", currCamDist.toString())
            currDistLabel.text = currDistLabelT + " " + currCamDist
        }

        //Parameters: 
        //  mc - The movieclip to replace
        //  type - The name of the class you want to replace with
        //  keepDimensions - Resize from default dimensions to the dimensions of mc (optional, false by default)
        public function replaceWithValveComponent(mc:MovieClip, type:String, keepDimensions:Boolean = false) : MovieClip {
            var parent = mc.parent;
            var oldx = mc.x;
            var oldy = mc.y;
            var oldwidth = mc.width;
            var oldheight = mc.height;

            var newObjectClass = getDefinitionByName(type);
            var newObject = new newObjectClass();
            newObject.x = oldx;
            newObject.y = oldy;
            if (keepDimensions) {
                newObject.width = oldwidth;
                newObject.height = oldheight;
            }

            parent.removeChild(mc);
            parent.addChild(newObject);

            return newObject;
        }

        //onScreenResize
    	 public function screenResize(stageX:int, stageY:int, scaleRatioX:Number, scaleRatioY:Number){
			//position 'this', being this module, at the center of the screen
			this.x = 0;
			this.y = 0;
			//position 'this', being this module, at the center of the screen
			this.scaleX = origx * scaleRatioX;
			this.scaleY = origy * scaleRatioY;
			
			
		}
    }   
}