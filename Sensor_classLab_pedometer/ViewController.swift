//
//  ViewController.swift
//  Sensor_classLab_pedometer
//
//  Created by Andrii Damm on 2018-04-19.
//  Copyright © 2018 Andrii Damm. All rights reserved.

import UIKit
import CoreMotion

class ViewController: UIViewController {
    

    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    let startColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)

    var numberOfSteps:Int! = nil

    var distance:Double! = nil
    var averagePace:Double! = nil
    var pace:Double! = nil
    
    //the pedometer
    var pedometer = CMPedometer()
    
    // timers
    var timer = Timer()
    var timerInterval = 1.0
    var timeElapsed:TimeInterval = 1.0
    
    
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    @IBAction func startStopButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start"{
            //Start the pedometer
            pedometer = CMPedometer()
            startTimer()
            pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
                if let pedData = pedometerData{
                    self.numberOfSteps = Int(truncating: pedData.numberOfSteps)
                } else {
                    self.numberOfSteps = nil
                }
            })
           
            statusTitle.text = "Pedometer On"
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = stopColor
        } else {
            //Stop the pedometer
            pedometer.stopUpdates()
            stopTimer()
        
            statusTitle.text = "Pedometer Off: " + timeIntervalFormat(interval: timeElapsed)
            sender.backgroundColor = startColor
            sender.setTitle("Start", for: .normal)
        }
    }
  
    func startTimer(){
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
        displayPedometerData()
    }
    
    @objc func timerAction(timer:Timer){
        displayPedometerData()
    }
 
    func displayPedometerData(){
        timeElapsed += 1.0
        statusTitle.text = "On: " + timeIntervalFormat(interval: timeElapsed)
        //Number of steps
        if let numberOfSteps = self.numberOfSteps{
            stepsLabel.text = String(format:"Steps: %i",numberOfSteps)
        }


    }

    func timeIntervalFormat(interval:TimeInterval)-> String{
        var seconds = Int(interval + 0.5)
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

