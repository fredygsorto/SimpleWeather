//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Fredy Sorto on 5/7/22.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mainScreenBackground: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var topClothing: UIImageView!
    @IBOutlet weak var bottomClothing: UIImageView!
    @IBOutlet weak var footwearClothing: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "06507f55fe059590bdb7199e133e894c"
    var lat = 40.7128
    var lon = 74.0060
    var activityIndicator:  NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    var clothes: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        backgroundView.layer.addSublayer(gradientLayer)
        
        func parseJSON(weatherData: Data){
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                print(decodedData.main.temp)
            } catch{
                print(error)
            }
        }
        
        
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 3...11:
                mainScreenBackground.image = UIImage(named: "after_noon")
            case 12...17:
                mainScreenBackground.image = UIImage(named: "after_noon")
            default:
                mainScreenBackground.image = UIImage(named: "night")
        }
        
        
        let indicatorSize: CGFloat = 70
                let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
                activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
                activityIndicator.backgroundColor = UIColor.black
                view.addSubview(activityIndicator)


        locationManager.requestWhenInUseAuthorization()
                
                activityIndicator.startAnimating()
                if(CLLocationManager.locationServicesEnabled()){
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.startUpdatingLocation()
                }

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        setBlueGradientBackground()
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations[0]
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial").responseJSON {
                response in
                self.activityIndicator.stopAnimating()
                if let responseStr = response.result.value {
                    let jsonResponse = JSON(responseStr)
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonTemp = jsonResponse["main"]
                    let iconName = jsonWeather["icon"].stringValue
                    
                    self.locationLabel.text = jsonResponse["name"].stringValue
                    self.conditionImageView.image = UIImage(named: iconName)
                    self.conditionLabel.text = jsonWeather["main"].stringValue
                    self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    self.dayLabel.text = dateFormatter.string(from: date)
                    
                    //prints out the lat and lon of user location
//                    print(self.lat)
//                    print(self.lon)
//                    print("Curren temperature: \(jsonTemp["temp"])")
                    
//                    if (jsonTemp["temp"]) <= 90 {
//                        print("Sweater")
//                    } else {
//                        print("Jacket")
//                    }
                    
                    let clothes = (Int(round(jsonTemp["temp"].doubleValue)))
                    let weatherCondition = jsonWeather["main"].stringValue
                    
                    print(clothes) // prints out the temperature status for clothes
                    print(jsonWeather["main"].stringValue)// prints out the status weather
                    
                    switch clothes{
                        case 10..<40: //temperature ranges
                            switch weatherCondition{
                                
                            case "Rain", "Drizzle", "Thunderstorm":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                                
                            case "Snow":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                                
                            default:
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "sneakers")
                            }
                        case 40..<50: //temperature ranges
                            switch weatherCondition{
                           
                            case "Rain", "Drizzle", "Thunderstorm":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            case "Snow":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            default:
                                print("")//replace with UI display
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "sneakers")
                            }
                        case 50..<60: //temperature ranges
                            switch weatherCondition{
                                
                            case "Rain", "Drizzle", "Thunderstorm":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            case "Snow":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            default:
                                self.topClothing.image = UIImage(named: "hoodie" )
                                self.bottomClothing.image = UIImage(named: "jeans")
                                self.footwearClothing.image = UIImage(named: "sneakers")
                            }

                        case 60..<70:
                            switch weatherCondition{
                               
                            case "Rain", "Drizzle", "Thunderstorm":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            case "Snow":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            default:
                                self.topClothing.image = UIImage(named: "hoodie" )
                                self.bottomClothing.image = UIImage(named: "jeans")
                                self.footwearClothing.image = UIImage(named: "sneakers")
                                //replace with UI display

                            }

                        case 70..<80:
                            switch weatherCondition{
                                
                            case "Rain", "Drizzle", "Thunderstorm":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            case "Snow":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            default:
                                self.topClothing.image = UIImage(named: "collared_shirt")
                                self.bottomClothing.image = UIImage(named: "short")
                                self.footwearClothing.image = UIImage(named: "sneakers")
                                }
                        
                        case 80..<100:
                            switch weatherCondition{
                                
                            case "Rain", "Drizzle", "Thunderstorm":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            case "Snow":
                                self.topClothing.image = UIImage(named: "jacket")
                                self.bottomClothing.image = UIImage(named: "jeans" )
                                self.footwearClothing.image = UIImage(named: "boots")
                            default:
                                self.topClothing.image = UIImage(named: "tanktop")
                                self.bottomClothing.image = UIImage(named: "short")
                                self.footwearClothing.image = UIImage(named: "sneakers")
                                }
                        
                        default:
                        break;
                    }
            
                    
                    

                }
            }
            self.locationManager.stopUpdatingLocation()
        }
    
    }
     
















                    //                    let suffix = iconName.suffix(1)
                    //                    if(suffix == "n"){
                    //                        self.setGreyGradientBackground()
                    //                    }else{
                    //                        self.setBlueGradientBackground()
                    //                    }
                    //    func setBlueGradientBackground(){
                    //            let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
                    //            let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
                    //            gradientLayer.frame = view.bounds
                    //            gradientLayer.colors = [topColor, bottomColor]
                    //        }
                    //
                    //    func setGreyGradientBackground(){
                    //            let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
                    //            let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
                    //            gradientLayer.frame = view.bounds
                    //            gradientLayer.colors = [topColor, bottomColor]
                    //        }
