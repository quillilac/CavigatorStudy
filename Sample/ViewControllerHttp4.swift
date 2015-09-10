import UIKit

class ViewControllerHttp4: UIViewController, NSURLSessionDownloadDelegate {
    
    var progressView: UIProgressView!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Progressバー
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressView.layer.position = CGPoint(x: self.view.frame.width/2, y: 400)
        progressView.progress = 0.0
        self.view.addSubview(progressView)
        
        // ラベル
        label = UILabel(frame: CGRectMake(0, 0, 200, 150))
        label.text = "0%"
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPoint(x: self.view.frame.width/2, y: 450)
        
        self.view.addSubview(label)
        
        // 通信のコンフィグ
        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // Sessionを作成
        let session: NSURLSession = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // ダウンロードURLからリクエストを生成
        let url: NSURL = NSURL(string: "http://54.68.143.213/CaviNet/Lan001/Voice/Loc032.ogg")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        // ダウンロードタスクを生成
        let downloadTask: NSURLSessionDownloadTask = session.downloadTaskWithRequest(request)
        
        // タスクを実行
        downloadTask.resume()
    }
    
    // ダウンロード終了時に呼び出されるデリゲート
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
    }
    
    // ダウンロードの開始時に呼び出されるデリゲート
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        progressView.progress = 0
    }
    
    // タスク処理中に定期的に呼び出されるデリゲート
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        var per: Float = Float(totalBytesWritten/totalBytesExpectedToWrite)
        progressView.setProgress(per, animated: true)
        println(progressView.progress)
        
        label.text = "\((Int)(progressView.progress * 100))%"
    }
    
    // タスク終了時に呼び出されるデリゲート
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error == nil {
            println("ダウンロード完了")
        } else {
            println("ダウンロード失敗")
        }
        progressView.setProgress(1.0, animated: true)
        label.text = "100%"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}