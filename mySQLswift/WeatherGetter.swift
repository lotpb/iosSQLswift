//
//  WeatherGetter.swift
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


// MARK: WeatherGetterDelegate
// ===========================
// WeatherGetter should be used by a class or struct, and that class or struct
// should adopt this protocol and register itself as the delegate.
// The delegate's didGetWeather method is called if the weather data was
// acquired from OpenWeatherMap.org and successfully converted from JSON into
// a Swift dictionary.
// The delegate's didNotGetWeather method is called if either:
// - The weather was not acquired from OpenWeatherMap.org, or
// - The received weather data could not be converted from JSON into a dictionary.
protocol WeatherGetterDelegate {
  func didGetWeather(weather: Weather)
  func didNotGetWeather(error: NSError)
}


// MARK: WeatherGetter
// ===================

class WeatherGetter {
  
  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
  private let openWeatherMapAPIKey = "1127e4e33e59268a6c3a77fcd1811356"
 
  private var delegate: WeatherGetterDelegate
  
  
  // MARK: -
  
  init(delegate: WeatherGetterDelegate) {
    self.delegate = delegate
  }
  
  func getWeather(city: String) {
    
    // This is a pretty simple networking task, so the shared session will do.
    let session = NSURLSession.sharedSession()
    
    let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
    
    // The data task retrieves the data.
    let dataTask = session.dataTaskWithURL(weatherRequestURL) {
      (data: NSData?, response: NSURLResponse?, error: NSError?) in
      if let networkError = error {
        // Case 1: Error
        // An error occurred while trying to get data from the server.
        self.delegate.didNotGetWeather(networkError)
      }
      else {
        print("Success")
        // Case 2: Success
        // We got data from the server!
        do {
          // Try to convert that data into a Swift dictionary
          let weatherData = try NSJSONSerialization.JSONObjectWithData(
            data!,
            options: .MutableContainers) as! [String: AnyObject]

          // If we made it to this point, we've successfully converted the
          // JSON-formatted weather data into a Swift dictionary.
          // Let's now used that dictionary to initialize a Weather struct.
          let weather = Weather(weatherData: weatherData)
          
          // Now that we have the Weather struct, let's notify the view controller,
          // which will use it to display the weather to the user.
          self.delegate.didGetWeather(weather)
        }
        catch let jsonError as NSError {
          // An error occurred while trying to convert the data into a Swift dictionary.
          self.delegate.didNotGetWeather(jsonError)
        }
      }
    }
    
    // The data task is set up...launch it!
    dataTask.resume()
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
