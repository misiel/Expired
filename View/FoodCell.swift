//
//  FoodCell.swift
//  Expired
//
//  Created by Misiel on 2/15/23.
//

import Foundation
import UIKit

class FoodCell: UITableViewCell {
    static let identifier = "FoodCell"
    var selectedFoodItem: FoodItem!
    
    let foodTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return lbl
    }()
    
    let expTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    let reminderTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    let foodIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 40
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.borderWidth = 1.5
        iv.layer.borderColor = UIColor.black.cgColor
        
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("couldn't init FoodCell")
    }
    
    private func setupUI(){
        contentView.addSubview(foodTitle)
        contentView.addSubview(expTitle)
        contentView.addSubview(reminderTitle)
        contentView.addSubview(foodIcon)
        
        NSLayoutConstraint.activate([
            foodTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            foodTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            expTitle.topAnchor.constraint(equalTo: foodTitle.bottomAnchor, constant: 10),
            expTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            reminderTitle.topAnchor.constraint(equalTo: expTitle.bottomAnchor),
            reminderTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            foodIcon.leadingAnchor.constraint(equalTo: expTitle.trailingAnchor, constant: 20),
            foodIcon.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            foodIcon.topAnchor.constraint(equalTo: foodTitle.topAnchor),
            foodIcon.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            foodIcon.widthAnchor.constraint(equalToConstant: 75),
            foodIcon.heightAnchor.constraint(equalToConstant: 75)
            
        ])
    }
    
    func configure(with foodItem: FoodItem) {
        self.selectedFoodItem = foodItem
        self.foodTitle.text = foodItem.foodName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let expString = dateFormatter.string(from: foodItem.expDate)
        self.expTitle.text = "Exp: \(expString)"
        if foodItem.expDate.compare(Date()) == .orderedAscending {
            self.expTitle.textColor = .red
        }
        if let reminderDate = foodItem.reminderDate {
            let rmdrString = dateFormatter.string(from: reminderDate)
            self.reminderTitle.text = "Rmdr: \(rmdrString)"
        }
        
        setFoodIcon(foodType: foodItem.foodType)
    }
    
    private func setFoodIcon(foodType: FoodImageType) {
        switch foodType {
            case .fruit:
                foodIcon.image = UIImage(named: "fruit")
                
            case .veggie:
                foodIcon.image = UIImage(named: "veggie")
            
            case .drink:
                foodIcon.image = UIImage(named: "drink")
                
            case .meat:
                foodIcon.image = UIImage(named: "meat")
                
            case .fish:
                foodIcon.image = UIImage(named: "fish")
        }
    }
}
