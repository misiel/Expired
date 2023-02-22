//
//  AddFoodViewController.swift
//  Expired
//
//  Created by Misiel on 2/17/23.
//

import Foundation
import UIKit

class AddFoodViewController: UIViewController {
    private let foodItems: [FoodImageType]  = FoodImageType.allCases
    private var isNameSet = false
    private var isIconSet = false
    
    // Values for new food item
    private var newFoodItem: FoodItem!
    private var selectedFoodType: FoodImageType!
    private var foodName: String!
    private var expDate: Date!
    private var reminderDate: Date!
    
    // global cv for constraints
    lazy var collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Add Food"
        view.backgroundColor = .white
        createSaveButton()
        displayIconCarousel()
        setupTextFields()
    }
    
    private func createSaveButton() {
        let rightBarBtn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveFood))
        navigationItem.rightBarButtonItem = rightBarBtn
        // enable this button when name and exp date are set
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func displayIconCarousel(){
        let collectionViewTitle: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            lbl.text = "Choose An Icon:"
            lbl.textAlignment = .center
            return lbl
        }()
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: view.frame.size.width/4, height: view.frame.size.height/8)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.dataSource = self
            cv.delegate = self
            cv.register(FoodIconCell.self, forCellWithReuseIdentifier: FoodIconCell.identifier)
            return cv
        }()
        
        view.addSubview(collectionViewTitle)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionViewTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionViewTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionViewTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

            collectionView.topAnchor.constraint(equalTo: collectionViewTitle.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
    
    private func setupTextFields() {
        let stackView: UIStackView = {
            let sv = UIStackView()
            sv.axis = .vertical
            sv.alignment = .fill
            sv.distribution = .fill
            sv.spacing = 20
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        
        let nameLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            lbl.text = "Name:"
            lbl.textAlignment = .center
            return lbl
        }()
        
        let nameTextField: UITextField = {
            let tf = UITextField()
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.placeholder = "mm..Food"
            tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            tf.borderStyle = .bezel
            tf.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            return tf
        }()
        
        let dateLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            lbl.text = "Expiration Date:"
            lbl.textAlignment = .center
            return lbl
        }()
        
        let datePicker: UIDatePicker = {
            let dp = UIDatePicker()
            dp.translatesAutoresizingMaskIntoConstraints = false
            dp.datePickerMode = .dateAndTime
            dp.addTarget(self, action:#selector(datePickerValueChanged), for: .valueChanged)
            return dp
        }()
        
        let reminderLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            lbl.text = "Set a Reminder:"
            lbl.textAlignment = .center
            return lbl
        }()
        
        let reminderPicker: UIPickerView = {
            let pv = UIPickerView()
            pv.translatesAutoresizingMaskIntoConstraints = false
            pv.delegate = self
            pv.dataSource = self
            return pv
        }()
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(reminderLabel)
        stackView.addArrangedSubview(reminderPicker)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            reminderPicker.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createNewFoodItem() {
        self.newFoodItem = FoodItem(foodName: self.foodName,
                               expDate: self.expDate,
                               reminderDate: self.reminderDate,
                               foodType: self.selectedFoodType)
    }
    
    @objc private func saveFood() {
        // create notifications with expdate and reminderdate
        createNewFoodItem()
        HomeViewModel.shared.addFoodItem(foodItem: newFoodItem)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        self.expDate = selectedDate
        navigationItem.rightBarButtonItem?.isEnabled = isNameSet && isIconSet
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if let textFieldText = sender.text {
            if textFieldText.count < 1 {
                isNameSet = false
            }
            else {
                isNameSet = true
                self.foodName = textFieldText
            }
        }
    }
}

// MARK: - Collection View
extension AddFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodIconCell.identifier, for: indexPath) as? FoodIconCell else { return UICollectionViewCell() }
        
        let foodType = foodItems[indexPath.row]
        cell.configure(with: foodType)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFoodType = foodItems[indexPath.row]
        self.isIconSet = true
    }
}

// MARK: - UIPicker
extension AddFoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // None, 3 day before, 1 week before, 2 weeks before
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
            case 0:
                return "None"
            case 1:
                return "3 Days Before"
            case 2:
                return "1 Week Before"
            case 3:
                return "2 Weeks Before"
            default:
                return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
            case 0:
                self.reminderDate = nil
            case 1:
                // 3 days before
                self.reminderDate = Calendar.current.date(byAdding: .day, value: -3, to: self.expDate)!
            case 2:
                // 1 week before
                self.reminderDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self.expDate)!
            case 3:
                // 2 weeks before
                self.reminderDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: self.expDate)!
            default:
                self.reminderDate = nil
        }
    }
    
}
