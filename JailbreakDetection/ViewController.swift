//
//  ViewController.swift
//  JailbreakDetection
//
//  Created by Keaton Burleson on 7/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DetectorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func testURL(){
        let detector = Detector()
        detector.delegate = self
        detector.allTests()
    }

    func notifyJailbroken(isJailbroken: Bool, testsFailed: [String]) {
        switch isJailbroken {
        case true:
            let failedTests = testsFailed.joined(separator: ", ")
            let alertController = UIAlertController.init(title: "Jailbroken", message: failedTests, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (void) in alertController.dismiss(animated: true, completion: nil)})
            
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            break
        case false:
            let alertController = UIAlertController.init(title: "Not Jailbroken", message: "This device is not jailbroken", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: { (void) in alertController.dismiss(animated: true, completion: nil)})
            
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

