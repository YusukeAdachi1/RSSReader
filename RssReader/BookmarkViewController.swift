//
//  BookmarkViewController.swift
//  RssReader
//
//  Created by sonicmoov on 2018/03/20.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BookmarkViewController: UITableViewController {
    
    var bookmarks: Results<Bookmark>?
    var realm: Realm!
    
    //Viewの表示が完了後に呼び出されるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ブックマーク情報取得
        let realm = try! Realm()
        bookmarks = realm.objects(Bookmark.self).sorted(byKeyPath: "date", ascending: false)
        
        //ナビゲーションバーの右側に編集ボタンを追加[問題2]
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.reloadData()
    }
    
    //セルの個数を指定する
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks?.count ?? 0
    }
    
    //セル値を設定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkViewCell", for: indexPath)
        guard let bm = bookmarks?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = bm.title
        return cell
    }
    
    //一覧からWebView画面へ行く時に呼び出されるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            guard let bm = bookmarks?[indexPath.row] else {
                return
            }
            let item = Item()
            item.link = bm.link
            item.title = bm.title
            item.detail = bm.detail
            
            let controller = segue.destination as! DetailViewController
            controller.item = item
        }
    }
    
    
    //[問題2]
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            //deleteボタンを押した時にログに「削除」を表示
            print("削除")
            
            //??????????????????????????????
            guard let bm = bookmarks?[indexPath.row] else {
                return
            }
            
            //realmのオブジェクトの削除 トランザクションの中でdeleteメソッドを使用
            let realm = try! Realm()
            try! realm.write {
                realm.delete(bm)
            }
            
            // TableViewを再読み込み.
            tableView.reloadData()
        }
    }
    
    
    
}
