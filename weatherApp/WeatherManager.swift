//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Nisa Aydin on 26.01.2024.
//


import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
    func didFailWithError(error:Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=e2476e18dfc403b8922e55d083c7d7cf&units=metric"
    
    var delegate:WeatherManagerDelegate?
  
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // 1. Create a URL
        if let url = URL(string: urlString){
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
               // Bu metot, URL üzerinden veri almak için bir görev oluşturur.
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
           
            // 4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        // verilerimizi bir JSON formatından ayrıştırmak için öncelikle derleyicimize verilerin nasıl yapılandırıldığını bildirmemiz lazım
        // Bu fonksiyon, JSON verilerini çözümleyerek bir WeatherModel nesnesi oluşturur.
        let decoder = JSONDecoder()
       // Bir JSONDecoder nesnesi oluşturulur. JSON verilerini çözmek için bu nesne kullanılır.
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //JSON verileri decode işlevi ile çözümlenir. Bu işlem try ve catch içinde yapılır.
    
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
           return weather
      
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   
}
