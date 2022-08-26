import Foundation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel)
    
}

struct WeatherManager{
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=98228f58dc5879bd94115e0b954b97e0&units=metric"
    let decoder = JSONDecoder()
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let url = "\(weatherUrl)&q=\(city)"
        print(url)
        performRequest(urlString: url)
    }
    func performRequest (urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    if  let weather = self.parseJson(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJson(weatherData: Data)-> WeatherModel?{
        do{
            let decode = try decoder.decode(WeatherData.self, from: weatherData)
            let id          =      decode.weather[0].id
            let name        =      decode.name
            let temperature =      decode.main.temp
            
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weatherModel
        } catch{
            print(error)
            return nil
        }
        
    }
    
    
}
