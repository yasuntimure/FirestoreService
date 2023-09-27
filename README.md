# FirestoreService
A Swift package providing an abstracted service layer for Firebase Cloud Firestore. This package simplifies Firestore CRUD operations by defining structured endpoints and leveraging Swift's async/await and Codable features. Compatible with both SwiftUI and UIKit applications.

## Requirements

- iOS 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

1. In Xcode, open your project and navigate to `File` → `Swift Packages` → `Add Package Dependency...`
2. Paste the repository URL: `https://github.com/yasuntimure/FirestoreService.git`
3. Click on `Next` and select the latest version.
4. Click on `Next` and let Xcode resolve the package.

## Usage

After importing the package into your project:

### Create Your Endpoint 

```swift
import FirestoreService

public enum ExampleEndpoint: FirestoreEndpoint {

    case exampleList
    case saveExample(value: [YOUR MODEL])

    public var userID: String {
        "[YOUR User ID]"
    }

    public var path: FirestorePath {
        let db = Firestore.firestore()
        switch self {
        case .exampleList:
            return .collection(db.collection("XXXX").document(userID).collection("XXXX"))
        case .saveExample(let value):
            return .document(db.collection("XXXX").document(userID).collection("XXXX").document(value.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .exampleList:
            return .get
        case .saveExample:
            return .post
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .exampleList:
            return .requestPlain
        case .saveExample(let value):
            return .createDocument(value)
        }
    }
}

protocol ExampleRepositoryProtocol {
    func exampleList() async throws -> [YOUR MODEL]
    func saveExample(_ value: [YOUR MODEL]) async throws
}

struct ExampleRepository: ExampleRepositoryProtocol {

    let service: FirestoreServiceProtocol

    init(service: FirestoreServiceProtocol = FirestoreService()) {
        self.service = service
    }

    func exampleList() async throws -> [NoteModel] {
        let endpoint = ExampleEndpoint.exampleList
        return try await service.request([YOUR MODEL].self, endpoint: endpoint)
    }

    func saveExample(_ value [YOUR MODEL]) async throws {
        let endpoint = ExampleEndpoint.saveExample(value: value)
        let _ = try await service.request([YOUR MODEL].self, endpoint: endpoint)
    }

}



