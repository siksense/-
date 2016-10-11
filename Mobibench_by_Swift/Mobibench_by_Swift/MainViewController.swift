//
//  MainViewController.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/2/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var dbSizeSegment: UISegmentedControl!
    @IBOutlet weak var journalSegment: UISegmentedControl!
    @IBOutlet weak var fileSizeSegment: UISegmentedControl!
    @IBOutlet weak var sequentialIOSizeSegment: UISegmentedControl!
    @IBOutlet weak var randomDataSizeSegment: UISegmentedControl!
    @IBOutlet weak var ioModeSegment: UISegmentedControl!
    
    var insertSpeed: String = ""
    var updateSpeed: String = ""
    var deleteSpeed: String = ""
    var sequentialIOSpeed: String = ""
    var randomIOSpeed: String = ""
    
    @IBAction func analyzePerformance(sender: UIButton) {
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Insert 속도 측정
        var start = NSDate.init()
        do {
            for _ in 0..<appDelegate.dbSize {
                try appDelegate.insertData("AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ")
            }
        } catch let e {
            print("Error: ", e)
        }
        var finish = NSDate.init()
        var diff = finish.timeIntervalSinceDate(start)
        self.insertSpeed = String(format: "%.2f", (Double(appDelegate.dbSize) / diff))
        
        // Update 속도 측정
        start = NSDate.init()
        do {
            for _ in 0..<appDelegate.dbSize {
                try appDelegate.updateData("KKKKKKKKKKLLLLLLLLLLMMMMMMMMMMNNNNNNNNNOOOOOOOOOOPPPPPPPPPPQQQQQQQQQQRRRRRRRRRSSSSSSSSSTTTTTTTTTT",
                                           oldName: "AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ")
            }
        } catch let e {
            print("Error: ", e)
        }
        finish = NSDate.init()
        diff = finish.timeIntervalSinceDate(start)
        self.updateSpeed = String(format: "%.2f", (Double(appDelegate.dbSize) / diff))
        
        // Delete 속도 측정
        start = NSDate.init()
        do {
            for _ in 0..<appDelegate.dbSize {
                try appDelegate.deleteData()
            }
        } catch let e {
            print("Error: ", e)
        }
        finish = NSDate.init()
        diff = finish.timeIntervalSinceDate(start)
        self.deleteSpeed = String(format: "%.2f", (Double(appDelegate.dbSize) / diff))
        
        // Sequential I/O 속도 측정
        start = NSDate.init()
        for _ in 0..<appDelegate.fileSize/appDelegate.sequentialIOSize {
            appDelegate.fileHandler.writeData((appDelegate.sampleString.dataUsingEncoding(NSUTF8StringEncoding))!)
        }
        finish = NSDate.init()
        diff = finish.timeIntervalSinceDate(start)
        self.sequentialIOSpeed = String(format: "%.2f", (Double(appDelegate.fileSize)/diff/1048576))
        
        // Random I/O 속도 측정
        start = NSDate.init()
        switch appDelegate.mode {
        case 0:
            for i in 0..<appDelegate.fileSize/4096 {
                appDelegate.fileHandler.seekToFileOffset(UInt64(appDelegate.randomOffset[i] * 4096))
                appDelegate.fileHandler.writeData((appDelegate.sampleString2.dataUsingEncoding(NSUTF8StringEncoding))!)
            }
        case 1:
            for i in 0..<appDelegate.fileSize/4096 {
                appDelegate.fileHandler.seekToFileOffset(UInt64(appDelegate.randomOffset[i] * 4096))
                appDelegate.fileHandler.writeData((appDelegate.sampleString2.dataUsingEncoding(NSUTF8StringEncoding))!)
                fsync(appDelegate.fileHandler.fileDescriptor)
            }
        case 2:
            fcntl(appDelegate.fileHandler.fileDescriptor, F_NOCACHE)
            for i in 0..<appDelegate.fileSize/4096 {
                appDelegate.fileHandler.seekToFileOffset(UInt64(appDelegate.randomOffset[i] * 4096))
                appDelegate.fileHandler.writeData((appDelegate.sampleString2.dataUsingEncoding(NSUTF8StringEncoding))!)
            }
        default:
            for i in 0..<appDelegate.fileSize/4096 {
                appDelegate.fileHandler.seekToFileOffset(UInt64(appDelegate.randomOffset[i] * 4096))
                appDelegate.fileHandler.writeData((appDelegate.sampleString2.dataUsingEncoding(NSUTF8StringEncoding))!)
            }
        }
        finish = NSDate.init()
        diff = finish.timeIntervalSinceDate(start)
        self.randomIOSpeed = String(format: "%.2f", (Double(appDelegate.fileSize)/diff/4096))
                
        print("Jounal Mode: \(appDelegate.getJournalMode()), Insert: \(insertSpeed), Update: \(updateSpeed), Delete: \(deleteSpeed), Seq I/O: \(sequentialIOSpeed), Ran I/O: \(randomIOSpeed)")
    }
    
    @IBAction func selectDBSize(sender: UISegmentedControl) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        switch dbSizeSegment.selectedSegmentIndex {
        case 0:
            appDelegate.dbSize = 100
        case 1:
            appDelegate.dbSize = 500
        case 2:
            appDelegate.dbSize = 1000
        default:
            appDelegate.dbSize = 100
        }
    }
    @IBAction func selectJournalMode(sender: UISegmentedControl) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        switch journalSegment.selectedSegmentIndex {
        case 0:
            appDelegate.changeJournalMode("delete")
        case 1:
            appDelegate.changeJournalMode("WAL")
        default:
            appDelegate.changeJournalMode("delete")
        }

    }
    @IBAction func selectFileSize(sender: UISegmentedControl) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        switch fileSizeSegment.selectedSegmentIndex {
        case 0:
            appDelegate.fileSize = 1024 * 1024 * 32
        case 1:
            appDelegate.fileSize = 1024 * 1024 * 64
        case 2:
            appDelegate.fileSize = 1024 * 1024 * 128
        default:
            appDelegate.fileSize = 1024 * 1024 * 32
        }

    }
    @IBAction func selectIOSize(sender: UISegmentedControl) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        switch sequentialIOSizeSegment.selectedSegmentIndex {
        case 0:
            appDelegate.sequentialIOSize = 1024 * 256
        case 1:
            appDelegate.sequentialIOSize = 1024 * 512
        case 2:
            appDelegate.sequentialIOSize = 1024 * 768
        default:
            appDelegate.sequentialIOSize = 1024 * 256
        }

    }
    @IBAction func selectDataSize(sender: UISegmentedControl) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        switch randomDataSizeSegment.selectedSegmentIndex {
        case 0:
            appDelegate.dataSize = 64
        case 1:
            appDelegate.dataSize = 4096
        default:
            appDelegate.dataSize = 64
        }

    }
    @IBAction func selectIOMode(sender: UISegmentedControl) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        switch ioModeSegment.selectedSegmentIndex {
        case 0:
            appDelegate.mode = 0
        case 1:
            appDelegate.mode = 1
        case 2:
            appDelegate.mode = 2
        default:
            appDelegate.mode = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let resultsView: ResultsViewController = segue.destinationViewController as! ResultsViewController
//        
//        resultsView.receivedInsertResult = insertSpeed
//        resultsView.receivedUpdateResult = updateSpeed
//        resultsView.receivedDeleteResult = deleteSpeed
//        resultsView.receivedSequentialResult = sequentialIOSpeed
//        resultsView.receivedRandomResult = randomIOSpeed
//    }
}



