//
//  FileIOResultViewController.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/10/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

class FileIOResultViewController: UIViewController {
    @IBOutlet weak var sequentialResult: UILabel!
    @IBOutlet weak var randomResult: UILabel!
    
    var receivedSequentialResult: String = ""
    var receivedRandomResult: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sequentialResult.text = receivedSequentialResult
        randomResult.text = receivedRandomResult
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
