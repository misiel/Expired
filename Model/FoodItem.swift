//
//  FoodItem.swift
//  Expired
//
//  Created by Misiel on 2/15/23.
//

import Foundation
import UIKit

class FoodItem: Codable {
    var foodName: String
    var expDate: Date
    var reminderDate: Date?
    var foodType: FoodImageType
    var uuidString: String = ""
    
    init(foodName: String, expDate: Date, reminderDate: Date?, foodType: FoodImageType) {
        self.foodName = foodName
        self.expDate = expDate
        self.reminderDate = reminderDate
        self.foodType = foodType
    }
    
    func setUniqueNotiId(uuidString: String) {
        self.uuidString = uuidString
    }
}

//MARK: -
enum FoodImageType: Codable, CaseIterable {
    case fruit
    case veggie
    case drink
    case meat
    case fish
}
