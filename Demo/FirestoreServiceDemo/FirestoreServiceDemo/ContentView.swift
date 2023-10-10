//
//  ContentView.swift
//  FirestoreServiceDemo
//
//  Created by Eyüp on 2023-10-05.
//

import SwiftUI
import FirestoreService

struct ContentView: View {

    @State var items: [TestItem] = []

    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.id) { item in
                    VStack {
                        Text(item.title)
                            .bold()
                            .foregroundStyle(.primary)
                        Text(item.id)
                            .foregroundStyle(.secondary)
                    }
                }
            }.task { fetchItems() }

            Button("Add New Item") {
                postNewItem()
            }
        }
    }

    func fetchItems() {
        Task {
            let result = try? await FirestoreService.requestCollection(TestItem.self, endpoint: TestEndpoint.getItems)
            self.items = result ?? []
        }
    }

    func postNewItem() {
        Task {
            let item = TestItem(title: "Test Item")
            let endpoint = TestEndpoint.postItem(dto: item)
            _ = try? await FirestoreService.requestDocument(TestItem.self, endpoint: endpoint)
            self.fetchItems()
        }
    }
}

#Preview {
    ContentView()
}
