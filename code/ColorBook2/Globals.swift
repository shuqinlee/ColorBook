//
//  Globals.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 19/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Global {
    static var login: Bool = false
    static var username: String?
    static var userEmail: String?
    static var session: String?
    static var book_to_delete = [RawBook]()
    static var painting_to_delete = [RawPainting]()
    static var loaded_books = [RawBook]()
    
    static func deletePainting() {
        let paintingList = List<Painting>()
        for painting in painting_to_delete {
            paintingList.append(Raw2Realm.painting(rawPainting: painting))
        }
        RealmUtil.deletePaintingList(paintingList: paintingList)
    }
    
    static func deleteBook() {
        let bookList = List<Book>()
        for book in book_to_delete {
            bookList.append(Raw2Realm.book(rawBook: book))
        }
        RealmUtil.deleteBookList(bookList: bookList)
    }
}
