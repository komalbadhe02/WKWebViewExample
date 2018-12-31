///**
/**
WKWebView
SoapClient.swift
Created by: KOMAL BADHE on 29/12/18
Copyright (c) 2019 KOMAL BADHE
*/

import Foundation
class SoapClient:NSObject,XMLParserDelegate{
    @objc var methodName = String();
    @objc var dicProperties = NSMutableDictionary();
    @objc var completion : ((Any) -> Void)?
    @objc var response = String();
    @objc let hostName = "";
    @objc  let serviceUrl = "";
    // @objc let hostName = "";
    // @objc  let serviceUrl = "";
    
    //INITIALIZE SOAP CLIENT OBJECT
    @objc func initialize(method:String){
        methodName = method;
        dicProperties = NSMutableDictionary();
    }
    //ADD PROPERTIES TO THE REQUEST
    @objc func addProperty(value:Any,key:String){
        dicProperties.setValue(value, forKey: key)
    }
    
    //MAKE REQUEST FOR THE SERVICE
    @objc public func makeRequest(){
        var propertyString = "";
        for(key,value) in dicProperties{
            propertyString += "<" + (key as! String) + ">" + (value as! String) + "</" + (key as! String) + ">";
        }
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
            + "<soap:Body>\n"         + " <" + methodName + " xmlns=\"http://tempuri.org/\">\n"
            + ""
            + "</" + methodName + ">\n"
            + "</soap:Body>\n"
            + "</soap:Envelope>\n";
        
        let urlString = "mobileupdate?wsdl"
        
        let url = URL(string: urlString)
        
        var theRequest = URLRequest(url: url!)
        
        let msgLength = soapMessage.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let task = URLSession.shared.dataTask(with: theRequest) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    
                    return
                }
                guard let data = data else {
                    return
                }
                
                var parser = XMLParser();
                parser = XMLParser(data:data);
                parser.delegate = self
                parser.parse();
            }
        }
        task.resume();
        
    }
    //XML PARSING METHODS
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes dicAttibutes: [String:String])
    {
        
        if (elementName as NSString).isEqual(to: "return"){
            response = "";
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        response += string;
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "return"){
            if let data = response.data(using: .utf8) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: [])
                    self.completion!(parsedData);
                } catch {
                    //print(error.localizedDescription)
                }
            }
        }
    }
}
