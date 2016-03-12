//
//  PlaceListTableViewCell.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/3/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

class PlaceListTableViewCell: UITableViewCell {
	// MARK: - Outlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var userRatingView: UIView!
	// MARK: - Properties
	var place: Place?

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		nameLabel.text = "Funky Town Dog Place"
		typeLabel.text = "Dog Place"
		distanceLabel.text = "12.2 Miles"
    }
	
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
