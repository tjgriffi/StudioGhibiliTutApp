//
//  SearchView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/9/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var text = ""
    
    var body: some View {
        NavigationStack {
            Text("Search is here")
                .searchable(text: $text)
        }
    }
}

#Preview {
    SearchView()
}
