//
//  BookmarkRename.swift
//  RssReader
//
//  Created by sonicmoov on 2018/03/22.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import UIKit

class BookmarkRenameViewController: UIViewController {
    
    @IBOutlet weak var Subject1: UITextField!
    @IBOutlet weak var Subject2: UITextField!
    
    var textString1 = ""
    var textString2 = ""
    
    @IBAction func Set1Button(_ sender: Any) {
        textString1 = Subject1.text!
        
        Subject1.text = nil
    }
    
    @IBAction func Set2Button(_ sender: Any) {
        textString2 = Subject2.text!
        
        Subject2.text = nil
    }
    
    

}
