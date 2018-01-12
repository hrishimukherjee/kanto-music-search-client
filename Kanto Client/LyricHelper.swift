//
//  LyricHelper.swift
//  Kanto Client
//
//  Created by Haamed Sultani on 2017-04-09.
//  Copyright © 2017 Haamed Sultani. All rights reserved.
//

import Foundation

final class LyricHelper: NSObject
{
    private override init() {}
    
    static let sharedInstance: LyricHelper = LyricHelper()
    
    // when going through a string, we use the length variable to 
    // determine how many characters we are evaluating at a time
    let length = 100
    
    
    // MARK: Methods
    
    /*
     * This method takes in the string containing the full lyrics
     * It looks for the best of the substring 'context' within the full lyrics
     * It then returns the best match
     */
    func getShortLyric(lyrics: String, context: String) -> String
    {
        var shortLyric: String = ""
        var topScore: Double = 0.0
        var from: String.Index!
        var to: String.Index!
        
        
        // get the first index of the string
        from = lyrics.index(lyrics.startIndex, offsetBy: 0)
        
        // if the 'lyrics' string length is greater than 'length', continue checking the whole string
        // else, return the full string back
        guard lyrics.characters.count > length else {
            to = lyrics.index(lyrics.startIndex, offsetBy: lyrics.characters.count)

            shortLyric = lyrics[Range(from ..< to)]
            
            return shortLyric
        }
        
        
        // passed the guard
        // loop through the string 'length' characters at a time
        // if the score of the current substring is greater than the previous score, then update the new high score and set the substring that we will return
        // if not, continue onto the next substring
        for stringIndex in 0 ... (lyrics.characters.count/length)
        {
            from = lyrics.index(lyrics.startIndex, offsetBy: stringIndex*length) // get the beginning of the range
            
            if (stringIndex >= (lyrics.characters.count/length) - 1) // error checking for when we get to the end of the string
            {
                to = lyrics.index(lyrics.startIndex, offsetBy: (lyrics.characters.count%length) + (stringIndex*length)) // get the last few characters remaining of the string
            } else {
                to = lyrics.index(lyrics.startIndex, offsetBy: (stringIndex+1)*length) // get the index 'length' indices ahead
            }
            
            // get the score of the current substring
            // fuzziness parameter changes how sensitive the comparison is
            let currentScore: Double = context.score(lyrics[Range(from ..< to)], fuzziness: 0.99)
            
            if (currentScore > topScore)
            {
                // update the top score
                topScore = currentScore
                // set the shortLyric to be returned
                shortLyric = lyrics[Range(from ..< to)]
            }
        }
        
        //print("Final: \(shortLyric)")
        
        return shortLyric
    }
    
}
