///**
/**
WKWebView
AppDelegate.swift
Created by: KOMAL BADHE on 29/12/18
Copyright (c) 2019 KOMAL BADHE
*/

import UIKit
import WebKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SirenDelegate {
    
    var window: UIWindow?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        
        setStatusBarBackgroundColor(color: UIColor.black);
        setupSiren();
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Siren.shared.checkVersion(checkType: .immediately)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.shared.checkVersion(checkType: .daily)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //        if #available(iOS 9.0, *) {
        //            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        //            let date = NSDate(timeIntervalSince1970: 0)
        //            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        //        }
        //        else
        //        {
        //            URLCache.shared.removeAllCachedResponses()
        //        }
        
    }
    
    
    func setupSiren() {
        let siren = Siren.shared
        
        // Optional
        siren.delegate = self ;
        
        // Optional
        siren.debugEnabled = true
        
        siren.majorUpdateAlertType = .force
        siren.minorUpdateAlertType = .force
        siren.patchUpdateAlertType = .force
        siren.revisionUpdateAlertType = .force
        
    }
    
}

