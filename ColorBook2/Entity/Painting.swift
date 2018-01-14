//
//  Paiting.swift
//  ColorBook
//
//  Created by Shuqin Lee on 10/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import UIKit
import RealmSwift


class Painting: Object {
    
    @objc dynamic var owner: Book?
    @objc dynamic var desc: String?
    @objc dynamic var raw: Data? // the original pic
    @objc dynamic var painting: Data?
    @objc dynamic var line: Data? // todo: for now nil
    @objc dynamic var createdate: Date = Date()
    @objc dynamic var id: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
