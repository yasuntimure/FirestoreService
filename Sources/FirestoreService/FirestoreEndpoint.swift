//
//  File.swift
//  
//
//  Created by Eyüp on 2023-09-27.
//

import FirebaseFirestore

// MARK: - FirestoreEndpoint

public protocol FirestoreEndpoint {
    var userID: String { get }
    var path: FirestorePath { get }
    var method: FirestoreMethod { get }
    var task: FirestoreRequestPayload { get }
}

// MARK: - FirestorePath

public enum FirestorePath {
    case collection(CollectionReference?)
    case document(DocumentReference?)
}

// MARK: - FirestoreMethod

public enum FirestoreMethod {
    case get
    case post
    case put
    case delete
}

// MARK: - FirestoreRequestPayload

public enum FirestoreRequestPayload {
    case requestPlain
    case createDocument(any FirestoreIdentifiable)
    case updateDocument(any FirestoreIdentifiable)
}
