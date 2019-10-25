//
//  ChooseCityViewController.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

protocol ChooseCityViewControllerDelegate : AnyObject {
    func didAdd (newLocation : WeatherLocation)
}

class ChooseCityViewController: UIViewController {

    // MARK : Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK : Variables
    var allLOcations = [WeatherLocation]()
    var filteredLocations = [WeatherLocation]()
    var savedLocations : [WeatherLocation]?
    
    let userDefaults = UserDefaults.standard
    
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var delegate : ChooseCityViewControllerDelegate?
    
    
    // MARK : View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        
        navigationController?.navigationBar.isHidden = false
        
        loadLocationsFromCSV()
        
        setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFromUserDefaults()
        
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    private func setupSearchController () {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()

        searchController.isActive = true
    }
    
    private func setupTapGesture () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        tableView.backgroundView = UIView()
        tap.cancelsTouchesInView = false
        tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped () {
        dismissView()
    }
    
    // MARK : Get locations
    
    private func loadLocationsFromCSV () {
        
        if let path = Bundle.main.path(forResource: "locations", ofType: "csv") {
            parseCSV(URL(fileURLWithPath: path))
        } else {
            print("File with a specified name and type couldn't be found")
        }
    }
    
    private func parseCSV (_ path : URL) {
        
        do {
            let data = try Data(contentsOf: path)
            let encodedData = String(data: data, encoding: .utf8)
            
            if let dataArray = encodedData?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",") }) {
                for line in dataArray.dropFirst() {
                    if line.count > 2 {
                        createLocation(line)
                    }
                }
            }
        } catch {
            print("Error reading from csv file, \(error.localizedDescription)")
        }
    }
    
    private func createLocation (_ line : [String]) {
        allLOcations.append(WeatherLocation(city: line[0], country: line[1], countryCode: line[2], isCurrentLocation: false))
    }
    
    
    // MARK : User Defaults
    
    private func saveToUserDefaults ( _ location : WeatherLocation) {
        
        if var savedLocations = savedLocations {
            
            if !savedLocations.contains(location) {
                savedLocations.append(location)
                UserCongifuration.saveToUserDefaults(savedLocations, "Locations")
            }
        }
    }
    
    private func loadFromUserDefaults () {
        savedLocations = UserCongifuration.loadFromUserDefaults(key: "Locations")
    }
    
    private func dismissView () {
        if searchController.isActive {
            searchController.dismiss(animated: true)
        }
        self.dismiss(animated: true)
    }
}


// MARK : Search 

extension ChooseCityViewController : UISearchResultsUpdating {
    
    func filterContentForSearchText (_ searchText : String, _ scope : String = "All") {

        if searchText.count > 0 {
    
            filteredLocations = allLOcations.filter({ (location) -> Bool in
                
                return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
// MARK : TableView Stubs

extension ChooseCityViewController : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let location = filteredLocations[indexPath.row]

        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        saveToUserDefaults(filteredLocations[indexPath.row])

        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        
        dismissView()
    }
}
