//
//  CustomTabBar.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 24.05.2023.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sürdürme işlemini gerçekleştir
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        // İlgili sayfaların atanmasını gerçekleştir
        if var viewControllers = self.viewControllers {
            if viewControllers.count >= 2 {
                // 1. sekme: PairListView
                if let pairListView = storyboard?.instantiateViewController(withIdentifier: "PairsListView") {
                    pairListView.tabBarItem = UITabBarItem(title: "Pairs", image: UIImage(named: "scatter.png"), tag: 0)
                    viewControllers[0] = pairListView
                }
                
                // 2. sekme: PairChartView
                if let pairChartView = storyboard?.instantiateViewController(withIdentifier: "AccountView") {
                    pairChartView.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "male-user.png"), tag: 1)
                    viewControllers[1] = pairChartView
                }
                
                self.setViewControllers(viewControllers, animated: false)
            }
        }
    }
}

