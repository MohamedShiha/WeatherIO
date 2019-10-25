//
//  AllLocationsTableViewController.swift
//  WeatherIO
//
//  Created by Mohamed Shiha on 8/19/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate : AnyObject {

    func didChooseLocation(index : Int, shouldRefresh : Bool)
}

protocol TemperatureDataUpdaterDelegate : AnyObject {
    func updateAllTemperatureData()
}

class AllLocationsTableViewController: UITableViewController {
    
    
    // MARK : Outlets
    @IBOutlet weak var tempMeasuresSegmetedView: UISegmentedControl!
    @IBOutlet weak var footerView: UIView!
    
    // MARK : Variables
    
    var savedLocations : [WeatherLocation]?
    let userDefaults = UserDefaults.standard
    var allWeatherData : [CityTempData]?
    
    weak var delegate : AllLocationsTableViewControllerDelegate?
    weak var updaterDelegate : TemperatureDataUpdaterDelegate?
    var shouldUpdateAfterAdding = false
    
    // MARK : View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedLocations = UserCongifuration.loadFromUserDefaults(key: "Locations")
        tempMeasuresSegmetedView.selectedSegmentIndex = UserCongifuration.loadTemperatureFormat(key: "TempFormat")!
        navigationController?.navigationBar.isHidden = true
        tableView.tableFooterView = footerView
    }
    
    // MARK : Segmented Control Action
    
    @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempFormat(sender.selectedSegmentIndex)
        updateWeatherData()
        updaterDelegate?.updateAllTemperatureData()
    }
    
    
    @IBAction func navigateToAllLocations(_ sender: Any) {
        let chooseCityVC = storyboard?.instantiateViewController(identifier: "AllLocations") as! ChooseCityViewController
        navigationController?.pushViewController(chooseCityVC, animated: true)
    }
    
    private func updateTempFormat (_ newValue: Int) {
        UserCongifuration.saveTemperatureFormat(value: newValue, "TempFormat")
    }
    
    // Convert all temperatures when temperature metrics are changed
    private func updateWeatherData () {
        if var allWeatherData = allWeatherData {
            for i in 0..<allWeatherData.count {
                allWeatherData[i].temperature = getTemperature(celsius: allWeatherData[i].temperature)
            }
            self.allWeatherData = allWeatherData
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWeatherData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainWeatherTableViewCell
    
        if let allWeatherData = allWeatherData {
            cell.generateCell(allWeatherData[indexPath.row])
        }
        
        return cell
    }
    
    
    // MARK : TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if shouldUpdateAfterAdding {
            UserCongifuration.shouldRefresh = true
        } else {
            UserCongifuration.shouldRefresh = false
        }
        
        delegate?.didChooseLocation(index: indexPath.row, shouldRefresh: UserCongifuration.shouldRefresh)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let locationToDelete = allWeatherData?[indexPath.row]
            allWeatherData?.remove(at: indexPath.row)

            // Delete from userDefaults
            removeLocationFromSavedLocations(locationToDelete!.city)
            UserCongifuration.shouldRefresh = true
            delegate?.didChooseLocation(index: indexPath.row, shouldRefresh: UserCongifuration.shouldRefresh)
            tableView.reloadData()
        }
    }
    
    private func removeLocationFromSavedLocations (_ location : String) {
       
        if savedLocations != nil {
           
            for i in 0..<savedLocations!.count {
               
                let tempLocation = savedLocations![i]
                if tempLocation.city == location {
                    savedLocations?.remove(at: i)
                    
                    // Save to userDefaults
                    UserCongifuration.saveToUserDefaults(savedLocations!, "Locations")
                    return
                }
            }
        }
    }
    
    
    // MARK : Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationSeguo" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }
}


extension AllLocationsTableViewController : ChooseCityViewControllerDelegate {
    
    func didAdd(newLocation: WeatherLocation) {
        UserCongifuration.shouldRefresh = true
        shouldUpdateAfterAdding = true
        allWeatherData?.append(CityTempData(city: newLocation.city, temperature: 0.0))
        tableView.reloadData()
    }
}
