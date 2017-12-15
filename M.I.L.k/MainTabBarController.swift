//
//  MainTabBarController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/14/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //THIS VARIABLE IS TEMPORARY NEEDS TO BE REMOVED
        var currentUser: (Any)? = nil
        //NEED TO DO: CHECK IF USER IS LOGGED IN TO DECIDE WHICH VIEW TO PRESENT
        if currentUser == nil {
            //if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController,animated:  true, completion: nil)
            }
            
            return
        }
        
        setupViewController()
    }
    
    func setupViewController(){
        
        //User is logged in
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}
