//
//  ForecastClient.swift
//  Stormy
//
//  Created by Ella on 10/6/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

enum Forecast {
    case Current(token: String, coordinate: Coordinate)
    
    var baseURL: NSURL {
        return NSURL(string: "https://api.darksky.net")!
    }
    
    var path: String {
        switch self {
        case .Current(let token, let coordinate):
            return "/forecast/\(token)/\(coordinate.latitude),\(coordinate.longitude)"
        }
    }
    
    var request: NSURLRequest {
        let url = NSURL(string: path, relativeTo: baseURL as URL)!
        return NSURLRequest(url: url as URL)
    }
}

final class ForecastAPIClient: APIClient {

    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    private let token: String
    
    init(config: URLSessionConfiguration, APIKey: String) {
        self.configuration = config
        self.token = APIKey
    }
    
    convenience init(APIKey: String) {
        self.init(config: URLSessionConfiguration.default, APIKey: APIKey)
    }
    
    func fetchCurrentWeather(coordinate: Coordinate, completion: (APIResult<CurrentWeather>) -> Void) {
        let request = Forecast.Current(token: self.token, coordinate: coordinate).request
        
        fetch(request: request, parse: { json -> CurrentWeather? in
            if let currentWeatherDictionary = json["currently"] as? [String : AnyObject] {
                return CurrentWeather(JSON: currentWeatherDictionary)
            } else {
                return nil
            }
            }, completion: completion)
    }
}
