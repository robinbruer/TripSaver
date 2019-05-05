//
//  MapsViewController.swift
//  App2
//
//  Created by Robin on 15/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import MapboxGeocoder

class MapsViewController: UIViewController, MGLMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    public var saveCord: String?
    var showButton = true
    var mapView: NavigationMapView!
    var directionsRoute: Route?
    let geocoder = Geocoder.shared
    var searchButton = UIButton()
    var navButton = UIButton()
    var searchTextField: UITextField!
    var window: UIWindow?
    var searchBar: UISearchBar = UISearchBar()
    var tableView: UITableView = UITableView()
    let endCord = CLLocationCoordinate2D(latitude: 57.7210, longitude: 12.9398)
    var placeArray = [GeocodedPlacemark]()
    let navigeringsTitel = "Starta Navigering"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // load()
        if (SaveData.shared.shouldPrelode) {
            self.showButton = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.startNavigationFromCell()
                SaveData.shared.shouldPrelode = false
                
            }
        }
        
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        // Set the map view's delegate
        mapView.delegate = self
        // Allow the map to display the user's location
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.styleURL = URL(string: "mapbox://styles/mapbox/light-v10")
        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
       // addNavButton()
        //saveTripButton()
        if(!SaveData.shared.shouldPrelode){
            searchBarField()
        }
    }
    
    // MARK: - Search
    
    func searchBarField(){
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = " Sök..."
        searchBar.sizeToFit()
        
        searchBar.isTranslucent = true
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        let height = searchBar.heightAnchor.constraint(equalToConstant: 50)
        let topConst = searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64)
        let leftConst  = searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 0)
        let rightConst = searchBar.trailingAnchor.constraint(equalToSystemSpacingAfter: self.view.trailingAnchor, multiplier: 0)
        
        let searchConst = [height, topConst, leftConst, rightConst]
        NSLayoutConstraint.activate(searchConst)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searhResult = searchBar.text {
              let options = ForwardGeocodeOptions(query: searhResult)
            options.allowedScopes = [.address, .pointOfInterest]
            
            _ = geocoder.geocode(options) { (placemarks, attribution, error) in
                
                if let validPlace = placemarks{
                    self.placeArray = validPlace
                    self.tabelView()
                }
            }
        }
    }
    
    // MARK: - TabelView
    func tabelView(){
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = 100
        
        self.view.addSubview(tableView)
        let height = tableView.heightAnchor.constraint(equalToConstant: 300)
        let topConst = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 114)
        let leftConst  = tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 0)
        let rightConst = tableView.trailingAnchor.constraint(equalToSystemSpacingAfter: self.view.trailingAnchor, multiplier: 0)
        let tabelConst = [height, topConst, leftConst, rightConst]
        NSLayoutConstraint.activate(tabelConst)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        let place = placeArray[indexPath.row]
        cell.textLabel!.text = place.qualifiedName!

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placeArray[indexPath.row]
        searchFromTabelview(place: place)
    }
    
   
    
    func searchFromTabelview(place: GeocodedPlacemark){
        if let coordinate = place.location?.coordinate{
            mapView.setUserTrackingMode(.none, animated: true)
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            annotation.title = navigeringsTitel
            mapView.addAnnotation(annotation)
            calculateRoute(from: (mapView.userLocation!.coordinate), to: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (route, error) in
                if error != nil{
                    print("Error getting route")
                }
            }
        }
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
       
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = navigeringsTitel
        mapView.addAnnotation(annotation)
        
        // Calculate the route from the user's location to the set destination
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
    }
    
    // Calculate route to be used for navigation
    func calculateRoute(from originCord: CLLocationCoordinate2D,
                        to destinationCord: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        if (showButton){
            saveTripButton()
        }
        
        saveTripsFromCord(cord: destinationCord)
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: originCord, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCord, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCord, ne: originCord)
            let insets = UIEdgeInsets(top: 150, left: 150, bottom: 150, right: 150)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
            // Draw the route on the map after creating it
            if let direct = self.directionsRoute{
                   self.drawRoute(route: direct)
            }
            
            
            
        }
    }
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: UIColor(named: "textColor"))
            lineStyle.lineWidth = NSExpression(forConstantValue: 4)
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: directionsRoute!)
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
   // MARK: - UI

    
    func saveTripButton(){
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitle("Spara resa", for: .normal)
        searchButton.backgroundColor = UIColor(named: "navBarColor")
        searchButton.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        searchButton.layer.cornerRadius = 25
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        searchButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchButton.layer.shadowRadius = 5
        searchButton.layer.shadowOpacity = 0.3
        searchButton.addTarget(self, action: #selector(savedButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(searchButton)
        
        let height = searchButton.heightAnchor.constraint(equalToConstant: 50)
        let bottomConst = searchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60)
        let leftConst  = searchButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.leadingAnchor, multiplier: 0)
        let rightConst = searchButton.trailingAnchor.constraint(equalToSystemSpacingAfter: self.view.trailingAnchor, multiplier: 0)
        
        let buttonConst = [height, bottomConst, leftConst, rightConst]
        NSLayoutConstraint.activate(buttonConst)
    }
    
    
    @objc func buttonPressed(_ sender: UIButton){
        mapView.setUserTrackingMode(.none, animated: true)
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 57.7210, longitude: 12.9398)
        annotation.title = navigeringsTitel
        mapView.addAnnotation(annotation)
        
        calculateRoute(from: (mapView.userLocation!.coordinate), to: endCord) { (route, error) in
            if error != nil{
                print("Error getting route")
            }
        }
    }
    
    @objc func savedButtonPressed(_ sender: UIButton){
        if let cordinate = saveCord{
            let defaults = UserDefaults.standard
            defaults.set(cordinate, forKey: SaveData.shared.savedCordKey)
            performSegue(withIdentifier: "showSave", sender: nil)
        }
        
    }
    
    func saveTripsFromCord(cord: CLLocationCoordinate2D){
        let options = ReverseGeocodeOptions(coordinate: cord)
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            if let place = placemark.qualifiedName{
                self.saveCord = place
            }
        }
    }
    
    func startNavigationFromCell(){
        if let load = SaveData.shared.loadedDestination {
                let options = ForwardGeocodeOptions(query: load)
                options.allowedScopes = [.address, .pointOfInterest]
                _ = geocoder.geocode(options) { (placemarks, attribution, error) in
                    guard let placemark = placemarks?.first else {
                        return
                    }
                    let coordinate = placemark.location?.coordinate
                    
                            self.mapView.setUserTrackingMode(.none, animated: true)
                            let annotation = MGLPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
                            annotation.title = self.navigeringsTitel
                            self.mapView.addAnnotation(annotation)
                    self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: CLLocationCoordinate2D(latitude: coordinate!.latitude, longitude: coordinate!.longitude)) { (route, error) in
                                if error != nil{
                                    print("Error getting route")
                                }
                            }
                }
        }
    }
    
}
