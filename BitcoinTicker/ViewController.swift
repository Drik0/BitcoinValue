//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var selectedCurrency = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyBtn: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: currencyArray[row], attributes: [NSAttributedStringKey.foregroundColor :UIColor(red: 240.0/255.0, green: 167.0/255.0, blue: 52.0/255.0, alpha: 1.0)])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyBtn.setTitle(currencyArray[row], for: UIControlState.normal)
        selectedCurrency = symbolArray[row]
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getBitcoin(url: finalURL)
        currencyPicker.isHidden = true
    }
    
    @IBAction func currencyBtnPressed(_ sender: Any) {
        currencyPicker.isHidden = false
    }
    
    //MARK: - Networking
    /***************************************************************/

      func getBitcoin(url: String) {
        Alamofire.request(url)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Success")
                    let bitcoinJSON: JSON = JSON(response.result.value!)
                    self.updateBitcoin(json: bitcoinJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues!"
                }
            }
      }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoin(json : JSON) {
        if let temResult = json["last"].double {
            print(temResult)
            bitcoinPriceLabel.text = selectedCurrency + String(temResult)
        }
    }

}

