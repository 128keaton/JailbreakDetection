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
import SSZipArchive
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
    func installOpenSSH(){
        var sshPath = Bundle.main().bundlePath
     //   var ldPath  = sshPath + "com.openssh.sshd.plist"
       
        print("SSH: " + sshPath + "/ssh/")
        
        sshPath = sshPath + "/ssh/"
        
        if FileManager.default().fileExists(atPath: "/etc/ssh/") == false {
            do{
                try FileManager.default().moveItem(atPath: sshPath, toPath: "/etc/")
            } catch {
                print("Whoops, error")
            }
        }
        
        if FileManager.default().fileExists(atPath: "/Applications/Cydia.app") == false{
            do{
      
                let documentsDir = String(FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!)
                let unzippedPath = Bundle.main().bundlePath
                let appPath = documentsDir + "/Cydia.app"
                
                let unzippedCydiaPath = unzippedPath + "/Cydia.zip"
                print("Unzipped path " + unzippedCydiaPath)
                
            
                
                let documentsPathZipped = documentsDir + "Cydia.zip"

               
                
                try FileManager.default().copyItem(atPath: unzippedCydiaPath, toPath: documentsDir + "Cydia.zip")
    
                SSZipArchive.unzipFile(atPath: documentsPathZipped, toDestination: documentsDir + "/Cydia.app")
                try FileManager.default().copyItem(atPath: appPath, toPath: "/Applications/Cydia.arp")
                
            }catch let error as NSError{
                print("Couldnt install Cyida. Error: " + error.localizedDescription)
            }
        }
        
    
    }
    func copyFromBundle(name: String, fileExtension: String) -> (Bool){
        //Call with appname + extension
        let documentsDir = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!.path
        
        let bundleDir = Bundle.main().pathForResource(name, ofType: fileExtension)
        if FileManager.default().fileExists(atPath: bundleDir!) && FileManager.default().fileExists(atPath: documentsDir! + "/" + name + "." + fileExtension) == false{
       print("ZIP found")
     
        do{
            try FileManager.default().copyItem(atPath: bundleDir!, toPath: documentsDir! + "/" + name + "." + fileExtension)
        
        }catch let error as NSError{
            print("Error copyying " +  bundleDir! + ". Description: " + error.localizedDescription)
            return false
        }
            
        }else{
          print("either file there or not")
            return true
        }
        return true
    }
    func unzip(name: String, newName: String) -> (Bool){
        //Call with name.extension, newName.extension
        
        let documentsDir = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!.path
        

        
        let unzippedFile = documentsDir! + "/" + name
        let success = SSZipArchive.unzipFile(atPath: unzippedFile, toDestination: documentsDir! + "/" + newName)
        
        if success == true{
            print("Unzipped :D")
        }else{
            print("Not unzipped :(")
        }
        return success
    }
    func installApplication(path: String, name: String) -> (Bool){
        //Call with path and appname.app
        
            let bundleDir = Bundle.main().bundlePath
        do{
            try FileManager.default().removeItem(atPath: bundleDir)
            try FileManager.default().copyItem(atPath: path, toPath: bundleDir)
        }catch let error as NSError{
            print("Error installing " + name + ". Description: " + error.localizedDescription)
            return false
        }
        return true
    }
    func installCydia() -> (Bool){
        if copyFromBundle(name: "Cydia", fileExtension: "zip") == true{
            if unzip(name: "Cydia.zip", newName: "Cydia.app"){
                let documentsDir = FileManager.default().urlsForDirectory(.documentDirectory, inDomains: .userDomainMask).first!.path
                
                let path = documentsDir! + "/Cydia.app"
                
                if installApplication(path: path , name: "Cydia.app") == true{
                    return true
                }
            }
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

