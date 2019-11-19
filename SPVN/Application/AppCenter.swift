//
//  AppCenter.swift
//  SPVN
//
//  Created by DuyDV on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation

protocol AppCenterProtocol {
    
}

final class AppCenter: AppCenterProtocol {
    
    /// For static instance
    static let shared = AppCenter()
    
    private (set) var mainFrame: MainFrame!
    
    init() {
        
        setupAppCenter()
    }
    
    // MARK: - Private methods
    private func setupAppCenter() {
        
        mainFrame   = MainFrame()
    }
}
