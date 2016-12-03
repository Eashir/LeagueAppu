//
//  ChampionTableViewCell.swift
//  LeagueAppu
//
//  Created by Eashir Arafat on 11/19/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class ChampionTableViewCell: UITableViewCell {
    
    var champion: Champion?
    
    @IBOutlet weak var championSkin: UIImageView!
    @IBOutlet weak var championSplash: UIImageView!
    @IBOutlet weak var championLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        championLabel.textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
