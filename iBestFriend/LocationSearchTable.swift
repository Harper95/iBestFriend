//
//  LocationSearchTable.swift
//  iBestFriend
//
//  Created by Clayton Harper on 3/15/16.
//  Copyright © 2016 Clayton Harper. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
	
	// MARK: - Properties
	var matchingItems = [MKMapItem]()
	var mapView: MKMapView? = nil
	var handleMapSearchDelegate: HandleMapSearch? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func parseAddress(selectedItem: MKPlacemark) -> String {
		let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
		let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
					(selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
		let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
		
		let addressLine = String(
			// %@ represents a string
			format: "%@%@%@%@%@%@%@",
			// Street Number
			selectedItem.subThoroughfare ?? "",
			firstSpace,
			// Street Name
			selectedItem.thoroughfare ?? "",
			comma,
			// City
			selectedItem.locality ?? "",
			secondSpace,
			// State
			selectedItem.administrativeArea ?? ""
		)
		return addressLine
	}
	
	// MARK: - Table View
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return matchingItems.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
		let selectedItem = matchingItems[indexPath.row].placemark
		
		cell.textLabel?.text = selectedItem.name
		cell.detailTextLabel?.text = parseAddress(selectedItem)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let selectedItem = matchingItems[indexPath.row].placemark
		handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
		dismissViewControllerAnimated(true, completion: nil)
	}
}

// MARK: - Search Sesults Updating
extension LocationSearchTable: UISearchResultsUpdating {
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		guard let mapView = mapView,
			let searchBarText = searchController.searchBar.text else { return }
		
		let request = MKLocalSearchRequest()
		request.naturalLanguageQuery = searchBarText
		request.region = mapView.region
		
		let search = MKLocalSearch(request: request)
		search.startWithCompletionHandler { response, error in
			guard let response = response else { return }
			
			self.matchingItems = response.mapItems
			self.tableView.reloadData()
		}
	}
	
}