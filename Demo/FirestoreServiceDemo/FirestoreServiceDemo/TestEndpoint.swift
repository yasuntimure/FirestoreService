//
//  TestEndpoint.swift
//  FirestoreServiceDemo
//
//  Created by Eyüp on 2023-10-10.
//

import Foundation
import FirestoreService

public struct TestItem: FirestoreIdentifiable {
    public var id: String
    public let title: String

    init(id: String = UUID().uuidString,
         title: String = "") {
        self.id = id
        self.title = title
    }
}

public enum TestEndpoint: FirestoreEndpoint {
    
    case getItems
    case postItem(dto: TestItem)

    public var path: FirestoreReference {
        switch self {
        case .getItems:
            return firestore.collection("items")
        case .postItem(let dto):
            return firestore.collection("items").document(dto.id)
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getItems:
            return .get
        case .postItem(let dto):
            return .post(dto)
        }
    }
}
