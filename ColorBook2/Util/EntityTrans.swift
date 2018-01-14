//
//  EntityTrans.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 14/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

class EntityTransfer {
    class func book_raw2realm(rawBook: RawBook) -> Book {
        /**
         let paintingList = List<Painting>()
         @objc dynamic var name: String = "ColorBook"
         @objc dynamic var cover: Data? = nil
         @objc dynamic var createDate: Date = Date()
         @objc dynamic var id: String?
        */
        let book = Book()
        
        book.name = rawBook.name
        if let cover = rawBook.cover { book.cover = UIImagePNGRepresentation(cover)}
        book.createDate = rawBook.createDate
        book.id = rawBook.id
        
        return book
    }
    
    class func painting_raw2realm(rawPainting: RawPainting) -> Painting {
        /**
         @objc dynamic var owner: Book?
         @objc dynamic var desc: String?
         @objc dynamic var raw: Data? // the original pic
         @objc dynamic var painting: Data?
         @objc dynamic var line: Data? // todo: for now nil
         @objc dynamic var createdate: Date = Date()
         @objc dynamic var id: String?
        */
        let painting = Painting()
        painting.owner
    }
}
