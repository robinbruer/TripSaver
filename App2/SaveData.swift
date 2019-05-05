//
//  SaveData.swift
//  App2
//
//  Created by Robin on 30/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//
import UIKit
import Foundation

class SaveData {
    static let shared = SaveData()

    public var loadedDestination: String?
    public var shouldPrelode = false
    var tripsArray = [SavedTrip]()
    var savedCord: String?
    let savedCordKey = "savedCord"
    let tripListKey = "tripsList"
    let tripsListImgKey = "tripListImg"
    
    
    init(){}
    
    func save() {
        var saveArray = [Dictionary<String, String>]()
        var saveImgArray = [Dictionary<String, Data>]()
        for trip in tripsArray {
            let dict = trip.tripDictionary()
            let imgDict = trip.tripImgDict()
            saveArray.append(dict)
            saveImgArray.append(imgDict)
        }
        let defaults = UserDefaults.standard
        defaults.set(saveArray, forKey: tripListKey)
        defaults.set(saveImgArray, forKey: tripsListImgKey)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        if let tripArray = defaults.array(forKey: tripListKey), let trippImgArray = defaults.array(forKey: tripsListImgKey){
            for (dict, imgDict) in zip(tripArray, trippImgArray) {
                let newTrip = SavedTrip(data: dict as! Dictionary<String, String>, imageData: imgDict as! Dictionary<String, Data>)
                tripsArray.append(newTrip)
            }
        }
    }
    
    func loadCord(){
        let defaults = UserDefaults.standard
        savedCord = defaults.string(forKey: savedCordKey)
    }
    
    func buttonDesign(button: UIButton){
        button.backgroundColor = UIColor(named: "navBarColor")
        button.setTitleColor(UIColor(named: "whiteColor"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
    }

}
