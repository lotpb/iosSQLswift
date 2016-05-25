//
//  Weather.swift
//  SimpleWeather
//
//  Created by Joey deVilla on 5/8/16.
//  MIT license. See the end of this file for the gory details.
//
//  Accompanies the article in Global Nerdy (http://globalnerdy.com):
//  "How to build an iOS weather app in Swift, part 3:
//  Giving the app a user interface"
//  http://www.globalnerdy.com/2016/05/08/how-to-build-an-ios-weather-app-in-swift-part-3-giving-the-app-a-user-interface/
//


import Foundation

struct Weather {
  
  let dateAndTime: NSDate
  
  let city: String
  let country: String
  let longitude: Double
  let latitude: Double
  
  let weatherID: Int
  let mainWeather: String
  let weatherDescription: String
  let weatherIconID: String
  
  // OpenWeatherMap reports temperature in Kelvin,
  // which is why we provide celsius and fahrenheit
  // computed properties.
  private let temp: Double
  var tempCelsius: Double {
    get {
      return temp - 273.15
    }
  }
  var tempFahrenheit: Double {
    get {
      return (temp - 273.15) * 1.8 + 32
    }
  }
  let humidity: Int
  let pressure: Int
  let cloudCover: Int
  let windSpeed: Double
  
  // These properties are optionals because OpenWeatherMap doesn't provide:
  // - a value for wind direction when the wind speed is negligible 
  // - rain info when there is no rainfall
  let windDirection: Double?
  let rainfallInLast3Hours: Double?
  
  let sunrise: NSDate
  let sunset: NSDate
  
  init(weatherData: [String: AnyObject]) {
    dateAndTime = NSDate(timeIntervalSince1970: weatherData["dt"] as! NSTimeInterval)
    city = weatherData["name"] as! String
    
    let coordDict = weatherData["coord"] as! [String: AnyObject]
    longitude = coordDict["lon"] as! Double
    latitude = coordDict["lat"] as! Double
    
    //let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
    //weatherID = weatherDict["id"] as! Int
    
    let weatherDict = (weatherData["weather"] as! [NSDictionary])[0] as! [String: AnyObject]
    weatherID = weatherDict["id"] as! Int
    mainWeather = weatherDict["main"] as! String
    weatherDescription = weatherDict["description"] as! String
    weatherIconID = weatherDict["icon"] as! String
    
    let mainDict = weatherData["main"] as! [String: AnyObject]
    temp = mainDict["temp"] as! Double
    humidity = mainDict["humidity"] as! Int
    pressure = mainDict["pressure"] as! Int
    
    cloudCover = weatherData["clouds"]!["all"] as! Int
    
    let windDict = weatherData["wind"] as! [String: AnyObject]
    windSpeed = windDict["speed"] as! Double
    windDirection = windDict["deg"] as? Double
    
    if weatherData["rain"] != nil {
      let rainDict = weatherData["rain"] as! [String: AnyObject]
      rainfallInLast3Hours = rainDict["3h"] as? Double
    }
    else {
      rainfallInLast3Hours = nil
    }
    
    let sysDict = weatherData["sys"] as! [String: AnyObject]
    country = sysDict["country"] as! String
    sunrise = NSDate(timeIntervalSince1970: sysDict["sunrise"] as! NSTimeInterval)
    sunset = NSDate(timeIntervalSince1970:sysDict["sunset"] as! NSTimeInterval)
  }
  
}


// This code is released under the MIT license.
// Simply put, you're free to use this in your own projects, both
// personal and commercial, as long as you include the copyright notice below.
// It would be nice if you mentioned my name somewhere in your documentation
// or credits.
//
// MIT LICENSE
// -----------
// (As defined in https://opensource.org/licenses/MIT)
//
// Copyright © 2016 Joey deVilla. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom
// the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.