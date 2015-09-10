//
//  ViewControllerHttp3.swift
//  Sample
//
//  Created by hayashi kensuke on 2015/09/07.
//  Copyright (c) 2015年 hayashi kensuke. All rights reserved.
//

import UIKit

class ViewControllerHttp3: UIViewController, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var fileName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0;
    }
    
    @IBAction func tappedStartSession(sender: AnyObject) {
        self.downloadWithFile()
    }
    
    func downloadWithFile() {
        var accessUrl: String = "http://54.68.143.213/CaviNet/Lan001/Voice/Loc031.ogg" // アクセス先のURL
        // ファイル名を取り出す
        var pos = (accessUrl as NSString).rangeOfString("/", options:NSStringCompareOptions.BackwardsSearch).location
        fileName = accessUrl.substringFromIndex(advance(accessUrl.startIndex, pos+1))
        println(fileName)
        
        // NSURLSessionの準備
        let url = NSURL(string: accessUrl)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config,
            delegate: self,
            delegateQueue: NSOperationQueue.mainQueue())
        
        let task = session.downloadTaskWithURL(url!)
        
        task.resume()
    }
    
    // 通信の最初に呼ばれる
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        println("start")
    }
    
    // 通信中に呼ばれる（プログレスバーの更新）
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        println(progressView.progress)
        //println("write:\(bytesWritten) / \(totalBytesWritten) -> \(totalBytesExpectedToWrite)")
    }
    
    // 通信終了時に呼ばれる
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        progressView.progress = 1.0
        
        var fileData = NSData(contentsOfURL: location)
        
        if fileData?.length == 0 {
            NSLog("Error")
        } else {
            NSLog("Success")
            /*let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(fileData, forKey: "downloaded")
            userDefaults.synchronize()*/
            
            /*let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as NSURL
            let destinationUrl = documentsUrl.URLByAppendingPathComponent(location.lastPathComponent!)
            if fileData.writeToURL(destinationURL, atomically: true) {
                println("file saved")
            } else {
                println("error saving file")
            }*/
            
            // ドキュメントのパス
            //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            // ライブラリのパス
            let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String
            
            let languagePath = libraryPath + "/LanguageFiles"
            
            // ディレクトリの生成
            if (NSFileManager.defaultManager().fileExistsAtPath(languagePath)) {
                println("fileExists")
            } else {
                NSFileManager.defaultManager().createDirectoryAtPath(languagePath, withIntermediateDirectories: true, attributes: nil, error: nil)
                println("fineNotExists")
            }
            
            fileData?.writeToFile("\(languagePath)/\(fileName)", atomically: false) // ファイル書き込み

            println(location)
        }
        
        session.invalidateAndCancel()
        println("finish")
    }
}
