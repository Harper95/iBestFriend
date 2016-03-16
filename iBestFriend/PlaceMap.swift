//
//  PlaceMap.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/5/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit	// UIKit and Foundation
import MapKit // MapKit and CoreLocation

protocol HandleMapSearch {
	func dropPinZoomIn(placeMark: MKPlacemark)
}

class PlaceMap: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	
	let locationManager = CLLocationManager()							// Gain acess to locationManager throughout the scope
	var resultSearchController: UISearchController? = nil	// Keep search controller in memory after it's been created
	var selectedPin: MKPlacemark? = nil										// Cache any incoming placemarks

	
	override func viewWillAppear(animated: Bool) {
		navigationItem.setHidesBackButton(true, animated: false)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self																			// Delegate methods handled asynchronously
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters	// Set to hundredMeters to save battery life
		locationManager.requestWhenInUseAuthorization()											// Prompt user for location permission(only happens once)
		locationManager.requestLocation()																		// One time location request
		
		let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
		resultSearchController = UISearchController(searchResultsController: locationSearchTable)
		resultSearchController?.searchResultsUpdater = locationSearchTable
		
		// Configure the search bar and embed it within the navigation bar
		let searchBar = resultSearchController!.searchBar
		searchBar.sizeToFit()
		searchBar.placeholder = "Search by city"
		navigationItem.titleView = resultSearchController!.searchBar
		
		// Configure the UISearchController Appearance
		resultSearchController?.hidesNavigationBarDuringPresentation = false	// Want access to the search bar at all times
		resultSearchController?.dimsBackgroundDuringPresentation = true				// Create semi-transparent backgroun when searchBar is selected
		definesPresentationContext = true																			// Limit modal overlay to just the View Controller's frame
		
		locationSearchTable.mapView = mapView		// Pass along a handle of mapView to locationSearchTable
		
		locationSearchTable.handleMapSearchDelegate = self
	}
	
	func getDirections() {
		if let selectedPin = selectedPin {
			let mapItem = MKMapItem(placemark: selectedPin)
			let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
			mapItem.openInMapsWithLaunchOptions(launchOptions)
		}
	}
	
}

extension PlaceMap: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == .AuthorizedWhenInUse {		// If user authorizes location usage
			locationManager.requestLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {																					// Grab the first location in the array
			let span = MKCoordinateSpanMake(0.05, 0.05)																// Zoom level 0.05 longitude and latitude
			let region = MKCoordinateRegion(center: location.coordinate, span: span)	// The point of intrest and how far to zoom in
			
			mapView.setRegion(region, animated: true)																	// Zoom to the region
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("error: \(error)")
	}
	
}

extension PlaceMap: MKMapViewDelegate {
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
		let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
		button.setImage(UIImage(named: "rightChevron"), forState: .Normal)
		button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
		pinView?.rightCalloutAccessoryView = button
		
		return pinView
	}
	
}

extension PlaceMap: HandleMapSearch {
	func dropPinZoomIn(placeMark: MKPlacemark) {
		// Cache the pin
		selectedPin = placeMark
		// Clear existing pins
		mapView.removeAnnotations(mapView.annotations)
		// Create the annotation
		let annotion = MKPointAnnotation()
		annotion.coordinate = placeMark.coordinate
		annotion.title = placeMark.name
		if let city = placeMark.locality,
			let state = placeMark.administrativeArea {
				annotion.subtitle = "\(city) \(state)"
		}
		// Add annotation to the map
		mapView.addAnnotation(annotion)
		// Zoom to location
		let span = MKCoordinateSpanMake(0.005, 0.005)
		let region = MKCoordinateRegionMake(placeMark.coordinate, span)
		mapView.setRegion(region, animated: true)
	}
	
}