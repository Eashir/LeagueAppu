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
    
    func getPixelColor(pos: CGPoint, imagee: UIImage) -> UIColor {
        
        let ciImage = CIImage(image: imagee)
        let CGImage = convertCIImageToCGImage(inputImage: ciImage!)
        
        let pixelData = CGImage?.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(imagee.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
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
        
        let champion = Champions[indexPath.row]
        
        cell.championLabel?.text = champion.name
        cell.championLore?.text = champion.lore
        
        var pixelColor = champion.uiColor
        APIRequestManager.manager.downloadImage(urlString: "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(champion.name)_1.jpg") { (data: Data?) in
            if  let validData = data,
                let validImage = UIImage(data: validData) {
                // Getting a color value from validImage
                var color = self.getPixelColor(pos: CGPoint(x: 100 , y: 100), imagee: validImage)
                pixelColor = color
                DispatchQueue.main.async {
                    cell.championSkin.image = validImage
                    cell.championLore?.textColor = pixelColor
                    cell.championLabel?.textColor = pixelColor
                    cell.setNeedsLayout()
                    
                }
            }
        
        }
        


        
                // Configure the cell...

        return cell
    }
    
    
}
