
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;
import Toybox.Lang;

class HeadingDisplay extends WatchUi.Drawable {
	hidden var centerX;
    hidden var centerY;
    private var myText;

    private var barThickness = 6;
    private var radius = 28;
    
    function initialize(params) {
        Drawable.initialize(params);

		centerX = params.get(:x);
		centerY = params.get(:y);

        getText();              
    }

    function draw(dc) {
		var heading = getHeading();

        dc.setPenWidth(barThickness);
		drawOutlineCircle(dc);
        drawArc(dc, heading);

        myText.setText(getHeadingString(heading));
        myText.draw(dc);
    }

	private function drawOutlineCircle(dc as Dc) as Void {
		dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_DK_GRAY);
		dc.drawCircle(centerX, centerY, radius);
	}
    
    hidden function drawArc(dc as Dc, heading as Number or Null) {      	        	    
    	if (heading == null || heading == 0) {
            return;
        }

        var direction = heading >= 0 ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;

        var headingDegrees = radiansToDegrees(heading);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.setPenWidth(barThickness+1);
		dc.drawArc(centerX, centerY, radius, direction, 90, 450 - headingDegrees);
    }

    function getHeading() {
        var info = Activity.getActivityInfo();
        if (info == null) {
            return null;
        }

        return info.currentHeading;
    }

    function getHeadingString(heading) {
        if (heading == null) {
            return "-";
        }

        heading = radiansToDegrees(heading);
        if (heading < 0) {
            heading += 360;
        }
        return heading.format("%d");
    }   
    
    hidden function degreesToRadians(degrees) {
    	return degrees * Math.PI / 180;
    }  
    
    hidden function radiansToDegrees(radians) {
    	return radians * 180 / Math.PI;
    }

    private function getText() {
        var foregroundColor = Application.Properties.getValue("ForegroundColor");

        myText = new WatchUi.Text({
            :text => "00",
            :color => foregroundColor,
            :font => Graphics.FONT_XTINY,
            :locX => centerX,
            :locY => centerY - 15,
        });
        myText.setJustification(Graphics.TEXT_JUSTIFY_CENTER);
    }
}