//
//  Users.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/13/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import Foundation
import Firebase
import MapKit

public class Users {
	
	var pets = [Pet]()
	var firstName: String?
	var lastName: String?
	var userName: String?
	var securityAnswer: String?
	var directionPreference: String?
	var spanLat: CLLocationDegrees = 0.5
	var spanLong: CLLocationDegrees = 0.5
	var span = MKCoordinateSpan()
	
	init() {
		self.span = MKCoordinateSpanMake(self.spanLat, self.spanLong)
	}
}