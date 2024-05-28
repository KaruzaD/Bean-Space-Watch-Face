
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Math;

class CircularBar extends WatchUi.Drawable {
	hidden var centerX;
    hidden var centerY;

	hidden var percent, unfilledColor, filledColor, filledColorLow, filledColorCritical, barThickness, radius;
	hidden var lowThreshold, criticalThreshold;
    
	function initialize(params) {
        Drawable.initialize(params);

        unfilledColor = params.get(:unfilledColor);
		filledColor = params.get(:filledColor);
		filledColorLow = params.get(:filledColorLow);
		filledColorCritical = params.get(:filledColorCritical);
        percent = params.get(:percent);                
        barThickness = params.get(:barThickness);    
		centerX = params.get(:x);
		centerY = params.get(:y);          
        radius = params.get(:radius);
		lowThreshold = params.get(:lowThreshold);
		criticalThreshold = params.get(:criticalThreshold);          
    }

    function draw(dc) {
		dc.setPenWidth(barThickness);
		drawOutlineCircle(dc);
        drawArc(dc);
    }
    
    function setPercent(newPercent) {
    	percent = newPercent;       	 
    }

	private function drawOutlineCircle(dc as Dc) as Void {
		dc.setColor(unfilledColor, unfilledColor);
		dc.drawCircle(centerX, centerY, radius);
	}
    
    hidden function drawArc(dc as Dc) {      	        	    
    	if (percent == 0) {
			return;
		}

		var color;
		if (percent <= criticalThreshold) {
			color = filledColorCritical;
		} else if (percent < lowThreshold) {
			color = filledColorLow;
		} else {
			color = filledColor;
		}
		dc.setColor(color, color);         
    	
		var degreeStart = 90;
		//450 because 0 degrees is right side of circle, and we want to start at the top
		//which is 360 + 90 = 450, without going into negative degrees
		var degreeEnd = 450 - (360 * percent);
		
		dc.setPenWidth(barThickness+1);
		dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, degreeStart, degreeEnd);
    }     
    
    hidden function degreesToRadians(degrees) {
    	return degrees * Math.PI / 180;
    }  
    
    hidden function radiansToDegrees(radians) {
    	return radians * 180 / Math.PI;
    }  
}