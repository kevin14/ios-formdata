//
//  FormData.swift
//  FormData
//
//  Created by kevin14 on 15/4/9.
//  Copyright (c) 2015年 kevin14. All rights reserved.
//

import Foundation
import MobileCoreServices

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

class FormData{

    private var request:NSMutableURLRequest!
    private var boundaryConstant:NSString!
    private var body:NSMutableData = NSMutableData()
    private var error:NSError?
    
    init(url : NSURL , cachePolicy: NSURLRequestCachePolicy , timeoutInterval: NSTimeInterval,method:String = "POST"){
        request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.HTTPMethod = method
        initRequestData()
    }
    
    init(url:NSURL,method:String = "POST"){
        request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 2.0)
        request.HTTPMethod = method
        initRequestData()
    }
    
    private func initRequestData(){
        boundaryConstant = generateBoundaryString()
        let contentType:NSString = "multipart/form-data; boundary=\(boundaryConstant)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func append(#key:String,value:String){
        body.appendString("--\(boundaryConstant)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString("\(value)\r\n")
    }
    
    func appendFile(#key:String,filePath:NSURL!){
        if let data = NSData(contentsOfFile: filePath.path!){
            let filename = filePath.lastPathComponent!
            let mimetype = mimeTypeForPath(filePath.path!)
            appendData(key: key, data: data, filename: filename, mimetype: mimetype)
        }
    }
    
    func appendData(#key:String,data:NSData!,filename:String,mimetype:String){
        body.appendString("--\(boundaryConstant)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(key)\";filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(data)
        body.appendString("\r\n")
    }
    
    private func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as NSString
            }
        }
        return "application/octet-stream";
    }
    
    func send(callback:((response:NSURLResponse! , dataObject:NSData!, error:NSError!) -> Void)){
        body.appendString("--\(boundaryConstant)--")
        request.HTTPBody = body
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response,dataObject,error) in
            callback(response: response, dataObject: dataObject, error: error)
        })
    }
    
}