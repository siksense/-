//
//  SqliteResultsViewController.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/7/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

class SqliteResultsViewController: UIViewController {
    @IBOutlet weak var insertResult: UILabel!
    @IBOutlet weak var updateResult: UILabel!
    @IBOutlet weak var deleteResult: UILabel!
    
    var receivedInsertResult: String = ""
    var receivedUpdateResult: String = ""
    var receivedDeleteResult: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        insertResult.text = receivedInsertResult
        updateResult.text = receivedUpdateResult
        deleteResult.text = receivedDeleteResult
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
