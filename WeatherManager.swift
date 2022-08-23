import Foundation

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=98228f58dc5879bd94115e0b954b97e0"
    let decoder = JSONDecoder()
    
    func getWeather(city: String){
        let url = "\(weatherUrl)&q=\(city)"
        print(url)
        performRequest(urlString: url)
    }
    
    func performRequest (urlString: String){
        //1. Create url
        if let url = URL(string: urlString){
            
            //2. Create URLSession
            let session = URLSession(configuration: .default)
            
            //3. Create task
            let task = session.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            
            //4. Start task
            task.resume()
        }
    }
    
    func handle(data: Data?, urlResponse: URLResponse?, error: Error?){
        if  error != nil{
            print(error ?? "exception thrown by weather handler")
            return
        }
        
        if let safeData = data {
            let stringData = String(data: safeData, encoding: .utf8)
            print(stringData!)
        }
    }
}
