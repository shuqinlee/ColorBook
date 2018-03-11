//
//  RawBook.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 14/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

class RawBook {
    /// this is used when opening a book, will use this variable to load raw paintingList
    var book: Book! 
    var paintingList = [RawPainting]() // this is loaded only when necessary
    var name: String = "ColorBook"
    var cover: UIImage?
    var createDate: Date = Date()
    var id: String?
}
