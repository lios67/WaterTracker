//
//  ViewController.swift
//  WaterTracker
//
//  Created by Oscar lin on 4/13/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    var history:[History]=[]
    
    /*
    func bubbleSort(){
        for i in 0..<history.count{
            for k in 1..<history.count-i{
                if history[k].date<history[k-1].date{
                    let temp: WaterHistory = history[k-1]
                    history[k-1]=history[k]
                    history[k]=temp
                }
            }
        }
        history.reverse()
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "History"
        //bubbleSort()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        fetchHistory()
    }
    
    func fetchHistory() {
        //fetch data from Core Data to the tableview
        do{
            self.history = try context.fetch(History.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Unable to fetch Water History")
        }
    }

    
    func getCurrentDate() -> String{
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy"
        return dateFormatter.string(from: date as Date)
    }

    @IBAction func addName(_ sender: UIBarButtonItem) {
        // Declare Alert message
        let alert = UIAlertController(title: "New Amount", message: "Add a new amount", preferredStyle: .alert)
        // Create Add/Save button with action handler to accesss the data from text field
        let addAction = UIAlertAction(title: "Add", style: .default) {
            [unowned self] action in guard let textField = alert.textFields?.first, let waterVolume = textField.text else {
                    return
                }
            //
            if let volume = Double(waterVolume) {
                // The input string is a valid Double value
                print("The input string is a double: \(volume)")
                let date = getCurrentDate()
                print(date)
                print(history.count)
                if history.contains(where: {$0.date==date}) {
                    let currentValue = history.first(where: {$0.date==date})?.volume
                    history.first(where: {$0.date==date})?.volume = currentValue! + volume
                }else{
                    //Create a new History
                    let newHistory = History(context: self.context)
                    newHistory.volume=volume
                    newHistory.date=date
                    //save the data to Core Data
                    do{
                        try self.context.save()
                    }catch{
                        print("Unable to Save Water History")
                    }
                }
                //bubbleSort()
                //self.tableView.reloadData()
                fetchHistory()
            }else{
                // The input string is not a valid Double value
                print("The input string is not a double.")
                // Create new Alert when the input is not a double
                let errorMessage = UIAlertController(title: "ERROR", message: "A Number Was Not Entered", preferredStyle: .alert)
                // Create OK button with action handler
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                //Add OK button to a dialog message
                errorMessage.addAction(okAction)
                // Present Alert to
                self.present(errorMessage, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        // Add text field in the alert text box
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type in the amount of water in mL"
        })
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    //Function to change the style of the cell to subtitle
    func subtitleCell(text: String, detailText: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detailText
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myData=history[indexPath.row]
        let cell = subtitleCell(text: String(myData.volume) + "mL", detailText: myData.date!)
        return cell
    }
}
/*
class WaterHistory{
    var date: String
    var volume: Double
    init(date: String, volume: Double){
        self.date=date
        self.volume=volume
    }
}*/

