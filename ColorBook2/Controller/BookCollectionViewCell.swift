//
//  BookCollectionViewCell.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 12/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    var book: Book!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    
}
