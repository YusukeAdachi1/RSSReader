//
//  DetailViewController.swift
//  RssReader
//
//  Created by sonicmoov on 2018/03/19.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RealmSwift

//WebView(Webで記事を見る)画面用のクラス
class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!  //WebView画面接続
    var item: Item?
    
    // loadView()が完了した際に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let i = item else {
            return
        }
        
        if let url = URL(string: i.link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    //    @IBAction func addBookmark(_ sender: AnyObject) {
    //    }
    //ブックマークボタンを押した時に呼ばれるメソッド
    //Type Swift3:AnyObject Swift4:Any
    @IBAction func addBookmark(_ sender: Any) {
        
        //コントローラの実装
        let alertController = UIAlertController(title: "確認",message: "ブックマークに追加しますか", preferredStyle: UIAlertControllerStyle.alert)
        
        //OKボタンの実装　OKボタンを押したらブックマークに記事を追加
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (action: UIAlertAction) in
            
            //Reference to property 'item' in closure requires explict 'self.' to make capture semantics explicit
            guard let i = self.item else {
                return
            }
        
            let bookmark = Bookmark()
            bookmark.title = i.title
            bookmark.detail = i.detail
            bookmark.link = i.link
            bookmark.date = NSDate()
        
            //realmに情報を[追加] 例外が発生しても強制処理
            let realm = try! Realm()
            try! realm.write {
                realm.add(bookmark)
            }
        }
        
        let CancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        
        //okボタンの追加
        alertController.addAction(OkAction)
        //cancelボタンの追加
        alertController.addAction(CancelAction)
        
        //アラートの表示
        present(alertController,animated: true,completion:nil)
    }
}
