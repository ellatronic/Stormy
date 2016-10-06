//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 4/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

extension CurrentWeather {
    var temperatureString: String {
        return "\(Int(temperature))º"
    }
    
    var humidityString: String {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    
    var precipitationProbabilityString: String {
        let percentageValue = Int(precipitationProbabily * 100)
        return "\(percentageValue)%"
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var forecastAPIClient = ForecastAPIClient(APIKey: "ADD YOUR API KEY HERE")
    let coordinate = Coordinate(latitude: 37.8267, longitude: -122.423)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather() {
        forecastAPIClient.fetchCurrentWeather(coordinate: coordinate) { result in
            self.toggleRefreshAnimation(on: false)
            
            switch result {
            case .Success(let currentWeather):
                DispatchQueue.main.async {
                    self.display(weather: currentWeather)
                }
            case .Failure(let error as NSError):
                DispatchQueue.main.async {
                    self.showAlert(title: "Unable to retrieve forecast", message: error.localizedDescription)
                }
            default:
                break
            }
        }
    }
    
    func display(weather: CurrentWeather) {
        currentTemperatureLabel.text = weather.temperatureString
        currentPrecipitationLabel.text = weather.precipitationProbabilityString
        currentHumidityLabel.text = weather.humidityString
        currentSummaryLabel.text = weather.summary
        currentWeatherIcon.image = weather.icon
    }
    
    func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
    
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func refreshWeather(_ sender: AnyObject) {
        toggleRefreshAnimation(on: true)
        fetchCurrentWeather()
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

