import UIKit

class ViewControllerHttp6: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    //テーブルビューインスタンス作成
    var tableView: UITableView  =   UITableView()
    
    //テーブルに表示するセル配列
    var items: [String] = ["Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman", "Swift-Salaryman", "Manga-Salaryman", "Design-Salaryman"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //テーブルビュー初期化、関連付け
        tableView.frame         =   CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("セルを選択しました！ #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
};