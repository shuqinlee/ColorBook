//
//  DataLoader.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 12/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import Foundation
import RealmSwift


// load from local
class LocalFileLoader {
//    static let formatter = DateFormatter()
    static let formatter: DateFormatter = {
        var f = DateFormatter()
        f.dateFormat = "yyyy.MM.dd HH:mm:ss"
        return f
    }()

    class func loadBookList() -> [RawBook] {
        var bookList = [RawBook]()
        do {
            let jsonPth = Bundle.main.url(forResource: "allBook", withExtension: ".json")

            let text = try String(contentsOf: jsonPth!, encoding: String.Encoding.utf8)
            let jsonObj = JSON(parseJSON: text)

            let code = jsonObj["code"].int!
            if code == 200 {
                let data = jsonObj["data"]

                for (_, bjs): (String, JSON) in data {
                    let cover = Base64Util.convertBase64ToImage(imageString: bjs["cover"].string!)
                    let name = bjs[Content.NAME.rawValue].string!
                    let createDate = formatter.date(from: bjs[Content.CREATEDATE.rawValue].string!)

                    let book = RawBook()
                    book.cover = cover
                    book.name = name
                    book.createDate = createDate ?? Date()
//                    book.id = NSUUID().uuidString
                    bookList.append(book)
                }
                // todo: check for nil?
            } else {
                print("Error code \(code) received")
            }
            
        }
        catch {
            print("Error opening file! ")

        }
        return bookList
    }

}


