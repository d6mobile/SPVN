//
//  SPVNDefault.swift
//  SPVN
//
//  Created by ntq on 11/20/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//


import Foundation

protocol SPVNDefaultProtocol {
    
}

final class SPVNDefault: SPVNDefaultProtocol {
    
    func saveObjectUserDefault(key: String, value: Any) {
        UserDefaults.standard.removeObject(forKey: key)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func deleteObjectUserDefault(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getObjectUserDefault(key: String) -> Any? {
        guard let data = UserDefaults.standard.data(forKey: key), let object = NSKeyedUnarchiver.unarchiveObject(with: data) else {
            return nil
        }
        
        return object
    }
}
