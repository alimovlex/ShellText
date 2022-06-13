//
//  CurrentWeather.swift
//  rainyshinycloudy
//
//  Created by alimovlex on 7/27/16.
//  Copyright © 2021 alimovlex. All rights reserved.
//

import Alamofire
import Foundation

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Download Current Weather Data
        ShellTextVC.delegate?.print("REQUESTING WEATHER DATA!!!", color: .green, global: true);
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                for (key, value) in dict {
                    ShellTextVC.delegate?.print("\(key) -> \(value)", color: .green, global: true);
                }
                
            }
            completed();
        }
        }
}













