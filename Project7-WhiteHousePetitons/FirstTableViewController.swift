//
//  FirstTableViewController.swift
//  project7
//
//  Created by 李沐軒 on 2019/3/17.
//  Copyright © 2019 李沐軒. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController {
    
    var petitions = [Petition]()
    var searches = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        
        let clearButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clearKeyword))
        
        
        navigationItem.leftBarButtonItems = [searchButton, clearButton]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(openInfo))
        
        
        let urlStr: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlStr = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlStr = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlStr) {
            if let data = try? Data(contentsOf: url) {
                parsing(json: data)
                return
            }
        }
        
        showError()
        
    }
    
    @objc func clearKeyword() {
        let ac = UIAlertController(title: "Cancel search with keyword", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            self.searches = self.petitions
            self.tableView.reloadData()
            
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    @objc func search() {
        let ac = UIAlertController(title: "search for key word", message: nil, preferredStyle: .alert)
        
        ac.addTextField(configurationHandler: nil)
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] (_) in
            guard let input = ac?.textFields?[0].text, case input.isEmpty = false else { return }
            
            self?.addIntoList(input)
            
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    func addIntoList(_ input: String) {
        let lowerInput = input.lowercased()
        
        searches.removeAll(keepingCapacity: true)
        
        for petition in petitions {
            if petition.title.lowercased().contains(lowerInput) || petition.body.lowercased().contains(lowerInput) {
                
                searches.append(petition)
                
            }
        }
        
        if searches.isEmpty {
            searches = petitions
            errorMessage(title: "No results", message: "Can't find any petition with keyword")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    func errorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func openInfo() {
        let ac = UIAlertController(title: "We the People", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Erron in loading, please check out and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    func parsing(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            searches = petitions
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searches.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = searches[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = searches[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
}
