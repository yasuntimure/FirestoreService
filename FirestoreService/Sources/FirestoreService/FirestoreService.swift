import Firebase
import FirebaseFirestore


public protocol FirestoreServiceProtocol {
    func request<T: FirestoreIdentifiable>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable
}

public final class FirestoreService: FirestoreServiceProtocol {

    public func request<T>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable {
        switch endpoint.method {
        case .get:
            return try await handleGet(type, endpoint: endpoint)
        case .post:
            try await handleSet(type, endpoint: endpoint)
            return []
        case .put:
            try await handleSet(type, endpoint: endpoint)
            return []
        case .delete:
            try await handleDelete(endpoint: endpoint)
            return []
        }
    }

    private func handleGet<T: FirestoreIdentifiable>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] {
        switch endpoint.path {
        case .collection(let collectionReference):
            guard let ref = collectionReference else {
                throw FirestoreServiceError.invalidPath
            }
            let querySnapshot = try await ref.getDocuments()
            var response: [T] = []
            for document in querySnapshot.documents {
                if let data: T = document.data() as? T {
                    response.append(data)
                } else {
                    throw FirestoreServiceError.parseError
                }
            }
            return response
        case .document(let documentReference):
            guard let ref = documentReference, let singleResponse: T = try? await ref.getDocument() as? T else {
                throw FirestoreServiceError.invalidPath
            }
            return [singleResponse]
        }
    }

    private func handleSet<T: FirestoreIdentifiable>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws {
        guard case let .updateDocument(value) = endpoint.task, var model = value as? T else {
            throw FirestoreServiceError.invalidType
        }

        switch endpoint.path {
        case .collection:
            throw FirestoreServiceError.operationNotAllowed
        case .document(let documentReference):
            guard let ref = documentReference else {
                throw FirestoreServiceError.documentNotFound
            }

            if endpoint.method == .post {
                model.id = ref.documentID
            }

            try await ref.setData(model.asDictionary())
        }
    }

    private func handleDelete(endpoint: FirestoreEndpoint) async throws {
        switch endpoint.path {
        case .collection:
            throw FirestoreServiceError.operationNotAllowed
        case .document(let documentReference):
            guard let ref = documentReference else {
                throw FirestoreServiceError.invalidPath
            }
            try await ref.delete()
        }
    }
}
