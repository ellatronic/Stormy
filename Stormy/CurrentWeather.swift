//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Ella on 10/1/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Double
    let humidity: Double
    let precipitationProbabily: Double
    let summary: String
    let icon: UIImage
}

extension CurrentWeather: JSONDecodable {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temperature"] as? Double,
        let humidity = JSON["humidity"] as? Double,
        let precipitationProbabily = JSON["precipProbability"] as? Double,
        let summary = JSON["summary"] as? String,
        let iconString = JSON["icon"] as? String
        else {
                return nil
        }
        
        let icon = WeatherIcon(rawValue: iconString).image
        
        self.temperature = temperature
        self.humidity = humidity
        self.precipitationProbabily = precipitationProbabily
        self.summary = summary
        self.icon = icon
    }
}
