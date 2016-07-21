//
//  DetectJailbreak.swift
//  JailbreakDetection
//
//  Created by Keaton Burleson on 7/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//
// WARNING this does NOT comply with Apple's iOS application standard, and it will not get approved.
import Foundation
import UIKit
class Detector: NSObject{
    let application = UIApplication.shared()
    let url = URL(string: "cydia://")
    var delegate: DetectorDelegate?
    
    func urlCheck() -> (Bool){
        return application.canOpenURL((url)!)
    }
    func appCheck() -> (Bool){
        do {
        for app in try FileManager.default().contentsOfDirectory(atPath: "/Applications"){
            if app.contains("Cydia"){
                return true
            }
        }
        
        }catch{
            return false
        }
        return false
    }
    
    func mobileSubstrateTest() -> (Bool){
        do{
        for app in try FileManager.default().contentsOfDirectory(atPath: "/Library"){
            if app.contains("MobileSubstrate"){
                return true
            }
        }
        }catch{
            return false
        }
        return false

    }
    func flipswitchTest() -> (Bool){
        do{
        for app in try FileManager.default().contentsOfDirectory(atPath: "/Library"){
            if app.contains("Flipswitch"){
                return true
            }
        }
        }catch{
            return false
        }
        return false
        
    }
 
    func allTests(){
        var failedTests = [String]()
        
        if urlCheck() == true{
            failedTests.append("URL Test")
        }
       // self.installOpenSSH()
        if appCheck() == true{
            failedTests.append("App Test")
        }
        if mobileSubstrateTest() == true{
            failedTests.append("Mobile Substrate Test")
        }
        if flipswitchTest() == true{
            failedTests.append("Flipswitch Test")
        }
        
        if failedTests.count != 0{
            self.delegate?.notifyJailbroken(isJailbroken: true, testsFailed: failedTests)
        }else{
            self.delegate?.notifyJailbroken(isJailbroken: false, testsFailed: [])
        }
    }
    
}
protocol DetectorDelegate {
    func notifyJailbroken(isJailbroken: Bool, testsFailed: [String])
    
}

