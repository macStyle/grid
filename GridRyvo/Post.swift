//
//  Post.swift
//  GridRyvo
//
//  Created by Adam Jemni on 9/16/21.
//

import Foundation
import SwiftUI

struct Post: Identifiable
{

    var aspectRatio: CGFloat
    var randomNumberForImage: Int
    var offset: Int

    var url: URL
    {
        URL(string: "https://picsum.photos/\(Int(aspectRatio * 500))/500?random=\(abs(randomNumberForImage))")!
    }


    var id: Int
    {
        randomNumberForImage.hashValue
    }

    static func randomPost(_ randomNumber: Int, aspectRatio: CGFloat, offset: Int = 0) -> Post
    {
        Post(
       
            aspectRatio: aspectRatio,
            randomNumberForImage: randomNumber,
            offset: offset)
    }
}

struct DataSource
{
    static func postsForGridSection(_ sectionID: Int, number: Int = 12) -> [Post]
    {
        (0 ..< number).map
        { b -> Post in
            let aspect: CGFloat = 1
            return Post.randomPost(sectionID * 10_000 + b, aspectRatio: aspect, offset: b)
        }
    }


}
