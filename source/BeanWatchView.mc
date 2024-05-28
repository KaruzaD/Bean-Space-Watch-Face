import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Toybox.Time;
import Toybox.Time.Gregorian;

using Toybox.Activity;

class BeanWatchView extends WatchUi.WatchFace {
    private var foregroundColor;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        foregroundColor = Application.Properties.getValue("ForegroundColor");
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        getHeartrateDisplay().onShow();
        getBackground().onShow();
        getNotificationCountDisplay().onShow();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        getHeartrateDisplay().onHide();
        getBackground().onHide();
        getNotificationCountDisplay().onHide();
    }

    function onSettingsChanged() {
        foregroundColor = Application.Properties.getValue("ForegroundColor");
        getHeartrateDisplay().onSettingsChanged();
        getBackground().onSettingsChanged();
        getNotificationCountDisplay().onSettingsChanged();
        
        WatchUi.requestUpdate();  
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        setClockDisplay();
        setDateDisplay();
        setStepCountDisplay();
        setBatteryDisplay();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    private function setClockDisplay() {
        var clockTime = System.getClockTime();
        var timeStringHours = getTimeStringHours(clockTime);
        var timeStringMinutes = getTimeStringMinutes(clockTime);

        // Update the view
        var timeViewHours = View.findDrawableById("TimeLabelHours") as Text;
        var timeViewMinutes = View.findDrawableById("TimeLabelMinutes") as Text;
        
        timeViewHours.setColor(foregroundColor);
        timeViewMinutes.setColor(foregroundColor);
        timeViewHours.setText(timeStringHours);
        timeViewMinutes.setText(timeStringMinutes);
    }

    private function setDateDisplay() {
        var dateLabel = getDateLabel();

        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format("$1$\n$2$", [today.month.format("%02d"), today.day.format("%02d")]);

        dateLabel.setText(dateString);
    }

    private function setStepCountDisplay() {
        var stepDisplay = getStepCountDisplay();
        var stepLabel = getStepCountLabel();

        var info = ActivityMonitor.getInfo();
        var steps = info.steps as Number or Null;
        var stepGoal = info.stepGoal as Number or Null;

        if (steps == null) {
            steps = 0;
        }
        if (stepGoal == null || stepGoal == 0) {
            stepGoal = 1;
        }

        var stepPercent = steps.toFloat() / stepGoal;

        var stepFormat = "$1$";
        if (steps > 999) {
            stepFormat = "$1$k";
            steps *= 0.001;
        }

        stepDisplay.setPercent(stepPercent);
        stepLabel.setColor(foregroundColor);
        stepLabel.setText(Lang.format(stepFormat, [steps.format("%d")]));
    }
 

    private function setBatteryDisplay() as Void {
        var batteryDisplay = getBatteryDisplay();
        var batteryLabel = getBatteryLabel();

        var stats = System.getSystemStats();
        var batteryLevel = stats.battery;

        batteryDisplay.setPercent(batteryLevel * 0.01);
        batteryLabel.setColor(foregroundColor);
        batteryLabel.setText(batteryLevel.format("%d"));
    }

    private function getHeartrateDisplay() {
    	return View.findDrawableById("HeartrateDisplay");
    }

	private function getStepCountDisplay() {
		return View.findDrawableById("StepCountDisplay");    
	}

    private function getStepCountLabel() {
		return View.findDrawableById("StepCountLabel");    
	}

    private function getHeadingLabel() {
		return View.findDrawableById("HeadingLabel");    
	}

    private function getBackground() {
    	return View.findDrawableById("Background");
    }
    
    private function getNotificationCountDisplay() {
    	return View.findDrawableById("NotificationCountDisplay");
    }

    private function getDateLabel() {
		return View.findDrawableById("DateLabel");    
	}

    private function getBatteryDisplay() {
		return View.findDrawableById("BatteryDisplay");    
	}

    private function getBatteryLabel() {
		return View.findDrawableById("BatteryLabel");    
	}

    private function getTimeStringHours(clockTime) as String {
        // Get the current time and format it correctly
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        return Lang.format("$1$", [hours]);
    }

    private function getTimeStringMinutes(clockTime) as String {
        // Get the current time and format it correctly
        return clockTime.min.format("%02d");
    }


    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
