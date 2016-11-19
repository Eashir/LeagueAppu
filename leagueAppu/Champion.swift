//
//  Champion.swift
//  LeagueAppu
//
//  Created by Eashir Arafat on 11/19/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import Foundation

enum ChampionParseError: Error {
    case response, champ, name
}

class Champion {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func getChampion(from data: Data) -> [Champion]? {
        var Champions: [Champion]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            guard let response = jsonData as? [String: Any], //(("version", 6.22.1))
                  let data = response["data"] as? [String: Any] //(("Azir", { }))
                else { throw ChampionParseError.response }
            
            for (key, value) in data {
                //the keys are all the champion names
                
                guard let champ = data["\(key)"] as? [String: Any]
                    else { throw ChampionParseError.champ }
                
                guard let name = champ["name"] as? String
                    else { throw ChampionParseError.name}
                
                let validChampion = Champion(name: name)
                
                Champions?.append(validChampion)
                
            }
            
            return Champions
            
        }
            
        catch {
            print("Error! \(error)")
        }
        
        return nil
        
    }
}

/* MY EXAMPLE - This printed Azir
 
 let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
 guard let response = jsonData as? [String: Any],
 let data = response["data"] as? [String: Any],
 
 
 let azir = data["Azir"] as? [String: Any],
 
 
 let name = azir["name"] as? String
 
 
 else { throw ChampionParseError.response }
 print(name)
 
 
 //NAIMS EXAMPLE - This printed all values of data
 for dataDicts in response {
 if dataDicts.key == "data" {
 print(dataDicts.value)
 
 //dataDicts.value TYPE ANY
 
 }
 }
 */
