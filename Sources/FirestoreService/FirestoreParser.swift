//
//  File.swift
//  
//
//  Created by Eyüp on 2023-09-27.
//

import Foundation

struct FirestoreParser {

    static func parse<T: Decodable>(_ documentData: Dictionary, type: T.Type) throws -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            throw FirestoreServiceError.parseError
        }
    }

}
