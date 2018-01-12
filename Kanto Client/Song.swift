//
//  Song.swift
//  Kanto Client
//
//  Created by Haamed Sultani on 2017-03-30.
//  Copyright © 2017 Haamed Sultani. All rights reserved.
//

import Foundation

class Song: NSObject
{
    var artist: String!
    var title: String!
    var lyrics: String!
    
    var shortLyrics: String!
    
    override init()
    {
        self.artist = "UNKNOWN"
        self.title = "UNKNOWN"
        self.lyrics = "UNKNOWN"
        self.shortLyrics = ""
    }
    
    init(mArtist: String, mTitle: String, mLyrics: String)
    {
        self.artist = mArtist
        self.title = mTitle
        self.lyrics = mLyrics
    }
}
