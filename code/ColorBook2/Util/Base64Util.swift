//
//  Base64Util.swift
//  FlickrSearch
//
//  Created by Shuqin Lee on 11/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import UIKit

class Base64Util {
    //
    // Convert String to base64
    //
    class func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //
    // Convert base64 to String
    //
    class func convertBase64ToImage(imageString: String) -> UIImage {
//        let index = imageString.range(of: "base64,")?.upperBound
//        let subStr = imageString[index! ..< imageString.endIndex]
//        let imageData = Data(base64Encoded: String(subStr), options: .ignoreUnknownCharacters)!
//        return UIImage(data: imageData)!
        return UIImage(data: convertBase64ToData(imageString: imageString))!
    }
    
    class func convertBase64ToData(imageString: String) -> Data {
        let index = imageString.range(of: "base64,")?.upperBound
        let subStr = imageString[index! ..< imageString.endIndex]
        return Data(base64Encoded: String(subStr), options: .ignoreUnknownCharacters)!
    }
}

