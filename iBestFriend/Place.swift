//
//  Place.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/4/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit

class Place {
	// MARK - Properties
	var hazards: String = "No known hazards"
	var rating: Int = 0

	
	var name: String
	var long, lat: Double
	
	var photo: UIImage?
	var isOffLeash: Bool?
	var hasWater: Bool?
	var isFenced: Bool?
	
	//MARK - Initialization
	init(name: String, long: Double, lat: Double) {
		self.name = name
		self.long = long
		self.lat = lat
	}
}