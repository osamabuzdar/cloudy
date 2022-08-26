
//   let weatherModel = try? newJSONDecoder().decode(WeatherModel.self, from: jsonData)

import Foundation

// MARK: - WeatherModel
struct WeatherData: Codable {
    let weather: [Weather]
    let name: String
    let main: Main
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let icon: String
    let description: String
}


// MARK: - Main
struct Main: Codable {
    let temp:Double
    let pressure:Int
    let humidity: Int
}

