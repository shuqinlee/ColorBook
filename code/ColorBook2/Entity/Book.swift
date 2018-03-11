//
//  Book.swift
//  ColorBook
//
//  Created by Shuqin Lee on 10/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//


import UIKit
import RealmSwift

// todo: find a default cover to make this as not nil
// use gaussian blur
class Book: Object {
    let paintingList = List<Painting>()
    @objc dynamic var name: String = "ColorBook"
    @objc dynamic var cover: Data? = nil
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var id: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
