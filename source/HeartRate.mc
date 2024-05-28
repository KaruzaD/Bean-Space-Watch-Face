import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Lang;

class HeartRate extends WatchUi.Drawable {
    private var myText;
    private var x;
    private var y;
    private var heartLogo;

    function initialize(params) {
        Drawable.initialize(params);
        x = params.get(:locX);
        y = params.get(:locY);
    }

    function onShow() {
        getBitmap();
        getText();
    }

    function onHide() {
        heartLogo = null;
        myText = null;
    }

    function onSettingsChanged() { 
        if (myText == null) {
            return;
        }

        getText();
    }

    function getBitmap() {
        heartLogo = WatchUi.loadResource(Rez.Drawables.PixelHeart);
    }

    function draw(dc) {
        dc.drawBitmap(x - heartLogo.getWidth() * 0.5, y - heartLogo.getHeight() * 0.5, heartLogo);
        
        setHeartRateDisplay();

        myText.draw(dc);
    }

    private function setHeartRateDisplay() {
		myText.setText(retrieveHeartRateString());
    }

    private function retrieveHeartRateString() as String {
        var info = Activity.getActivityInfo();
        if (info == null) {
            return "-";
        }
        var heartRate = info.currentHeartRate;
        if (heartRate == null) {
            return "-";
        }
		
		return heartRate.format("%d");
    }

    private function DoesDeviceSupportHeartrate() {
    	return ActivityMonitor has :INVALID_HR_SAMPLE;
    }

    private function getText() {
        var foregroundColor = Application.Properties.getValue("ForegroundColor");

        myText = new WatchUi.Text({
            :text => "00",
            :color => foregroundColor,
            :font => Graphics.FONT_XTINY,
            :locX => x,
            :locY => y-15,
        });
        myText.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
    }
}