//
//  ViewController.swift
//  Expired
//
//  Created by Misiel on 2/9/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    private let padding = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.register(FoodCell.self, forCellReuseIdentifier: FoodCell.identifier)
        return tv
    }()
    
    /* Sample Data
        var savedFoodList : [FoodItem] = [
            FoodItem(foodName: "Steak",
                     expDate: Calendar.current.date(byAdding: .day, value: +1, to: Date())!,
                     reminderDate: Date(),
                     foodType: FoodImageType.meat),
            FoodItem(foodName: "Salmon",
                     expDate: Date(),
                     reminderDate: Date(),
                     foodType: FoodImageType.fish),
            FoodItem(foodName: "Apples",
                     expDate: Date(),
                     reminderDate: Date(),
                     foodType: FoodImageType.fruit),
        ]
    */
    var savedFoodList: [FoodItem] = HomeViewModel.shared.getFoodItems()
    
    lazy var isEmptyState = savedFoodList.isEmpty

    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationUserPermissions()
        setupUI()
        
        // ViewModel observables
        HomeViewModel.shared.$updateHome
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.savedFoodList = HomeViewModel.shared.getFoodItems()
                    if self?.savedFoodList.count == 0 {
                        self?.displayEmptyState()
                    }
                    else {
                        self?.displayFullState()
                        self?.tableView.reloadData()
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func requestNotificationUserPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                print("authorization granted")
            }
            else if let error = error {
                print("error occurred: \(error)")
            }
        })
    }

    private func displayEmptyState() {
        self.clearViews()
        
        let emptyHintText : UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            lbl.textColor = .lightGray
            lbl.textAlignment = .center
            lbl.numberOfLines = 2
            lbl.text = "Your food list is empty.\n Add one below:"
            return lbl
        }()
        
        let addFoodButton : UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .light, scale: .medium)
            button.setImage(UIImage(systemName: "plus.square", withConfiguration: largeConfig), for: .normal)
            button.addTarget(self, action: #selector(addFoodItem), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(emptyHintText)
        view.addSubview(addFoodButton)
        
        NSLayoutConstraint.activate([
            emptyHintText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding.top),
            emptyHintText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding.left),
            emptyHintText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding.right),
            emptyHintText.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            addFoodButton.topAnchor.constraint(equalTo: emptyHintText.bottomAnchor),
            addFoodButton.leadingAnchor.constraint(equalTo: emptyHintText.leadingAnchor, constant: padding.left),
            addFoodButton.trailingAnchor.constraint(equalTo: emptyHintText.trailingAnchor, constant: padding.right),
        ])
    }
    
    private func displayFullState() {
        self.clearViews()
        
        let addFoodButton: UIButton = {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .medium)
            button.setImage(UIImage(systemName: "plus.square", withConfiguration: largeConfig), for: .normal)
            button.addTarget(self, action: #selector(addFoodItem), for: .touchUpInside)
            return button
        }()
        
        let appTitle: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            lbl.text = "Food Expiry"
            lbl.backgroundColor = UIColor(red: 0.1, green: 0.5, blue: 0.7, alpha: 0.2)
            return lbl
        }()
        
        view.addSubview(tableView)
        view.addSubview(appTitle)
        view.addSubview(addFoodButton)
        
        NSLayoutConstraint.activate([
            appTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding.left),
            
            addFoodButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addFoodButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding.right),
            
            tableView.topAnchor.constraint(equalTo: appTitle.bottomAnchor, constant: padding.top),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding.left),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: padding.right),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: padding.bottom),
        ])
    }
    
    private func clearViews() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        if (isEmptyState) {
            displayEmptyState()
        }
        else {
            displayFullState()
        }
    }
    
    @objc private func addFoodItem() {
        navigationController?.pushViewController(AddFoodViewController(), animated: true)
    }

}

// MARK: - TableView Delegate/DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFoodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FoodCell.identifier, for: indexPath) as? FoodCell
            else { return UITableViewCell() }
        
        cell.configure(with: savedFoodList[indexPath.row])
        return cell
    }
    
    // swipe-to-delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the data source
            let removedFoodItem = savedFoodList[indexPath.row]
            self.savedFoodList.remove(at: indexPath.row)
            
            // Delete the row from the table view
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            HomeViewModel.shared.removeFoodItem(removedFoodItem: removedFoodItem, updatedList: self.savedFoodList)
        }
    }
    
}
