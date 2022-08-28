//
//  NetworkEntities.swift
//  Test_InvoltaTestApp
//
//  Created by test on 26.08.2022.
//

import Foundation

typealias MessageWithImageData = (message: String, image: Data?)

struct MessagesWrapped: Decodable {
    let result: [String]
}
