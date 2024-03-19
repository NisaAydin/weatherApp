//
//  ViewController.swift
//  weatherApp
//
//  Created by Nisa Aydin on 25.01.2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    // UITextFieldDelegate, UITextField sınıfının etkileşimlerini izlemek ve kontrol etmek için kullanılan bir protokoldür.
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate=self
        // Text field ViewControlleri bilgilendirir demek.
        locationManager.requestWhenInUseAuthorization()
        // kullanıcıdan konumunu kullanmak için izin istemeli
        locationManager.requestLocation()
        // Bir kere konum alması yeterlidir.
        weatherManager.delegate=self
        searchTextField.delegate=self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate {
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // IbAction gibi go butonu tetiklenince yapılacaklar
        searchTextField.endEditing(true) // kullanıcı go butonuna basınca klavyeyi kapatır.
        
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Kullanıcı metin alanından çıkmaya çalıştığında tetiklenir.Eğer true döndürürse metin alanından çıkmaya izin verir. Bu bir metin alanının düzenleme durumundan çıkarken yapılması gereken ek kontroller için uygundur.
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type something"
            return false
        }
            
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
    
        searchTextField.text = ""
    }
 
    
}

// MARK: - WeatherManagerDelegate


extension WeatherViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat , longitude: lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
        
    }
   

}


