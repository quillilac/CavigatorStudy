//
//  ViewControllerHttp.swift
//  Sample
//
//  Created by hayashi kensuke on 2015/09/07.
//  Copyright (c) 2015年 hayashi kensuke. All rights reserved.
//

import UIKit

class ViewControllerHttp: UIViewController, UITextFieldDelegate {
    
    let URL_TEST = "http://54.68.143.213/CaviNet/Lan001/Text/Pag001.txt"
    let BTN_READ = 0
    
    var _textField: UITextField?
    var _indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dx: CGFloat = (UIScreen.mainScreen().bounds.size.width-320)/2
        
        _textField = makeTextField(CGRectMake(dx+10, 20, 300, 32), text: "")
        self.view.addSubview(_textField!)
        
        let btnRead = makeButton(CGRectMake(dx+110, 62, 100, 40), text: "読み込み", tag: BTN_READ)
        self.view.addSubview(btnRead)
        
        _indicator = UIActivityIndicatorView()
        _indicator!.frame = CGRectMake(dx+140, 140, 40, 40)
        _indicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        _indicator!.hidesWhenStopped = true
        self.view.addSubview(_indicator!)
    }
    
    func makeTextField(frame: CGRect, text: String) -> UITextField {
        let textField = UITextField()
        textField.frame = frame
        textField.text = text
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.keyboardType = UIKeyboardType.Default
        textField.returnKeyType = UIReturnKeyType.Done
        textField.delegate = self
        return textField
    }
    
    func makeButton(frame: CGRect, text: NSString, tag: Int) -> UIButton {
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame
        button.setTitle(text, forState: UIControlState.Normal)
        button.tag = tag
        button.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    func onClick(sender: UIButton) {
        if sender.tag == BTN_READ {
            http2data(URL_TEST)
        }
    }
    
    func data2str(data: NSData) -> NSString {
        return NSString(data: data, encoding: NSUTF8StringEncoding)!
    }
    
    func http2data(url: String) {
        _indicator?.startAnimating()
        
        let URL = NSURL(string: url)
        let request = NSURLRequest(URL: URL!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: self.fetchResponse)
    }
    
    func fetchResponse(res: NSURLResponse!, data: NSData!, error:NSError!) {
        if error == nil {
            _textField!.text = data2str(data)
        } else {
            _textField!.text = "通信エラー"
        }
        
        _indicator?.stopAnimating()
    }
}
