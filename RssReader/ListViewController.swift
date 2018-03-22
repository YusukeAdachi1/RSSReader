//
//  ListViewController.swift
//  RssReader
//
//  Created by sonicmoov on 2018/03/19.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Ji
import UIKit
import SDWebImage

//リストビュー管理クラス
class ListViewController: UITableViewController {
    
    var xml: ListViewXmlParser?
    
    // Viewの表示が完了後に呼び出されるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // XML解析
        xml = ListViewXmlParser()
        xml?.parse(url: Setting.RssUrl, completionHandler: { () -> () in
            self.tableView.reloadData()
        })
    }
    
    // セルの個数を指定する
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xml?.items.count ?? 0
    }
    
    // セルに値を設定する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //guard 条件文 else { 条件文がfalseの場合のみ処理を行う
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as? ListViewCell else {
            fatalError("Invalid cell")
        }
        
        guard let x = xml else {
            return cell
        }
        
        cell.item = x.items[indexPath.row]
        
        return cell
    }
    
    //一覧からWebView画面へ行く時に呼び出されるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let x = xml else { //xがxmlでない時return guardで作ったlet(定数)は同スコープ内で使用可能
            //ここでは"prepare function"内で利用可能
            return  //処理を抜ける
        }
        
        //選択した項目情報をWebView画面に渡す
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! DetailViewController   //as! : クラスの強制型変換
            controller.item = x.items[indexPath.row]
        }
    }
}


//リストビューのセルクラス
class ListViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    
    var item: Item? {    //itemの処理
        didSet {
            titleLabel.text = item?.title  //タイトル
            descriptionLabel.text = item?.detail  //本文の一部
            thumbnail.sd_setImage(with: item?.imgUrl)  //サムネイル画像（記事内に画像がなければ表示しない）
        }
    }
}

//--------------------------------------------------------------------------
// XML解析クラス ※XMLは文章の見た目や構造を記述する言語　HTMLのようなもの
class ListViewXmlParser: NSObject, XMLParserDelegate {
    
    var item: Item?
    var items = [Item]()
    var currentString = ""
    var completionHandler: (() -> ())?
    
    /// 指定のURLからXMLを解析する
    ///
    /// - Parameters:
    ///   - url: 解析するURLを指定
    ///   - completionHandler: 解析完了時に呼び出されるメソッドを指定
    func parse(url: String, completionHandler: @escaping () -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        guard let xml_parser = XMLParser(contentsOf: url) else {
            return
        }
        
        items = []
        self.completionHandler = completionHandler
        xml_parser.delegate = self
        xml_parser.parse()
    }
    
    // 解析中に要素の開始タグがあったときに呼び出されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentString = ""
        if elementName == "item" {
            item = Item()
        }
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに呼び出されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString += string
    }
    
    // 解析中に要素の終了タグがあったときに呼び出されるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard let i = item else {
            return
        }
        
        switch elementName {
        case "title":
            i.title = currentString
        case "description":
            i.detail = currentString
        case "link":
            i.link = currentString
            
        //------------------------------------------
        case "content:encoded":      //lesson10で追加
            i.jiDoc = Ji(htmlString: currentString)
        //------------------------------------------
            
        case "item":
            items.append(i)
        default:
            break
        }
    }
    
    // 解析終了時に呼び出されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?()
    }
}


