//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Duy Pham on 08/22/2017.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {

    let productId = "com.duykhac.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        "Change your thoughts and you change your world. — Norman Vincent Peale",
        "No act of kindness, no matter how small, is ever wasted. – Aesop",
        "Today i choose life. Every morning when i wake up i can choose joy, happiness, negativity, pain... To feel the freedom that comes from being able to continue to make mistakes and choices - today i choose to feel life, not to deny my humanity but embrace it. – Kevyn Aucoin",
        "Happiness is not something you postpone for the future; it is something you design for the present. — Jim Rohn",
        "Health is the greatest gift, contentment the greatest wealth, faithfulness the best relationship. – Buddha",
        "I can't change the direction of the wind, but i can adjust my sails to always reach my destination. – Jimmy Dean"
    ]
    
    let premiumQuotes = [
        "It is during our darkest moments that we must focus to see the light. ― Aristotle",
        "Put your heart, mind, and soul into even your smallest acts. This is the secret of success. – Swami Sivananda",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "The best preparation for tomorrow is doing your best today. — H. Jackson Brown, Jr.",
        "The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart. – Helen Keller"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        SKPaymentQueue.default().add(self)

        if isPurchased() {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - In-App Purchase Methods

    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            //can't make payments
            print("User can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment successful
                print("Transaction successful!")
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                //Payment failed
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                showPremiumQuotes()
                print("Transaction restored")
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        UserDefaults.standard.set(true, forKey: productId)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productId)
        if purchaseStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
