//
//  SortViewController.swift
//  NewsApp
//
//  Created by XP on 9/25/19.
//  Copyright © 2019 XP. All rights reserved.
//

import UIKit

class SortCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var categoryPickerView: UIPickerView!

    // MARK: - Variables
    let categoryArray = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    var selected: String {
        return UserDefaults.standard.object(forKey: "category") as? String ?? "general"
    }
    
    // MARK: - Life cycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        // Show chosen row
        if let row = categoryArray.firstIndex(of: selected) {
            categoryPickerView.selectRow(row, inComponent: 0, animated: false)
        }
        
    }
    
    // MARK: - Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    // MARK: - Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(categoryArray[row], forKey: "category")
    }

}
