//
//  DisplayTripsTableViewCell.swift
//  App2
//
//  Created by Robin on 26/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import UIKit

class DisplayTripsTableViewCell: UITableViewCell {
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(named: "bakgroundColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
