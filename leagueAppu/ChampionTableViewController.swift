//
//  ChampionTableViewController.swift
//  LeagueAppu
//
//  Created by Eashir Arafat on 11/19/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class ChampionTableViewController: UITableViewController {

    var Champions: [Champion] = []
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Champions"
        APIRequestManager.manager.getData(endPoint: "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=RGAPI-d738917d-a306-4003-92a0-c00f74a49fab") { (data: Data?) in
            if let validData = data,
                let validChampions = Champion.getChampion(from: validData) {
                self.Champions = validChampions
                //Sorting champions
                for eachChampion in validChampions {
                    self.names.append(eachChampion.name)
                }
                self.names.sort{$1 > $0}
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
            
            
        }
      
       
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Champions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "championCell", for: indexPath) as! ChampionTableViewCell
        
        //These make the cells take up the entire cell space
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        //let champion = Champions[indexPath.row]

        cell.championLabel?.text = names[indexPath.row]
        
        
        APIRequestManager.manager.getData(endPoint: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(names[indexPath.row])_2.jpg") { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.championSplash.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        APIRequestManager.manager.getData(endPoint: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(names[indexPath.row])_1.jpg") { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.championSkin.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DetailViewController,
            let cell = sender as? ChampionTableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            dvc.champion = Champions[indexPath.row]
            
            
        }
    }
    
    
}
