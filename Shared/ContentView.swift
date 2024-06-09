//
//  ContentView.swift
//  CoordinatorBug
//
//  Created by Jeffrey Bergier on 2024/06/08.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var presenter = Presenter()
    
    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline) {
                Text("Parent Directory:")
                    .font(.subheadline)
                Spacer()
                Text(String(describing: self.presenter.parentDirectoryContents.count))
                    .font(.title.monospacedDigit())
            }
            HStack(alignment: .lastTextBaseline) {
                Text("Subdirectory:")
                    .font(.subheadline)
                Spacer()
                Text(String(describing: self.presenter.subdirectoryContents.count))
                    .font(.title.monospacedDigit())
            }
            Spacer()
            Button {
                self.presenter.parentDirectoryAppend()
            } label: {
                Text("Add File to Parent Directory")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            Button {
                self.presenter.subirectoryAppend()
            } label: {
                Text("Add File to Subdirectory")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            Button {
                self.presenter.resetDirectories()
            } label: {
                Text("Reset")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}
