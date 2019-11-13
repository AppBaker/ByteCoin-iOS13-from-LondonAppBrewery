//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        indicator = UIActivityIndicatorView()
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.color = .white
        
        
        // Do any additional setup after loading the view.
    }
    
    
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.7
        }
        indicator.startAnimating()
        let currentCurrency = coinManager.currencyArray[row]
        print(currentCurrency)
        coinManager.getCoinPrice(for: currentCurrency)
    }
}

extension ViewController: BitcoinCostDelegate {
    
    func getBitcoinCost(bitcoinModel: BitcoinModel) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.view.alpha = 1
            }
            self.currencyLabel.text = bitcoinModel.currency
            self.bitcoinLabel.text = String(format: "%.2f", bitcoinModel.cost)
            self.indicator.stopAnimating()
        }
    }
    
    func didFailWithError(with error: Error) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.view.alpha = 1
            }
            self.indicator.stopAnimating()
            let alertController = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
