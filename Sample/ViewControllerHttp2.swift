//
//  ViewControllerHttp2.swift
//  Sample
//
//  Created by hayashi kensuke on 2015/09/07.
//  Copyright (c) 2015年 hayashi kensuke. All rights reserved.
//

import UIKit

class ViewControllerHttp2: UIViewController {
    
    var myTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        // 表示用のTextViewを用意.
        
        myTextView = UITextView(frame: CGRectMake(10, 50, self.view.frame.width - 20, 500))
        myTextView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 1.0)
        myTextView.layer.masksToBounds = true
        myTextView.layer.cornerRadius = 20.0
        myTextView.layer.borderWidth = 1
        myTextView.layer.borderColor = UIColor.blackColor().CGColor
        myTextView.font = UIFont.systemFontOfSize(CGFloat(20))
        myTextView.textColor = UIColor.blackColor()
        myTextView.textAlignment = NSTextAlignment.Left
        myTextView.dataDetectorTypes = UIDataDetectorTypes.All
        myTextView.layer.shadowOpacity = 0.5
        myTextView.layer.masksToBounds = false
        myTextView.editable = false
        self.view.addSubview(myTextView)
        
        // 通信先のURLを生成.
        var myUrl:NSURL = NSURL(string:"http://54.68.143.213/cgi-bin/getTable.cgi?tbl=Language")!
        
        // リクエストを生成.
        var myRequest:NSURLRequest  = NSURLRequest(URL: myUrl)
        
        // 送信処理を始める.
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)
        
    }
    
    func getHttp(res:NSURLResponse?,data:NSData?,error:NSError?){
        
        // 帰ってきたデータを文字列に変換.
        var myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        println(myData)
        
        // TextViewにセット.
        myTextView.text = myData as String
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}