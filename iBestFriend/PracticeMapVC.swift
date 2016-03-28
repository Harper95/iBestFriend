//
//  PracticeMapVC.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/26/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import MapKit

class PracticeMapVC: UIViewController {
	
	@IBOutlet weak var parkMapView: MKMapView!
	var user = Users()
	var parks = [MKMapItem]()
	var selectedPin: MKPlacemark? = nil
	
	// Create and instance of CLLocationManager
	var locationManager = CLLocationManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Delegate the locationManager
		locationManager.delegate = self
		// Set the locationManager's accuracy
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		// Ask user for permission to use location
		locationManager.requestWhenInUseAuthorization()
		// Grab user's location
		locationManager.requestLocation()
    }
	
	func populateParks() {
		guard let mapView = parkMapView else { return }
		
		let request = MKLocalSearchRequest()
		request.naturalLanguageQuery = "Dog Park"
		request.region = mapView.region
		
		let search = MKLocalSearch(request: request)
		search.startWithCompletionHandler { response, error in
			guard let response = response else { return }
			self.parks = response.mapItems
		}
	}

	func getInformation() {
		storyboard!.instantiateViewControllerWithIdentifier("PlaceInfoVC")
	}
	
	func getDirections() {
		if let selectedPin = selectedPin {
			let mapItem = MKMapItem(placemark: selectedPin)
			let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
			mapItem.openInMapsWithLaunchOptions(launchOptions)
		}
	}
	@IBAction func pinDropButtonTouched(sender: AnyObject) {
		print(parks)
		for park in parks {
			let annotion = MKPointAnnotation()
			annotion.coordinate = park.placemark.coordinate
			annotion.title = park.name
			
			if let city = park.placemark.locality,
				let state = park.placemark.administrativeArea {
				annotion.subtitle = "\(city) \(state)"
			}
			parkMapView.addAnnotation(annotion)
		}
	}
}

extension PracticeMapVC: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let region = MKCoordinateRegion(center: location.coordinate, span: user.span)
			parkMapView.setRegion(region, animated: true)
			populateParks()
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("location manager error: \(error)")
	}
}

extension PracticeMapVC: MKMapViewDelegate {
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			// Return nil so map view draws "blue dot" for standard user location
			return nil
		}
		
		let reuseID = "pin"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
		pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
		pinView?.canShowCallout = true
		
		let smallSquare = CGSize(width: 30, height: 30)
		
		let rightButton = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
		rightButton.setImage(UIImage(named: "info"), forState: .Normal)
		rightButton.addTarget(self, action: #selector(PracticeMapVC.getInformation), forControlEvents: .TouchUpInside)
		pinView?.rightCalloutAccessoryView = rightButton
		
		let leftButton = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
		leftButton.setImage(UIImage(named: "car"), forState: .Normal)
		leftButton.addTarget(self, action: #selector(PracticeMapVC.getDirections), forControlEvents: .TouchUpInside)
		pinView?.leftCalloutAccessoryView = leftButton
		
		return pinView
	}
	
}


