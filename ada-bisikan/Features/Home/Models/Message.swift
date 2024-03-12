//
//  Message.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import Foundation

struct Message: Decodable, Identifiable {
    var id: Int
    var messageId: String
    var body: String
    var createdAt: Date
    var isRead: Bool = false
}
