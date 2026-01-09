//
//  FilmImageView.swift
//  StudioGhibiliTutApp
//
//  Created by Terrance Griffith on 1/7/26.
//

import SwiftUI

struct FilmImageView: View {
    
    let url: URL?
    
    init(urlString: String) {
        self.url = URL(string: urlString)
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Color(white: 0.5)
                    .overlay {
                        ProgressView()
                            .controlSize(.large)
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(let error):
                Text(error.localizedDescription)
            @unknown default:
                fatalError()
            }
        }
    }
}

#Preview("list") {
    
    let name = "CastleInTheSkyList"
//    let url = AssetExtractor().createLocalUrl(forImageNamed: name)
//    FilmImageView(urlString: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")
    FilmImageView(url: URL.convertAssetImage(named: name) )
        .frame(height: 150)
}

#Preview("details") {
    let name = "CastleInTheSkyBanner"
//    let url = AssetExtractor().createLocalUrl(forImageNamed: name)
    
//    FilmImageView(urlString: "https://image.tmdb.org/t/p/w533_and_h300_bestv2/3cyjYtLWCBE1uvWINHFsFnE8LUK.jpg")
    FilmImageView(url: URL.convertAssetImage(named: name) )
        .frame(height: 300)
}
