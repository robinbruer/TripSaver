//
//  DisplayTripsTableViewController.swift
//  App2
//
//  Created by Robin on 26/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import UIKit
import MapboxGeocoder

class DisplayTripsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bakgroundColor")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SaveData.shared.tripsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! DisplayTripsTableViewCell
        
        let trips = SaveData.shared.tripsArray[indexPath.row]
        
        cell.destinationLabel.text = trips.destination
        cell.titelLabel.text = trips.titel
        let tripImg = UIImage(data: trips.image)
        cell.tripImageView.image = tripImg
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            SaveData.shared.tripsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            SaveData.shared.save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
                if let indexPath = self.tableView.indexPathForSelectedRow{
                    let trips = SaveData.shared.tripsArray[indexPath.row]
                    SaveData.shared.loadedDestination = trips.destination
                    SaveData.shared.shouldPrelode = true
                }
        }
    }

    
}
