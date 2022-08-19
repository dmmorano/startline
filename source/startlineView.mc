import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;

const SYNC_SECOND_WINDOW = 10;

var myCount =  0;
var m_startTime = 0;
var m_running = false;

var m_curTimerMs;

var m_tHours = 0;
var m_tMinutes = 0;
var m_tSeconds = 0;
var m_tHundreds = 0;
var m_offset = 0;

function timerCallback() {
    myCount += 1;
    WatchUi.requestUpdate();
}

class startlineView extends WatchUi.View {

    var m_screenShape;
    var m_width;
	var m_height;
    var m_updateTimer;
    var m_timerText = "00:03:00.00";
    var m_hardcodedStartTime = 180*1000;
    var m_refreshPeriod = 1000;
    var m_timerTotalTime = 180*1000;

    function initialize() {
        View.initialize();

        m_screenShape = System.getDeviceSettings().screenShape;

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        // Create a counter that increments by one each second
		m_updateTimer = new Timer.Timer();
		m_updateTimer.start(method(:timerCallback), m_refreshPeriod, true);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        m_width = dc.getWidth();
		m_height = dc.getHeight();

         // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        drawCurClockTime(dc);
        drawCurTimerTime(dc);

       
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function updateFormRefreshPeriod(period) as Void {
        if (period != m_refreshPeriod) {
            m_refreshPeriod = period;
            m_updateTimer.start(method(:timerCallback), m_refreshPeriod, true);
        }
    }

    function drawCurClockTime(dc) as Void {
        var myTime = System.getClockTime(); // ClockTime object
		var myTimeText = myTime.hour.format("%02d") + ":" + myTime.min.format("%02d") + ":" + myTime.sec.format("%02d");
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(m_width * 0.33, m_height * 0.05, Graphics.FONT_SYSTEM_LARGE, myTimeText,  Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawCurTimerTime(dc) as Void {
        
        //Default displayed time values to the selected timer total
        m_curTimerMs =  m_timerTotalTime;

        if (m_running && m_curTimerMs > 0) {
            //If the timer is running, calculate the display values accordingly     
            var currentTime = System.getTimer();
            m_curTimerMs =  m_timerTotalTime - (currentTime - m_startTime) + m_offset;
           
            updateFormRefreshPeriod(50);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dc.drawText(m_width * 0.02, m_height * 0.725, Graphics.FONT_SYSTEM_SMALL, "SYNC",  Graphics.TEXT_JUSTIFY_LEFT);
            

        } else {
            updateFormRefreshPeriod(1000);
        }

        if (m_curTimerMs < 0) {m_curTimerMs = 0;}

        //Calculate displayed time values
        m_tHours = Math.floor(m_curTimerMs/3600000l);
	    m_tMinutes = Math.floor((m_curTimerMs - m_tHours*3600000l)/60000l);
	    m_tSeconds = Math.floor((m_curTimerMs - m_tHours*3600000l - m_tMinutes*60000l)/1000l); 
	    m_tHundreds = Math.floor((m_curTimerMs - m_tHours*3600000l - m_tMinutes*60000l - m_tSeconds*1000l)/10);

        var dateString = Lang.format(
	    "$1$:$2$.$3$",
	    [
	        m_tMinutes.format("%02d"),
	        m_tSeconds.format("%02d"),
	        m_tHundreds.format("%02d")
	    ]
	    );

        m_timerText = dateString;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(m_width * 0.5, m_height * 0.45, Graphics.FONT_SYSTEM_LARGE, m_timerText,  Graphics.TEXT_JUSTIFY_CENTER);
        
    }

}


