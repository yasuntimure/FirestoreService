//
//  File.swift
//  
//
//  Created by Eyüp on 2023-09-27.
//

import Foundation

public protocol FirestoreIdentifiable: Hashable, Codable, Identifiable {
    var id: String { get set }
}

public typealias Dictionary = [String: Any]

extension Encodable {

    func asDictionary() -> Dictionary {

        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary else {
            return [:]
        }

        return dictionary
    }
}
