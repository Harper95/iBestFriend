//
//  PlaceMapVC.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/5/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import MapKit

class PlaceMapVC: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView!
	
	// MARK: - Properties
	var user = Users()
	let locationManager = CLLocationManager()
	var selectedPin: MKPlacemark? = nil
	var matchingParks = [MKMapItem]()
	
	override func viewWillAppear(animated: Bool) {
//		navigationItem.setHidesBackButton(true, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
	}
	
	func populateParks() {
		guard let mapView = mapView else { return }
		
		let request = MKLocalSearchRequest()
		request.naturalLanguageQuery = "Dog Park"
		request.region = mapView.region
		
		let search = MKLocalSearch(request: request)
		search.startWithCompletionHandler { response, error in
			guard let response = response else { return }
			self.matchingParks = response.mapItems
		}
	}
	
	func getInformation() {
		performSegueWithIdentifier("MapToInfo", sender: nil)
	}
	
	func getDirections() {
		if let selectedPin = selectedPin {
			let mapItem = MKMapItem(placemark: selectedPin)
			let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
			mapItem.openInMapsWithLaunchOptions(launchOptions)
		}
	}
	
	@IBAction func pinDropButtonTouched(sender: AnyObject) {
		print(matchingParks)
		for park in matchingParks {
			let annotion = MKPointAnnotation()
			annotion.coordinate = park.placemark.coordinate
			annotion.title = park.name
			
			if let city = park.placemark.locality,
				let state = park.placemark.administrativeArea {
				annotion.subtitle = "\(city) \(state)"
			}
			mapView.addAnnotation(annotion)
		}
	}
}
// MARK: - Location Manager Delegate
extension PlaceMapVC: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let region = MKCoordinateRegion(center: location.coordinate, span: user.span)
			mapView.setRegion(region, animated: true)
			populateParks()
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("location manager error: \(error)")
	}
	
}
// MARK: - Map View Delegate
extension PlaceMapVC: MKMapViewDelegate {
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			return nil
		}
		
		let reuseID = "pin"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
		pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
		pinView?.pinTintColor = UIColor.orangeColor()
		pinView?.canShowCallout = true
		
		let smallSquare = CGSize(width: 30, height: 30)
		let rightButton = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
		rightButton.setImage(UIImage(named: "info"), forState: .Normal)
		rightButton.addTarget(self, action: #selector(PlaceMapVC.getInformation), forControlEvents: .TouchUpInside)
		pinView?.rightCalloutAccessoryView = rightButton
		
		let leftButton = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
		leftButton.setImage(UIImage(named: "car"), forState: .Normal)
		leftButton.addTarget(self, action: #selector(PlaceMapVC.getDirections), forControlEvents: .TouchUpInside)
		pinView?.leftCalloutAccessoryView = leftButton
		
		return pinView
	}
	
}
