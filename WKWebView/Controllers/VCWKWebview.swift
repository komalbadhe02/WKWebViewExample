///**
/**
WKWebView
VCWKWebview.swift
Created by: KOMAL BADHE on 31/12/18
Copyright (c) 2019 KOMAL BADHE
*/

import UIKit
import WebKit
class VCWKWebview: UIViewController,WKNavigationDelegate,UIScrollViewDelegate,WKUIDelegate {
    var application_version = String();
    
    @IBOutlet var noInternetConnectionView: UIView!
    @IBOutlet weak var splashScreen: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get_application_version();
        
        // Do any additional setup after loading the view.
        
        self.webView.reloadFromOrigin()
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(removeSP), userInfo: nil, repeats: false)
        
        let stringurl = "https://www.google.com/";
       
        let url = URL(string: stringurl)
        var theRequest: NSMutableURLRequest? = nil
        
        webView.allowsBackForwardNavigationGestures = false;
        webView.scrollView.bounces = false;
        webView.scrollView.showsHorizontalScrollIndicator = false;
        webView.scrollView.showsVerticalScrollIndicator = false;
        webView.contentMode = .scaleToFill
        webView.navigationDelegate = self;
        webView.uiDelegate = self;
        if isConnectedToNetwork() {
            if let anUrl = url {
                theRequest = NSMutableURLRequest(url: anUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15.0)
            }
            if let aRequest = theRequest {
                webView.load(aRequest as URLRequest);
            }
            
        }
        else{
            WebpageHandler().saveWebpageUrl(webUrl: stringurl);
            showAlertOfNoInternet();
        }
        
    }
    
    
    @objc func removeSP()  {
        self.splashScreen.removeFromSuperview()
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }
        else{
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        
        let clickedUrl : String = (webView.url?.absoluteString)!
        
        if isConnectedToNetwork(){
            progressBar.startAnimating();
            get_application_version();
        }
        else{
            WebpageHandler().saveWebpageUrl(webUrl:clickedUrl);
            showAlertOfNoInternet();
        }
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';", completionHandler: nil);
        
        progressBar.stopAnimating();
        
        
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    //function for no internet connection
    
    func showAlertOfNoInternet()  {
        
        noInternetConnectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.size.height);
        noInternetConnectionView.backgroundColor = UIColor.white;
        self.view.addSubview(noInternetConnectionView);
        
    }
    
    @IBAction func tryAgainButton(_ sender: Any) {
        
        if isConnectedToNetwork() {
            
            let stringurl = WebpageHandler().getWebpageUrl();
            let url = URL(string: stringurl)
            var theRequest: NSMutableURLRequest? = nil
            if let anUrl = url {
                theRequest = NSMutableURLRequest(url: anUrl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15.0)
            }
            if let aRequest = theRequest {
                //webView.load(URLRequest(url: url))
                webView.load(aRequest as URLRequest);
            }
            
            noInternetConnectionView.removeFromSuperview();
        }
        else{
            
        }
        
    }
    
    @objc func get_application_version() {
        
        
        let soapObject = SoapClient();
        soapObject.initialize(method: "get_application_version");
        //soapObject.initialize(method: "getWebViewUrl");
        
        soapObject.completion = {
            (obj : Any) -> Void in
            DispatchQueue.main.async {
                if let dictObj : NSDictionary = obj as? NSDictionary{
                    self.application_version = dictObj.value(forKey: "version_no") as! String;
                    
                    let previous_version = WebpageHandler().getApplicationVersion();
                    print( self.application_version);
                    if previous_version != self.application_version{
                        WebpageHandler().saveApplicationVersion(application_version: self.application_version);
                        URLCache.shared.removeAllCachedResponses();
                        self.webView.evaluateJavaScript("localStorage.clear();", completionHandler: nil);
                        if #available(iOS 9.0, *) {
                            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
                            let date = NSDate(timeIntervalSince1970: 0)
                            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
                        }
                        else
                        {
                            URLCache.shared.removeAllCachedResponses()
                        }
                    }
                    
                }
            }
            do {
                _ = try JSONSerialization.data(withJSONObject:obj, options: .prettyPrinted)
            } catch{
            }
        }
        soapObject.makeRequest();
    }
    
}
