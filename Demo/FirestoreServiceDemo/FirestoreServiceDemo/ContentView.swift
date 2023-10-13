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
            let endpoint = TestEndpoint.getItems
            let result: [TestItem] = try await FirestoreService.request(endpoint)
            self.items = result
        }
    }

    func postNewItem() {
        Task {
            let item = TestItem(title: "Test Item")
            let endpoint = TestEndpoint.postItem(dto: item)
            try? await FirestoreService.request(endpoint)
            self.fetchItems()
        }
    }
}

#Preview {
    ContentView()
}
