//
//  AppDelegate.swift
//  MVVM
//
//  Created by Fabijan Bajo on 25/05/2017.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize the window (not using Storyboards)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        
        // Allocate navigation controller and tabbar
        let tabBarC = UITabBarController()
        let navC = UINavigationController(rootViewController: tabBarC)
        let movieResultsVC = ResultsViewController()
        movieResultsVC.viewModel = MovieViewModel()
        tabBarC.setViewControllers([movieResultsVC], animated: false)
        
        // Configure style
        navC.navigationBar.barStyle = .black
        tabBarC.tabBar.barStyle = .black
        
        // Set window's root and make visible
        window!.rootViewController = navC
        window!.makeKeyAndVisible()
        
        return true
    }
}

