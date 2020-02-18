//
//  DailyWeatherRowViewModel.swift
//  CombineWeatherApp
//
//  Created by Alina Protsiuk on 2/8/20.
//  Copyright © 2020 CoreValue. All rights reserved.
//

import Foundation

let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter
}()

let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    return formatter
}()

struct WeatherRowViewModel: Identifiable {
    private let item: List
    
    let id: UUID
  
    var temperature: String {
        if let tempDay = item.temp?.day,
            let tempNight = item.temp?.night {
            return "Day = " + String(format: "%.1f", convertToCelsium(kelvin: tempDay)) + " Cº, " + "Night = " + String(format: "%.1f", convertToCelsium(kelvin: tempNight)) + " Cº"
        } else {
            return String(format: "%.1f", 0.0)
        }
    }
    
    var title: String {
        guard let title = item.weather?.first?.main else { return "" }
        return title
    }
    
    var fullDescription: String {
        guard let description = item.weather?.first?.description?.capitalized else { return "" }
        return description
    }
    
    var icon: String? {
        return item.weather?.first?.icon
    }
    
    init(item: List, id: UUID) {
        self.item = item
        self.id = id
    }
    
    private func convertToCelsium(kelvin: Double) -> Double {
        return 300 - kelvin
    }
    
}

// Used to hash on just the day in order to produce a single view model for each
// day when there are multiple items per each day.
extension WeatherRowViewModel: Hashable {
    static func == (lhs: WeatherRowViewModel, rhs: WeatherRowViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
