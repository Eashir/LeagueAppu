//
//  ChampionTableViewCell.swift
//  LeagueAppu
//
//  Created by Eashir Arafat on 11/19/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class ChampionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var championLore: UILabel!
    @IBOutlet weak var championSkin: UIImageView!
    @IBOutlet weak var championLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
