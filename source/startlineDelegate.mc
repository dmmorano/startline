import Toybox.Lang;
using Toybox.WatchUi as Ui;
using Toybox.System as System;
using Toybox.Time as Time;

class startlineDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        var menu = new Ui.Menu();
        menu.setTitle("Timers");
        menu.addItem("3:00", :one);
        menu.addItem("5:00", :two);

        WatchUi.pushView(menu, new startlineMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onKey(keyEvent) as Boolean {
        System.println("Pressed: " + keyEvent.getKey().toString());
        if(keyEvent.getKey()==Ui.KEY_ENTER) {
            var now = System.getTimer();
            m_startTime = now;
            m_offset = 0;
            m_running = !m_running;
            System.println("timer start time stored: " + now.toString());
        }

        if (keyEvent.getKey()==Ui.KEY_DOWN) {
            if (m_running) {
                var mod = (m_curTimerMs % 60000);
                var modSec = mod / 1000;
                var offset = 0;
                //Adjust just below 1m
                if (modSec > 60 - SYNC_SECOND_WINDOW) {
                    offset = 60000-mod;
                }

                //Adjust just above 1m/0s
                if (modSec < SYNC_SECOND_WINDOW) {
                    offset = -mod;
                }

                //Adjust around 30s
                if (modSec > 30 - SYNC_SECOND_WINDOW && modSec < 30 + SYNC_SECOND_WINDOW) {
                    offset = 30000-mod;
                }

                m_offset += offset;


            }
        }




        return true;
 
    }    


}