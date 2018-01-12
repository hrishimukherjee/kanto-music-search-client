//
//  MainTableViewCell.swift
//  Kanto Client
//
//  Created by Haamed Sultani on 2017-03-30.
//  Copyright © 2017 Haamed Sultani. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lyricsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.lyricsLbl.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
