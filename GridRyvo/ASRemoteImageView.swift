//
//  ASRemoteImageView.swift
//  GridRyvo
//
//  Created by Adam Jemni on 9/16/21.
//

import Foundation
import SwiftUI

struct ASRemoteImageView: View
{
    init(_ url: URL)
    {
        self.url = url
        imageLoader = ASRemoteImageManager.shared.imageLoader(for: url)
    }

    let url: URL
    @ObservedObject
    var imageLoader: ASRemoteImageLoader

    var content: some View
    {
        ZStack
        {
            Color(.secondarySystemBackground)
            Image(systemName: "photo")
            self.imageLoader.image.map
            { image in
                Image(uiImage: image)
                    .resizable()
            }.transition(AnyTransition.opacity.animation(Animation.default))
        }
        .compositingGroup()
    }

    var body: some View
    {
        content
    }
}
