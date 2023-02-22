//
//  HomeViewMode.swift
//  Expired
//
//  Created by Misiel on 2/17/23.
//

import Combine
import Foundation
import UIKit

class HomeViewModel {
    static let shared = HomeViewModel()
    
    private let defaults = UserDefaults.standard
    private let list_key = "food_list"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    var savedFoodItems: [FoodItem]!
    
    @Published var updateHome: ()!
    
    func getFoodItems() -> [FoodItem] {
        guard let retrivedList = defaults.data(forKey: self.list_key) else { return [] }
        let decodedList = try! decoder.decode([FoodItem].self, from: retrivedList)
        return decodedList
    }
    
    func addFoodItem(foodItem: FoodItem) {
        let savedList = self.getFoodItems()
        self.savedFoodItems = savedList
        self.savedFoodItems.append(foodItem)
        
        let encodedList = try! encoder.encode(savedFoodItems)
        defaults.set(encodedList, forKey: list_key)
        
        // add food item's notification
        self.addFoodItemNotification(with: foodItem)
        self.updateHome = ()
    }
    
    func removeFoodItem(removedFoodItem: FoodItem, updatedList: [FoodItem]) {
        let encodedList = try! encoder.encode(updatedList)
        defaults.set(encodedList, forKey: list_key)
        
        self.removeFoodItemNotification(foodId: removedFoodItem.uuidString)
        self.updateHome = ()
    }
    
    private func addFoodItemNotification(with foodItem: FoodItem) {
        // generating uniqueID to remove noti later
        let uuidString = UUID(uuidString: foodItem.foodName)?.uuidString ?? "notification_id"
        foodItem.setUniqueNotiId(uuidString: uuidString)
        
        // create noti content
        let content = UNMutableNotificationContent()
        content.title = "🤢 Throw It Out!"
        content.sound = .default
        content.body = "Your \(foodItem.foodName) has expired."
        
        // create the trigger with date
        let expDate = foodItem.expDate
        let expTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: expDate), repeats: false)
        
        // create a request with content and trigger and request to NotiCenter
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: expTrigger)
        UNUserNotificationCenter.current().add(request)
        
        // do the same with reminder date
        if let reminderDate = foodItem.reminderDate {
            let rmdrTrigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate), repeats: false)
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: rmdrTrigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func removeFoodItemNotification(foodId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [foodId])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [foodId])
    }
}
