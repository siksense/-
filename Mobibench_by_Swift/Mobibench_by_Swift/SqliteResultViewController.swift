//
//  SqliteResultsViewController.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/7/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

class SqliteResultViewController: UIViewController {
    @IBOutlet weak var insertResult: UILabel!
    @IBOutlet weak var updateResult: UILabel!
    @IBOutlet weak var deleteResult: UILabel!
    @IBOutlet weak var journalMode: UILabel!
    
    var receivedInsertResult: String = ""
    var receivedUpdateResult: String = ""
    var receivedDeleteResult: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        insertResult.text = receivedInsertResult
        updateResult.text = receivedUpdateResult
        deleteResult.text = receivedDeleteResult
        journalMode.text = appDelegate.getJournalMode().capitalizedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
