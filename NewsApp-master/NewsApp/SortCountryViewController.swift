//
//  SortCountryViewController.swift
//  NewsApp
//
//  Created by XP on 9/26/19.
//  Copyright © 2019 XP. All rights reserved.
//

import UIKit

class SortCountryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    // MARK: - IBOutlet
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    // MARK: - Variables
    let countryArray = ["ae", "ar", "at", "au", "be", "bg", "br",
                        "ca", "ch", "cn", "co", "cu", "cz", "de",
                        "eg", "fr", "gb", "gr", "hk", "hu", "id",
                        "ie", "il", "in", "it", "jp", "kr", "lt",
                        "lv", "ma", "mx", "my", "ng", "nl", "no",
                        "nz", "ph", "pl", "pt", "ro", "rs", "ru",
                        "sa", "se", "sg", "si", "sk", "th", "tr",
                        "tw", "ua", "us", "ve", "za"]
    var selected: String {
        return UserDefaults.standard.object(forKey: "country") as? String ?? "ua"
    }

    // MARK: - Life cycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        // Show chosen row
        if let row = countryArray.firstIndex(of: selected) {
            countryPickerView.selectRow(row, inComponent: 0, animated: false)
        }

    }
    
    // MARK: - Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryArray[row]
    }
    
    // MARK: - Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(countryArray[row], forKey: "country")
    }
}
