//
//  NetworkRequestBuilder.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation

class NetworkRequestBuilder {
    
    private static var baseUrlRequest = "https://numia.ru/api/getMessages?offset="
    
    static func createRequestUrlString(offset: Int = 0) -> String {
        return baseUrlRequest + String(offset)
    }
    
    static func getRandomImageUrl(id: Int) -> String {
        let resultId = 110 + id
        return "https://picsum.photos/id/\(resultId)/200/300"
    }
}
