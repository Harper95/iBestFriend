//
//  UserRating.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/4/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

class UserRating: UIView {
	// MARK: - Properties
	var rating = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	var pawButtons = [UIButton]()
	let spacing = 5
	let paws = 5
	
	// MARK: - Initialization
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
//		let userRatedPawImage = UIImage(named: "Orange Paw")
		let ratedPawImage = UIImage(named: "Filled Paw")
		let blankPawImage = UIImage(named: "Blank Paw")
		
		for _ in 0..<paws {
			let pawRatingButton = UIButton()
			
			pawRatingButton.setImage(blankPawImage, forState: .Normal)
			pawRatingButton.setImage(ratedPawImage, forState: .Selected)
			pawRatingButton.setImage(ratedPawImage, forState: [.Highlighted, .Selected])
			
			pawRatingButton.adjustsImageWhenHighlighted = false
			
			pawRatingButton.addTarget(self, action: "pawRatingTapped:", forControlEvents: .TouchDown)
			pawButtons += [pawRatingButton]
			addSubview(pawRatingButton)
		}
	}
	
	override func layoutSubviews() {
		let pawSize = Int(frame.size.height)
		var pawFrame = CGRect(x: 0, y: 0, width: pawSize, height: pawSize)
		
		for (index, button) in pawButtons.enumerate() {
			pawFrame.origin.x = CGFloat(index * (pawSize + spacing))
			button.frame = pawFrame
		}
		updateButtonSelectedState()
	}
	
	func pawRatingTapped(button: UIButton) {
		rating = pawButtons.indexOf(button)! + 1
		
		updateButtonSelectedState()
	}
	func updateButtonSelectedState() {
		for(index, button) in pawButtons.enumerate() {
			button.selected = index < rating
		}
	}
}