import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var location = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        location.requestWhenInUseAuthorization()
        location.requestLocation()
    }
    
    @IBAction func onCurrentLocation(_ sender: UIButton) {
        location.requestLocation()
        print("location get through button")
    }
}

//MARK: - UITextFieldDelegation

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func onSearchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Please Enter City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(city: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.computedTemperature
            self.conditionImageView.image = UIImage(systemName: weather.computedConditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - LocationManager

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last{
            location.stopUpdatingLocation()
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            weatherManager.fetchWeatherWithLocation(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

//https://www.mapdevelopers.com/geocode_tool.php?lat=30.22923&lng=71.5209968
