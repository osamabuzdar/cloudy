import Foundation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager{
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=98228f58dc5879bd94115e0b954b97e0&units=metric"
    let decoder = JSONDecoder()
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let url = "\(weatherUrl)&q=\(city)"
        performRequest(with: url)
    }
    func fetchWeatherWithLocation(latitude: Double, longitude: Double){
        let url = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: url)
    }
    func performRequest (with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if  let weather = self.parseJson(safeData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJson(_ weatherData: Data)-> WeatherModel?{
        do{
            let decode = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decode.weather[0].id
            let name = decode.name
            let temperature = decode.main.temp
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weatherModel
        } catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}
