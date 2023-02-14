/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import Alamofire
import Foundation
import SwiftyJSON

class CurrentWeather {
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Download Current Weather Data
        Alamofire.request(FORECAST_URL).responseJSON(queue: .global(qos: .utility)) { result in
            if let result = result.data, let formattedJson = try? JSONSerialization.jsonObject(with: result, options: []) as? NSDictionary, let json = try? JSON(data: result) {
                
                print(formattedJson);
                
                ShellTextVC.delegate?.print("The country name is: \(json["sys"]["country"].stringValue)", color: .green, global: true);
                ShellTextVC.delegate?.print("The city name is: \(json["name"].stringValue)", color: .green, global: true);
                //ShellTextVC.delegate?.print("The city timezone is: \(Date(timeIntervalSince1970: json["timezone"].doubleValue))", color: .green, global: true);
                ShellTextVC.delegate?.print("The sunrise is at: \(Date(timeIntervalSince1970: json["sys"]["sunrise"].doubleValue))", color: .green, global: true);
                ShellTextVC.delegate?.print("The sunset is at: \(Date(timeIntervalSince1970: json["sys"]["sunset"].doubleValue))", color: .green, global: true);
                ShellTextVC.delegate?.print("The current temperature is: \(json["main"]["temp"].doubleValue.rounded())", color: .green, global: true);
                ShellTextVC.delegate?.print("The wind speed is: \(json["wind"]["speed"].doubleValue.rounded())", color: .green, global: true);
                ShellTextVC.delegate?.print("The humidity is: \(json["main"]["humidity"].doubleValue.rounded())", color: .green, global: true);
                ShellTextVC.delegate?.print("It feels like: \(json["main"]["feels_like"].doubleValue.rounded())", color: .green, global: true);
                for (_,value) in json["weather"] {
                    //print("\(key) -> \(value)");
                    ShellTextVC.delegate?.print("It is : \(value["main"].stringValue) outside", color: .green, global: true);
                }
                
            }
            completed();
        }
    }
}













