//
//  MainTableViewController.swift
//  Kanto Client
//
//  Created by Haamed Sultani on 2017-03-30.
//  Copyright © 2017 Haamed Sultani. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UISearchBarDelegate
{
    var connection: Connection! // used to make server requests
    
    var songs: [Song]! // the model-array that holds each song result
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    // Custom colors used to color the cells
    let cellColorA = UIColor(red: CGFloat(217.0/250.0),
                             green: CGFloat(112.0/255.0),
                             blue: CGFloat(106.0/255.0),
                             alpha: CGFloat(1.0))
    let cellColorB = UIColor(red: CGFloat(227.0/255.0),
                             green: CGFloat(150.0/255.0),
                             blue: CGFloat(146.0/255.0),
                             alpha: CGFloat(1.0))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchbar.delegate = self
        
        // setting the title of the tableview
        self.navigationItem.title = "Kanto"
        
        // configuration for the tableview cell height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 112
        
        // create our connection class used to talk to the restful server
        self.connection = Connection()
        // initialize the songs array
        self.songs = []
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateLyricPreviews()
    }
    
    /*
     * This method is used to update the text in the short preview of the lyrics
     */
    func updateLyricPreviews()
    {
        for index in 0 ..< self.songs.count
        {
            self.songs[index].shortLyrics = LyricHelper.sharedInstance.getShortLyric(lyrics: self.songs[index].lyrics, context: self.searchbar.text!)
        }
        
        // update the view
        self.tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! MainTableViewCell
        
        if indexPath.row % 2 == 0
        {
            cell.contentView.backgroundColor = cellColorA // darker pink color
        }
        else {
            cell.contentView.backgroundColor = cellColorB // lighter pink color
        }
        
        let song = songs[indexPath.row] // grab the song for the cell
        
        cell.artistLbl.text = song.artist // set the artist in the cell
        cell.titleLbl.text = song.title // set the title in the cell
        cell.lyricsLbl.text = song.shortLyrics // set the lyrics in the cell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "ShowSongSegue", sender: self)
    }
    
    
    // MARK: - UISearchBar Delegates
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchbar.endEditing(true)
        
        if (self.searchbar.text != nil || self.searchbar.text != "")
        {
            connection.searchQuery(searchString: self.searchbar.text!)
            {
                (returnType, returnedArray) -> Void in
                
                self.songs.removeAll() // clearing the table of the search results
                self.tableView.reloadData()
            
                let songJSON = JSON(returnedArray) // json serialization of the server response
                
                for index in 0 ... returnedArray.count
                {
                    let song: Song = Song() // new song to append to the tableview
                    
                    // setting model properties
                    song.artist = songJSON[index]["artist"].stringValue
                    song.title = songJSON[index]["name"].stringValue
                    song.lyrics = songJSON[index]["lyrics"].stringValue
                    
                    
                    let newIndexPath = IndexPath(row: self.songs.count, section: 0)
                    self.songs.append(song)
                    self.tableView.insertRows(at: [newIndexPath], with: .top)
                    
                    self.tableView.reloadData()
                }
                self.updateLyricPreviews()
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ShowSongSegue"
        {
            if let songIndex = tableView.indexPathForSelectedRow?.row
            {
                let destinationVC = segue.destination as! SongViewController
                
                destinationVC.song = self.songs[songIndex]
            }
        }
        
    }
}
