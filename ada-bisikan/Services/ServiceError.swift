//
//  ServiceErrors.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import Foundation

enum ServiceError: Error {
    case invalidUrl
    case notFound
    case invalidResponse
    case invalidData
    case unableToComplete
}
