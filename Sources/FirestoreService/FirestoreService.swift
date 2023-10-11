import Firebase
import FirebaseFirestore


public protocol FirestoreServiceProtocol {
    static func requestDocument<T>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> T? where T: FirestoreIdentifiable
    static func requestCollection<T>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable
}

public final class FirestoreService: FirestoreServiceProtocol {

    public init() {}

    public static func requestDocument<T>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> T? where T: FirestoreIdentifiable {
        guard let ref = endpoint.path as? DocumentReference else {
            throw FirestoreServiceError.documentNotFound
        }
        switch endpoint.method {
        case .get:
            guard let documentSnapshot = try? await ref.getDocument() else {
                throw FirestoreServiceError.invalidPath
            }

            guard let documentData = documentSnapshot.data() else {
                throw FirestoreServiceError.parseError
            }

            let singleResponse = try FirestoreParser.parse(documentData, type: T.self)
            return singleResponse

        case .post(var model):
            model.id = ref.documentID
            try await ref.setData(model.asDictionary())
        case .put(let model):
            try await ref.setData(model.asDictionary())
        case .delete:
            try await ref.delete()
        }
        return nil
    }

    public static func requestCollection<T>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable {
        guard let ref = endpoint.path as? CollectionReference else {
            throw FirestoreServiceError.collectionNotFound
        }
        switch endpoint.method {
        case .get:
            let querySnapshot = try await ref.getDocuments()
            var response: [T] = []
            for document in querySnapshot.documents {
                let data = try FirestoreParser.parse(document.data(), type: T.self)
                response.append(data)
            }
            return response
        case .post, .put, .delete:
            throw FirestoreServiceError.operationNotSupported
        }
    }
}
