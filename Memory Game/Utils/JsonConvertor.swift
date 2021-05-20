//
//  JsonConvertor.swift
//  Memory Game
//
//  Created by Paz Lavi  on 30/04/2021.
//

import Foundation
class JsonConvertor {
    
    static func arrayToJson(arrayObject: [Any]) -> String? {
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    
    
}
