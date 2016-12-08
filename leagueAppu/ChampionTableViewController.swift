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

    var pixelColor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endPoint = "https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=all&api_key=RGAPI-d738917d-a306-4003-92a0-c00f74a49fab"
        self.title = "Champions"
        APIRequestManager.manager.getData(endPoint: endPoint) { (data: Data?) in
            if let validData = data,
                let validChampions = Champion.getChampion(from: validData) {
                self.Champions = validChampions
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    
    func getPixelColor(pos: CGPoint, uiImage: UIImage) -> UIColor {
        
        let ciImage = CIImage(image: uiImage)
        let CGImage = convertCIImageToCGImage(inputImage: ciImage!)
        
        let pixelData = CGImage?.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(uiImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Champions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "championCell", for: indexPath) as! ChampionTableViewCell
        
        //These make the cells take up the entire cell space
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let champion = Champions[indexPath.row]
        
        cell.championLabel.text = champion.name
        
        
      
        
        APIRequestManager.manager.getData(endPoint: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(champion.name)_1.jpg") { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                // Getting a color value from validImage
                var color = self.getPixelColor(pos: CGPoint(x: 100 , y: 100), uiImage: validImage)
        
                var pixelColor = color
                DispatchQueue.main.async {
                    cell.championSkin.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        
        APIRequestManager.manager.getData(endPoint: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(champion.name)_0.jpg") { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.championSplash.image = validImage
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
            dvc.champion?.uiColor = pixelColor
            
        }
    }


}
