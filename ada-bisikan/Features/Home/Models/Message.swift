//
//  Message.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: String
    var content: String
    var createdAt: Date
}
