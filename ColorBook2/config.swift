//
//  config.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 06/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import Foundation
import RealmSwift
struct Config {
    static let prodRealmURL = urlInDocument(fileName: "code-book.realm")
    static let devRealmURL = URL(fileURLWithPath: "/Users/shuqinlee/Documents/PROJECT/Engineering/创新项目/Codes/References/ColorBook2/color-book.realm")
    static let REALM_CONFIG = Realm.Configuration(fileURL: prodRealmURL, readOnly: false)
    
    static func urlInDocument(fileName: String) -> URL {
        let documentsDir: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                                        .last! as NSString
        return URL(fileURLWithPath: documentsDir.appendingPathComponent(fileName))
    }
}

