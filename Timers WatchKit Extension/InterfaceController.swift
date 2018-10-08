//
//  InterfaceController.swift
//  Timers WatchKit Extension
//
//  Created by Kevin R Mullen on 10/8/18.
//  Copyright © 2018 Kevin R Mullen. All rights reserved.
//

import WatchKit
import Foundation

enum clockState{
    
    case ACTIVE, STOPPED, RESET
}

enum clockCommand{
    
    case START, STOP, RESET
}

class InterfaceController: WKInterfaceController {
    
    var timerMasterClock = Timer()
    
    var timerAccumulator: Double = 0
    
    var dateStart: Date = Date()
    var dataStop: Date = Date()
    
    var dateDeactivated: Date = Date()
    var dateWillAppear: Date = Date()
    
    var timeInterval: TimeInterval = TimeInterval()
    
    var clockMainState: clockState = .RESET
    
    @IBOutlet weak var labelClock: WKInterfaceLabel!
    
    @IBOutlet weak var timerMainDisplay: WKInterfaceTimer!
    
    @IBOutlet weak var buttonStartStop: WKInterfaceButton!
    
    @IBAction func buttonStartStopPressed() {
        
        switch clockMainState {
            
        case .ACTIVE:
            //GO TO STOPPED
            timerMasterClockAction(.STOP)
            buttonStartStop.setTitle("START")
            buttonStartStop.setBackgroundColor(UIColor.darkGray)
            timerMainDisplay.stop()
            
            clockMainState = .STOPPED
            
        case .RESET:
            //GO TO ACTIVE
            timerMasterClockAction(.START)
            timerMainDisplay.setDate(Date()-timerAccumulator)

            buttonStartStop.setTitle("PAUSE")
            buttonStartStop.setBackgroundColor(UIColor.orange)
            timerMainDisplay.start()
            
            clockMainState = .ACTIVE
            
            
        case .STOPPED:
            //GO TO ACTIVE
            timerMasterClockAction(.START)
            timerMainDisplay.setDate(Date()-timerAccumulator)

            buttonStartStop.setTitle("PAUSE")
            buttonStartStop.setBackgroundColor(UIColor.orange)
            timerMainDisplay.start()
            clockMainState = .ACTIVE
            
        }
        
        
    }
    
    func timerMasterClockAction(_ command: clockCommand){
        
        switch command{
            
        case .RESET:
            timerMasterClock.invalidate()

        case .STOP:
            timerMasterClock.invalidate()
            
        case .START:
            DispatchQueue.main.async { [unowned self] in
                self.timerMasterClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(InterfaceController.timerAction), userInfo: nil, repeats: true)
                
            }
            
        }
        
    }
    
    /*
    func toggleWatchTimer(){
        
        switch watchClockState {
            
        case .ACTIVE:
            
            //turn OFF the timer and record what the magintude timeInterval) is
            stopTime = Date()
            
            timerCurrentCount += stopTime.timeIntervalSince(startTime)
            
            basicTimer.stop()
            
            watchClockState = .STOPPED
            
            basicTimer.setTextColor(UIColor.red)
            
            
        case .STOPPED, .RESET:
            
            
            //var timerInterval = clockStoppedTime.timeIntervalSince(clockStartedTime)
            
            startTime = Date() // the now()
            
            let setTime = startTime.addingTimeInterval(-timerCurrentCount)
            //timerCurrentCount = 0
            
            basicTimer.setDate(setTime)
            basicTimer.start()
            watchClockState = .ACTIVE
            //clockStartedTime = Date()
            basicTimer.setTextColor(UIColor.green)
            
            
            
        case .MAXLIMIT:
            break
        }
        
    }
    */
    
    
    @objc func timerAction(){
        timerAccumulator += 1
        labelClock.setText(String(timerAccumulator))
    }
    
    @IBOutlet weak var buttonReset: WKInterfaceButton!
    
    @IBAction func buttonResetPressed() {
        
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        clockMainState = .RESET
        timerAccumulator = 0
        timerMainDisplay.setDate(Date()) // basically 0
        timerMainDisplay.stop()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        timerMainDisplay.setDate(Date()-timerAccumulator)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
