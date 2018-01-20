//
//  Response.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 20/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import Foundation

class Response {
    var code: ResponseCode
    var message: String?
    private init(code: ResponseCode, message: String) {
        self.code = code
        self.message = message
    }
    private init(code: ResponseCode) {
        self.code = code
    }
    class func createBySuccess() -> Response {
        return Response(code: .SUCCESS)
    }
    class func createBySuccess(message: String) -> Response {
        return Response(code: .SUCCESS, message: message)
    }
    
    class func createByError(message: String) -> Response {
        return Response(code: .ERROR, message: message)
    }
}

enum ResponseCode {
    case SUCCESS
    case ERROR
}
