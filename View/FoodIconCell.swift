//
//  FoodIconCell.swift
//  Expired
//
//  Created by Misiel on 2/20/23.
//

import Foundation
import UIKit

class FoodIconCell: UICollectionViewCell {
    static let identifier = "FoodIconCell"
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = frame.size.width / 2
        iv.layer.borderWidth = 1.5
        iv.layer.borderColor = UIColor.black.cgColor
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // Set the background view of the cell to a highlighted view.
                let view = UIView(frame: bounds)
                view.layer.cornerRadius = frame.size.width / 2
                view.layer.borderWidth = 3
                view.layer.borderColor = UIColor.black.cgColor
                selectedBackgroundView = view
                view.clipsToBounds = false
                selectedBackgroundView?.backgroundColor = UIColor.green.withAlphaComponent(0.6)
            } else {
                // Reset the background view of the cell to its original value.
                selectedBackgroundView = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("FoodIconCell error")
    }
    
    private func setupUI(){
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    func configure(with foodType: FoodImageType) {
        self.imageView.image = setFoodIcon(foodType: foodType)
    }
    
    private func setFoodIcon(foodType: FoodImageType) -> UIImage {
        switch foodType {
            case .fruit:
                return UIImage(named: "fruit")!
                
            case .veggie:
                return UIImage(named: "veggie")!
            
            case .drink:
                return UIImage(named: "drink")!
                
            case .meat:
                return UIImage(named: "meat")!
                
            case .fish:
                return UIImage(named: "fish")!
        }
    }
}
