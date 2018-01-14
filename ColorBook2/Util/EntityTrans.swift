//
//  EntityTrans.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 14/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
import RealmSwift

class Raw2Realm {
    // raw to realm
    class func book(rawBook: RawBook) -> Book {
        /**
         let paintingList = List<Painting>()
         @objc dynamic var name: String = "ColorBook"
         @objc dynamic var cover: Data? = nil
         @objc dynamic var createDate: Date = Date()
         @objc dynamic var id: String?
         */
        let book = Book()
        // 1
        for pp in rawBook.paintingList {
            let painting = self.painting(rawPainting: pp)
            painting.owner = book
            book.paintingList.append(painting)
            
        }
        // 2
        book.name = rawBook.name
        // 3
        if let cover = rawBook.cover { book.cover = UIImagePNGRepresentation(cover)}
        // 4
        book.createDate = rawBook.createDate
        // 5
        book.id = rawBook.id
        
        return book
    }
    
    // todo: 
    class func painting(rawPainting: RawPainting) -> Painting {
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
        // 1
//        painting.owner = rawPainting.owner?.id
        // 2
        painting.desc = rawPainting.desc
        // 3
        if let raw = rawPainting.raw { painting.raw = UIImagePNGRepresentation(raw) }
        // 4
        if let line = rawPainting.line { painting.raw = UIImagePNGRepresentation(line) }
        // 5
        if let pp = rawPainting.painting { painting.painting = UIImagePNGRepresentation(pp) }
        // 6
        painting.createdate = rawPainting.createdate
        // 7
        painting.id = rawPainting.id
        return painting
    }
    
}

class Realm2Raw {
    // realm to raw
    class func book(book: Book) -> RawBook {
        let rawBook = RawBook()
        rawBook.book = book
        if let cover = book.cover { rawBook.cover = UIImage(data: cover)}
        rawBook.createDate = book.createDate
        rawBook.id = book.id
        rawBook.name = book.name
        
        return rawBook
    }
    
    class func painting(painting: Painting) -> RawPainting {
        let rawPainting = RawPainting()
        rawPainting.createdate = painting.createdate
        rawPainting.desc = painting.desc
        rawPainting.id = painting.id
        if let line = painting.line {
            rawPainting.line = UIImage(data: line)
        }
        if let pp = painting.painting {
            rawPainting.painting = UIImage(data: pp)
        }
        if let raw = painting.raw {
            rawPainting.raw = UIImage(data: raw)
        }
        rawPainting.ownerId = painting.owner?.id
        
        return rawPainting
    }
    
    class func paintingList(paintingList: Results<Painting>) -> [RawPainting]{
        var rawPaintingList = [RawPainting]()
        for painting in paintingList {
            rawPaintingList.append(self.painting(painting: painting))
        }
        return rawPaintingList
    }
    
    class func paintingList(paintingList: List<Painting>) -> [RawPainting]{
        var rawPaintingList = [RawPainting]()
        for painting in paintingList {
            rawPaintingList.append(self.painting(painting: painting))
        }
        return rawPaintingList
    }
    
    class func bookList(bookList: Results<Book>) -> [RawBook] {
        var rawBookList = [RawBook]()
        for book in bookList {
            rawBookList.append(self.book(book: book))
        }
        return rawBookList
    }
}
