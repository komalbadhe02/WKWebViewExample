///**
/**
WKWebView
CommonUtils.swift
Created by: KOMAL BADHE on 29/12/18
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation
import UIKit
import SystemConfiguration
//Set status bar color
func setStatusBarBackgroundColor(color: UIColor) {
    guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBar.backgroundColor = color
}

//Mark: Check internet connection
func isConnectedToNetwork() -> Bool
{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}
