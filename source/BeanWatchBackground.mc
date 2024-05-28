import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {
    private var image;

    var imageResources = [
        Rez.Drawables.Space,
        Rez.Drawables.Fox,
        Rez.Drawables.SpaceFox,
        null,
    ];

    function initialize(params) {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function onShow() {
        getBitmap();
    }

    function onHide() {
        image = null;
    }

    function onSettingsChanged() {
        getBitmap();
    }

    function getBitmap() {
        var imageIndex = Application.Properties.getValue("BackgroundImage") as Number;

        var imageResource = imageResources[imageIndex];
        if (imageResource == null) {
            image = null;
            return;
        }

        image = WatchUi.loadResource(imageResource);
    }

    function draw(dc as Dc) as Void {
        if (image == null) {
            dc.setColor(Graphics.COLOR_TRANSPARENT, Application.Properties.getValue("BackgroundColor") as Number);
            dc.clear();
            return;
        }

        dc.clear();

        dc.drawBitmap(0, 0, image);
    }
}
