//
//  RawPainting.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 14/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import Foundation
import UIKit

class RawPainting {
    var owner: Book?
    var desc: String?
    var raw: UIImage? // the original pic
    var painting: UIImage?
    var line: UIImage? // todo: for now nil
    var createdate: Date = Date()
    var id: String?
}
