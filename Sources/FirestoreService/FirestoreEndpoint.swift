//
//  FirestoreEndpoint.swift
//
//
//  Created by Eyüp on 2023-09-27.
//

import FirebaseFirestore

// MARK: - FirestoreEndpoint

public typealias FirestoreQuery = Query

public protocol FirestoreEndpoint {
    var path: FirestoreReference { get }
    var method: FirestoreMethod { get }
    var firestore: Firestore { get }
}

public extension FirestoreEndpoint {
    var firestore: Firestore {
        Firestore.firestore()
    }
}

// MARK: - FirestorePath

public enum FirestorePath {
    case collection(reference: CollectionReference)
    case document(reference: DocumentReference)
}

// MARK: - FirestoreMethod

public enum FirestoreMethod {
    case get
    case post(any FirestoreIdentifiable)
    case put(any FirestoreIdentifiable)
    case delete
}


public protocol FirestoreReference {
    // You can define common methods/properties here, if needed
}

extension DocumentReference: FirestoreReference { }
extension CollectionReference: FirestoreReference { }
