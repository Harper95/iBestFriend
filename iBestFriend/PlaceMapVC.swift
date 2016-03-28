//
//  PlaceMapVC.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/5/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
	func dropPinZoomIn(placeMark: MKPlacemark)
}

class PlaceMapVC: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var mapView: MKMapView!
	
	// MARK: - Properties
	let locationManager = CLLocationManager()
	var resultSearchController: UISearchController? = nil
	var selectedPin: MKPlacemark? = nil
	
	var matchingParks = [MKMapItem]()
	
	override func viewWillAppear(animated: Bool) {
		navigationItem.setHidesBackButton(true, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		
		let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
		resultSearchController = UISearchController(searchResultsController: locationSearchTable)
		resultSearchController?.searchResultsUpdater = locationSearchTable
		
		// Configure the search bar and embed it within the navigation bar
		let searchBar = resultSearchController!.searchBar
		searchBar.sizeToFit()
		searchBar.placeholder = "Search by city"
		navigationItem.titleView = resultSearchController!.searchBar
		
		// Configure the UISearchController Appearance
		resultSearchController?.hidesNavigationBarDuringPresentation = false
		resultSearchController?.dimsBackgroundDuringPresentation = true
		definesPresentationContext = true
		
		locationSearchTable.mapView = mapView
		
		locationSearchTable.handleMapSearchDelegate = self
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
	
}
// MARK: - Location Manager Delegate
extension PlaceMapVC: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {												// Grab the first location in the array
			let span = MKCoordinateSpanMake(0.1, 0.1)									// Zoom level 0.05 longitude and latitude
			let region = MKCoordinateRegion(center: location.coordinate, span: span)	// The point of intrest and how far to zoom in
			
			mapView.setRegion(region, animated: true)									// Zoom to the region
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("error: \(error)")
	}
	
}
// MARK: - Map View Delegate
extension PlaceMapVC: MKMapViewDelegate {
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			// Return nil so map view draws "blue dot" for standard user location
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
