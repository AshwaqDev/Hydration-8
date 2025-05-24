//
//  HydrationModel.swift
//  Hydration
//
//  Created by Ashwaq on 24/04/1446 AH.
//

import Foundation

struct HydrationModel {
    var bodyWeight: Double
    var dailyGoal: Double {
        return bodyWeight * 0.03 // Example: 0.67 ounces per pound
    }
    var currentAmount: Double = 0.0
}

