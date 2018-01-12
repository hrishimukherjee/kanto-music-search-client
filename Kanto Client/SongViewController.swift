//
//  SongViewController.swift
//  Kanto Client
//
//  Created by Haamed Sultani on 2017-04-06.
//  Copyright © 2017 Haamed Sultani. All rights reserved.
//


//https://github.com/Guozai/YouTube-API-Demo-Swift3

import UIKit
import SwiftyJSON

class SongViewController: UIViewController
{
    // MARK: UI components
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var lyricsTxtView: UITextView!
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: models
    var song = Song()
    
    // Set up a network session
    let session = URLSession.shared
    
    // URL for the youtube video to be loaded
    var youtubeUrl: String = ""// = "https://www.youtube.com/embed/GxgqpCdOKak?ecver=2"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        webView.allowsInlineMediaPlayback = true // allow the video to play without going full screen
        webView.scrollView.isScrollEnabled = false // disable scrolling on the video
        
        let borderColor = UIColor.black.cgColor

        self.lyricsTxtView.layer.borderWidth = 0.05
        self.lyricsTxtView.layer.cornerRadius = 3
        self.lyricsTxtView.layer.borderColor = borderColor
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        titleLbl.text = song.title
        artistLbl.text = song.artist
        lyricsTxtView.text = song.lyrics
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getVideoList()
    }
    
    // Rest GET static String parts
    let BASE_URL: String = "https://www.googleapis.com/youtube/v3/"
    let SEARCH_VIDEO: String = "search?part=snippet"
    let MAX_RESULTS: String = "&maxResults=2"
    let ORDER: String = "&order=relevance"
    let Q: String = "&q="
    let VIDEO_TYPE: String = "&type=video"
    let VIDEO_EMBEDDABLE: String = "&videoEmbeddable=true"
    let KEY: String = "&key="
    
    
    func getVideoList()
    {
        // separate the search query
        let artist = self.artistLbl.text?.replacingOccurrences(of: " ", with: "+")
        let song = self.titleLbl.text?.replacingOccurrences(of: " ", with: "+")
        let query = artist! + "+" + song!
        // Make the query url
        let searchVideoByTitle = BASE_URL + SEARCH_VIDEO + MAX_RESULTS + ORDER + Q + query + VIDEO_TYPE + VIDEO_EMBEDDABLE + KEY + Constants.APIKEY
        
        if let url = URL(string: searchVideoByTitle)
        {
            let request = URLRequest(url: url)
            
            // Initialise the task for getting the data
            initialiseTaskForGettingData(request, element: "items")
        }
    }
    
    
    func initialiseTaskForGettingData(_ request: URLRequest, element: String) {
        
        // Initialize task for getting data
        // Refer to http://www.appcoda.com/youtube-api-ios-tutorial/
        let task = session.dataTask(with: request, completionHandler: {
            (data, HTTPStatusCode, error) in
            // Handler in the case of an error
            if error != nil
            {
                print(error as Any)
                return
            }
            else {
                //json
                let searchJson = JSON(data!)
                
                DispatchQueue.main.async {
                    self.youtubeUrl = "https://www.youtube.com/embed/" + searchJson["items"][0]["id"]["videoId"].stringValue
                    
                    
                    self.webView.loadHTMLString("<div style=\"position:relative;height:0;padding-bottom:56.25%\"><iframe src=\"\(self.youtubeUrl)?&playsinLine=1\" width=\"\(self.webView.frame.width)\" height=\"\(self.webView.frame.height)\" frameborder=\"0\" style\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen></iframe></div>", baseURL: nil)
                }
            }
            
        })
        // Execute the task
        task.resume()
    }
}
