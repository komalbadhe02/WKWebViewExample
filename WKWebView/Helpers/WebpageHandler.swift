///**
/**
WKWebView
WebpageHandler.swift
Created by: KOMAL BADHE on 29/12/18
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation
class WebpageHandler: NSObject {
    
    //Mark: Save page url
    func saveWebpageUrl(webUrl : String)  {
        UserDefaults.standard.set(webUrl , forKey: "Web_url");
        UserDefaults.standard.synchronize();
    }
    
    
    func getWebpageUrl() -> String {
        let webUrl = UserDefaults.standard.object(forKey: "Web_url") as! String;
        
        return webUrl;
    }
    
    func saveApplicationVersion(application_version: String) {
        UserDefaults.standard.set(application_version , forKey: "Application_version");
        UserDefaults.standard.synchronize();
    }
    
    func getApplicationVersion() -> String {
        
        if isKeyPresentInUserDefaults(key: "Application_version") {
            return UserDefaults.standard.object(forKey: "Application_version") as! String;
        }else{
            return "0";
        }
        
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

