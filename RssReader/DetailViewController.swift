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
        

    @IBAction func addStudy(_ sender: Any) {
        
        let alert = UIAlertController(title: "アラート表示", message: "どのブックマークに保存しますか？", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let Action1: UIAlertAction = UIAlertAction(title: "Favorites", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("addFavorites")
            
                guard let i = self.item else {
                    return
                }
        
                let studybookmark = StudyBookmark()
                studybookmark.title = i.title
                studybookmark.detail = i.detail
                studybookmark.link = i.link
                studybookmark.date = NSDate()
                
                //realmに情報を[追加] 例外が発生しても強制処理
                let realm = try! Realm()
                try! realm.write {
                    realm.add(studybookmark)
                }
        })
        
        
        let Action2: UIAlertAction = UIAlertAction(title: "Bookmarks", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("addBookmarks")

                guard let j = self.item else {
                    return
                }
            
                let interestbookmark = InterestBookmark()
                interestbookmark.title = j.title
                interestbookmark.detail = j.detail
                interestbookmark.link = j.link
                interestbookmark.date = NSDate()
            
                //realmに情報を[追加] 例外が発生しても強制処理
                let realm = try! Realm()
                try! realm.write {
                    realm.add(interestbookmark)
                }
        })


        let CancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
        })

        alert.addAction(Action1)
        alert.addAction(Action2)
        alert.addAction(CancelAction)

        present(alert, animated: true, completion: nil)
    }
}
