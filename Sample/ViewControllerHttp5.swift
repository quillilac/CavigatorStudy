//
//  ViewControllerHttp3.swift
//  Sample
//
//  Created by hayashi kensuke on 2015/09/07.
//  Copyright (c) 2015年 hayashi kensuke. All rights reserved.
//

import UIKit

class ViewControllerHttp5: UIViewController, NSURLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    private var tableView: UITableView  =   UITableView()
    private var fileName: String!
    private var downloadPhase: Int!
    private var splitStringMatrix: [[String]] = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // ボタン生成
        let downloadButton = UIButton()
        downloadButton.setTitle("Download", forState: .Normal)
        downloadButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        downloadButton.frame = CGRectMake(0, 0, 100, 50)
        downloadButton.layer.position = CGPoint(x: self.view.frame.width/2, y:100)
        downloadButton.backgroundColor = UIColor(red: 0.7, green: 0.2, blue: 0.7, alpha: 1.0)
        downloadButton.setTitle("Download", forState: .Highlighted)
        downloadButton.setTitleColor(UIColor(red: 0.5, green: 0.1, blue: 0.5, alpha: 0.7), forState: .Highlighted)
        downloadButton.addTarget(self, action: Selector("downloadWithFile"), forControlEvents: .TouchUpInside)
        self.view.addSubview(downloadButton)
        
        // ダウンロードフェーズの初期化
        downloadPhase = 0

    }
    
    // ボタンクリック時に呼ばれる
    @IBAction func tappedStartSession(sender: AnyObject) {
        self.downloadWithFile()
    }
    
/********** ファイルダウンロード **********/
    func downloadWithFile() {
        var accessUrl: String = "http://54.68.143.213/cgi-bin/getTable.cgi?tbl=Language" // アクセス先のURL
        createDownloadTask(accessUrl)
    }
    
    // ダウンロードタスクを生成する関数
    func createDownloadTask(accessUrl: String) {
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
        //progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        //println(progressView.progress)
        //println("write:\(bytesWritten) / \(totalBytesWritten) -> \(totalBytesExpectedToWrite)")
    }
    
    // 通信終了時に呼ばれる
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        //progressView.progress = 1.0
        
        var fileData = NSData(contentsOfURL: location)
        
        if fileData?.length == 0 {
            NSLog("Error")
        } else {
            NSLog("Success")
            
            // ドキュメントのパス
            //let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            // ライブラリのパス
            let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String
            
            // ファイルの保存先
            var fileSaveDirPath = libraryPath + "/LanguageFiles"
            /*switch downloadPhase {
            case 0:
                fileSaveDirPath = libraryPath + "/"
            }*/
            
            
            
            if (downloadPhase == 0) {
                // Preferenceに保存する
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(fileData, forKey: "LanguageList")
                userDefaults.synchronize()
                // Preferenceからの読み出し
                var nsData: NSData = userDefaults.dataForKey("LanguageList")!
                var str = NSString(data: nsData, encoding:NSUTF8StringEncoding) as String
                println(str)
                // 読みだしたファイルを多次元配列に格納
                var lineIndex: Int = 0;
                str.enumerateLines { line, stop in
                
                    // ここに1行ずつ行いたい処理を書く
                    if (lineIndex >= 3) {
                        var splitString = split(line, { $0 == "," })
                        self.splitStringMatrix.append(splitString)
                    }
                    //println("\(lineIndex) : \(line)")
                    lineIndex += 1
                }
            
                var i: Int;
                for (i = 0; i < splitStringMatrix.count; i++) {
                    println(splitStringMatrix[i][1])
                }
            
                // リスト形式で言語一覧を表示
                createTableView()
                
                createDownloadTask("http://54.68.143.213/CaviNet/Lan001/Voice/Loc007.ogg")
            } else if (downloadPhase == 1) {
                // ディレクトリの生成
                if (NSFileManager.defaultManager().fileExistsAtPath(fileSaveDirPath)) {
                    println("fileExists")
                } else {
                    NSFileManager.defaultManager().createDirectoryAtPath(fileSaveDirPath, withIntermediateDirectories: true, attributes: nil, error: nil)
                    addSkipBackupAttributeToItemAtURL(NSURL(string: fileSaveDirPath)!)
                    println("fineNotExists")
                }
                
                fileData?.writeToFile("\(fileSaveDirPath)/\(fileName)", atomically: false) // ファイル書き込み
            }
            
            downloadPhase! += 1 // downloadPhaseを次に進める
            
            //println(location)
        }
        
        session.invalidateAndCancel()
        println("finish")
    }
    
    // do not backup attribute 付与
    func addSkipBackupAttributeToItemAtURL(URL:NSURL) ->Bool{
        
        let fileManager = NSFileManager.defaultManager()
        assert(fileManager.fileExistsAtPath(URL.path!))
        
        var error:NSError?
        let success:Bool = URL.setResourceValue(NSNumber(bool: true),forKey: NSURLIsExcludedFromBackupKey, error: &error)
        
        if !success{
            println("Error excluding \(URL.lastPathComponent) from backup \(error)")
        }
        
        println(success)
        return success;
    }
    
/********** テーブルリストに関する処理 **********/
    func createTableView() {
        //テーブルビュー初期化、関連付け
        tableView.frame         =   CGRectMake(0, 150, self.view.bounds.width, self.view.bounds.height - 150);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.splitStringMatrix.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = self.splitStringMatrix[indexPath.row][1]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("セルを選択しました！ #\(indexPath.row)!")
    }
}
