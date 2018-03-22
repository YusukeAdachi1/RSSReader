//
//  Item.swift
//  RssReader
//
//  Created by sonicmoov on 2018/03/19.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Ji //Item.swiftを開くとエラー出る(謎)
import SDWebImage

//Item（記事それぞれ）のクラス
class Item {
    var title = ""
    var detail = ""
    var link = ""
    
    var imgUrl: URL?
    
    var jiDoc : Ji? = nil {
        didSet {
            if let img = jiDoc?.xPath("//img[@class='entry-image']")?.first {
                imgUrl = URL(string: img["src"]!)
            } else {
                imgUrl = nil
            }
        }
    }
}
