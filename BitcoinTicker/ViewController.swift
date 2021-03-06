//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Anshul Kapoor on 23/01/2016.
//  Copyright © 2016 Anshul Kapoor. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        getWeatherData(url: finalURL)
    }
    
    
    func getWeatherData(url : String){
        
        Alamofire.request(url, method : .get).responseJSON{
            response in
            if response.result.isSuccess{
                print("Success! Got the Price Data")
                
                let priceJSON : JSON = JSON(response.result.value!)
                self.updatePriceData(json: priceJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updatePriceData(json: JSON){
        if let tempResult = json["last"].double{
            bitcoinPriceLabel.text = String(tempResult)
        } else{
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
}
