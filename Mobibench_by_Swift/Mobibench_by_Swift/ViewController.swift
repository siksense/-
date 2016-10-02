//
//  ViewController.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/2/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ioSizeSeq = 1024 * 256
    var fileSize = 1024 * 1024 * 128
    var mode = 0
    var dbSize = 100
    var dataSize = 4096
    
    @IBAction func showInsertView(sender: UIButton) {
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        
        let today = NSDate.init()
        let currentTime = dateFormatter.stringFromDate(today)
        print("\(currentTime)")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let phoneModel = UIDevice.currentDevice().model
        let current_iOS = UIDevice.currentDevice().systemVersion
        
        for _ in 0..<dbSize {
            appDelegate.insertData("AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ", phoneNumber: nil, mailAddr: nil)
        }
        
        let today2 = NSDate.init()
        let currentTime2 = dateFormatter.stringFromDate(today2)
        print("\(currentTime2)")
        
        let diff = today2.timeIntervalSinceDate(today)
        print("\(diff)")
        
        
        
        let strRR = "Device Model: \(phoneModel)\n" + "OS Version: \(current_iOS)\n" + "Excution per sec: " + String(format: "%.2f", (Double(dbSize) / diff))
        //"\nJournal mode: \(appDelegate.journalGet())"
        
        let alertController = UIAlertController(title: "Insert 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
            print("You have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showUpdateView(sender: UIButton) {
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        
        let today = NSDate.init()
        let currentTime = dateFormatter.stringFromDate(today)
        print("\(currentTime)")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let phoneModel = UIDevice.currentDevice().model
        let current_iOS = UIDevice.currentDevice().systemVersion
        
        for _ in 0..<dbSize {
            appDelegate.updateData("KKKKKKKKKKLLLLLLLLLLMMMMMMMMMMNNNNNNNNNOOOOOOOOOOPPPPPPPPPPQQQQQQQQQQRRRRRRRRRSSSSSSSSSTTTTTTTTTT",
                                   phoneNumber: nil,
                                   mailAddr: nil,
                                   oldName: "AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ")
        }
        
        let today2 = NSDate.init()
        let currentTime2 = dateFormatter.stringFromDate(today2)
        print("\(currentTime2)")
        
        let diff = today2.timeIntervalSinceDate(today)
        print("\(diff)")
        
        let strRR = "Device Model: \(phoneModel)\n" + "OS Version: \(current_iOS)\n" + "Excution per sec: " +
            String(format: "%.2f", (Double(dbSize) / diff))
        
        let alertController = UIAlertController(title: "Update 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
            print("You have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showDeleteView(sender: UIButton) {
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        
        let today = NSDate.init()
        let currentTime = dateFormatter.stringFromDate(today)
        print("\(currentTime)")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let phoneModel = UIDevice.currentDevice().model
        let current_iOS = UIDevice.currentDevice().systemVersion
        
        for _ in 0..<dbSize {
            appDelegate.deleteData(nil, phoneNumber: nil, mailAddr: nil)
        }
        
        let today2 = NSDate.init()
        let currentTime2 = dateFormatter.stringFromDate(today2)
        print("\(currentTime2)")
        
        let diff = today2.timeIntervalSinceDate(today)
        print("\(diff)")
        
        let strRR = "Device Model: \(phoneModel)\n" + "OS Version: \(current_iOS)\n" + "Excution per sec: " +
            String(format: "%.2f", (Double(dbSize) / diff))
        
        let alertController = UIAlertController(title: "Delete 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
            print("You have pressed the Cancel button")
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

