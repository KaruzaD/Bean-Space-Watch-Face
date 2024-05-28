import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class NotificationDisplay extends WatchUi.Drawable {
    private var image;
    private var myText;
    
    protected var x;
    protected var y;

    private var previousCount = null;

    function initialize(params) {
        Drawable.initialize(params);

        self.x = params.get(:x);
        self.y = params.get(:y);
    }

    function onShow() {
        getText();
    }

    function onHide() {
        image = null;
        myText = null;
    }

    function onSettingsChanged() { 
        if (myText == null) {
            return;
        }

        getText();
    }

    function getBitmap(isNew as Boolean) {
        if (isNew) {
            image = WatchUi.loadResource(Rez.Drawables.NotificationNew);
        } else {
            image = WatchUi.loadResource(Rez.Drawables.NotificationNone);
        }
        
    }

    private function getNotificationCount() {
        return System.getDeviceSettings().notificationCount;
    }

    private function getNotificationString(count) {
		if(count > 10)	{
			return "10+";
		}
		else {
			return count.format("%d");
		}
    }

    function draw(dc as Dc) as Void {
        var count = getNotificationCount();
        
        drawImage(dc, count);
        drawText(dc, count);
        
    }

    private function drawImage(dc as Dc, count as Number) {
        if (image == null or count != previousCount) {
            getBitmap(count > 0);
            previousCount = count;
        }
        var locX = x - image.getWidth();
        dc.drawBitmap(locX, y - 7, image);
    }

    private function drawText(dc as Dc, count as Number) {
        var countString = getNotificationString(count);
        myText.setText(countString);
        myText.draw(dc);
    }

    private function getText() {
        var foregroundColor = Application.Properties.getValue("ForegroundColor");

        myText = new WatchUi.Text({
            :text => "00",
            :color => foregroundColor,
            :font => Graphics.FONT_XTINY,
            :locX => x+3,
            :locY => y-15,
        });
    }

}