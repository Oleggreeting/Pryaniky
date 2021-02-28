//
//  Model.swift
//  TestPryaniky
//
//  Created by Oleg on 22.02.2021.
//

import Foundation

struct ModelData: Codable {
    var data: [Element]
    let view: [String]
}

struct Element: Codable {
    let name: String
    var data: Content
}

struct Content: Codable {
    var text: String?
    var url: String?
    var selectedId: Int?
    var variants: [Variant]?
}

struct Variant: Codable {
    let id: Int
    let text: String
}
