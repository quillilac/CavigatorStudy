//
//  ViewControllerA.swift
//  Sample
//
//  Created by hayashi kensuke on 2015/09/07.
//  Copyright (c) 2015年 hayashi kensuke. All rights reserved.
//

import UIKit

class ViewControllerA: UIViewController {
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBAction func tapHandler(sender: AnyObject) {
        myTextField.text = "Hello World"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blueColor()
    }
}