//@IBAction func showInsertView(sender: UIButton) {
//    let dateFormatter = NSDateFormatter.init()
//    dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
//    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let phoneModel = UIDevice.currentDevice().model
//    let current_iOS = UIDevice.currentDevice().systemVersion
//    
//    let start = NSDate.init()
//    do {
//        for _ in 0..<dbSize {
//            try appDelegate.insertData("AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ")
//        }
//    } catch let e {
//        print("Error: ", e)
//    }
//    let finish = NSDate.init()
//    
//    let startTime = dateFormatter.stringFromDate(start)
//    let finishTime = dateFormatter.stringFromDate(finish)
//    print("Start time: \(startTime)")
//    print("Finish time: \(finishTime)")
//    
//    let diff = finish.timeIntervalSinceDate(start)
//    print("\(diff)")
//    
//    let strRR = "Device Model: \(phoneModel)\n" + "OS Version: \(current_iOS)\n" + "Excution per sec: " + String(format: "%.2f", (Double(dbSize) / diff)) +
//        "\nJournal mode: " + appDelegate.getJournalMode()
//    
//    let alertController = UIAlertController(title: "INSERT 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
//        print("You have pressed the Cancel button")
//    }
//    alertController.addAction(cancelAction)
//    
//    self.presentViewController(alertController, animated: true, completion: nil)
//}
//
//@IBAction func showUpdateView(sender: UIButton) {
//    let dateFormatter = NSDateFormatter.init()
//    dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
//    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let phoneModel = UIDevice.currentDevice().model
//    let current_iOS = UIDevice.currentDevice().systemVersion
//    
//    let start = NSDate.init()
//    do {
//        for _ in 0..<dbSize {
//            try appDelegate.updateData("KKKKKKKKKKLLLLLLLLLLMMMMMMMMMMNNNNNNNNNOOOOOOOOOOPPPPPPPPPPQQQQQQQQQQRRRRRRRRRSSSSSSSSSTTTTTTTTTT",
//                                       oldName: "AAAAAAAAAABBBBBBBBBBCCCCCCCCCCDDDDDDDDDDEEEEEEEEEEFFFFFFFFFFGGGGGGGGGGHHHHHHHHHHIIIIIIIIIIJJJJJJJJJJ")
//        }
//    } catch let e {
//        print("Error: ", e)
//    }
//    let finish = NSDate.init()
//    
//    let startTime = dateFormatter.stringFromDate(start)
//    let finishTime = dateFormatter.stringFromDate(finish)
//    print("Start time: \(startTime)")
//    print("Finish time: \(finishTime)")
//    
//    let diff = finish.timeIntervalSinceDate(start)
//    print("\(diff)")
//    
//    let strRR = "Device Model: \(phoneModel)\n" + "OS Version: \(current_iOS)\n" + "Excution per sec: " + String(format: "%.2f", (Double(dbSize) / diff)) +
//        "\nJournal mode: " + appDelegate.getJournalMode()
//    
//    let alertController = UIAlertController(title: "UPDATE 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
//        print("You have pressed the Cancel button")
//    }
//    alertController.addAction(cancelAction)
//    
//    self.presentViewController(alertController, animated: true, completion: nil)
//}
//
//@IBAction func showDeleteView(sender: UIButton) {
//    let dateFormatter = NSDateFormatter.init()
//    dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
//    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let phoneModel = UIDevice.currentDevice().model
//    let current_iOS = UIDevice.currentDevice().systemVersion
//    
//    let start = NSDate.init()
//    do {
//        for _ in 0..<dbSize {
//            try appDelegate.deleteData()
//        }
//    } catch let e {
//        print("Error: ", e)
//    }
//    let finish = NSDate.init()
//    
//    let startTime = dateFormatter.stringFromDate(start)
//    let finishTime = dateFormatter.stringFromDate(finish)
//    print("Start time: \(startTime)")
//    print("Finish time: \(finishTime)")
//    
//    let diff = finish.timeIntervalSinceDate(start)
//    print("\(diff)")
//    
//    let strRR = "Device Model: \(phoneModel)\n" + "OS Version: \(current_iOS)\n" + "Excution per sec: " + String(format: "%.2f", (Double(dbSize) / diff)) +
//        "\nJournal mode: " + appDelegate.getJournalMode()
//    
//    let alertController = UIAlertController(title: "DELETE 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
//    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
//        print("You have pressed the Cancel button")
//    }
//    alertController.addAction(cancelAction)
//    
//    self.presentViewController(alertController, animated: true, completion: nil)
//}
//    @IBAction func showFwirteView(sender: UIButton) {
//        let dateFormatter = NSDateFormatter.init()
//        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
//
//        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let docDir = paths.objectAtIndex(0)
//        let docFile = docDir.stringByAppendingPathComponent("deck.txt")
//        NSFileManager.defaultManager().createFileAtPath(docFile, contents: nil, attributes: nil)
//        let doc = docFile.cStringUsingEncoding(NSString.defaultCStringEncoding())
//        let fd = open(doc!, O_RDWR)
//
//        let arr1 = [CChar].init(count: ioSizeSeq, repeatedValue: 65)
//
//        let str1 = NSString.init(CString: arr1, encoding: NSASCIIStringEncoding)
//        let myHandle = NSFileHandle.init(fileDescriptor: fd)
//
//        let t2 = NSDate.init()
//        for _ in 0..<fileSize / ioSizeSeq {
//            myHandle.writeData((str1?.dataUsingEncoding(NSUTF8StringEncoding))!)
//        }
//        let t3 = NSDate.init()
//        let diff = t3.timeIntervalSinceDate(t2)
//        print("Sequential write time: \(diff)")
//
//        let strRR = "Sequential write (MB/s): " + String(format: "%.2f", (Double(fileSize)/diff/1048576))
//
//        let alertController = UIAlertController(title: "File I/O 검사 결과", message: strRR, preferredStyle: UIAlertControllerStyle.Alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
//            print("You have pressed the Cancel button")
//        }
//        alertController.addAction(cancelAction)
//
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//
//    @IBAction func showFdeleteView(sender: UIButton) {
//        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let docDir = paths.objectAtIndex(0)
//        let docFile = docDir.stringByAppendingPathComponent("deck.txt")
//
//        do {
//            let fileAttributes: NSDictionary = try NSFileManager.defaultManager().attributesOfItemAtPath(docFile)
//            let fileSizeNumber: NSNumber = fileAttributes.objectForKey(NSFileSize) as! NSNumber
//            let fileSize2 = fileSizeNumber.longLongValue
//
//            print("File size: \(fileSize2)")
//        } catch let e {
//            print(e)
//        }
//
//        do {
//            try NSFileManager.defaultManager().removeItemAtPath(docFile)
//        } catch let e {
//            print(e)
//        }
//
//        let alertController = UIAlertController(title: "File I/O Delete", message: "Remove the file", preferredStyle: UIAlertControllerStyle.Alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction!) in
//            print("You have pressed the Cancel button")
//        }
//        alertController.addAction(cancelAction)
//
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }