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
```

### Request Collection or Document

```swift
Task {
    do {
        let endpoint = TestEndpoint.getItems
        self.items = try await FirestoreService.request(endpoint)
    } catch {
        print("Error: ", error.localizedDescription)
    }
}
```
