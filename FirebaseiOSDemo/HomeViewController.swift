//
//  HomeViewController.swift
//  FirebaseiOSDemo
//
//  Created by Raja Tamil on 2019-07-13.
//  Copyright © 2019 Raja Tamil. All rights reserved.
//

import UIKit
import FirebaseUI

public var auth = Auth.auth()


class HomeViewController: UIViewController {
    
    let authUI = FUIAuth.defaultAuthUI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let providers: [FUIAuthProvider] = [FUIFacebookAuth()]
        self.authUI!.providers = providers
        
        auth.addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(self.signOutButtonPressed))
                
                self.showProfileView(user:user)
            } else {
                
                self.showLoginScreen()
            }
            
        }
        
        
    }
    
    
    @objc func signOutButtonPressed() {
        
        do {
            try authUI?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func showProfileView(user:User) {
        
        if let userProfileImg = user.photoURL {
            let img = UIImageView()
            
            if let data = try? Data(contentsOf: userProfileImg) {
                img.image = UIImage(data: data)
            }
            img.frame = CGRect(x:view.frame.size.width / 2 - 50, y:150, width:100, height:100)
            img.layer.cornerRadius = 50
            img.clipsToBounds = true
            view.addSubview(img)
        }
        
        if let userTitle = user.displayName {
            let title = UILabel()
            title.text = userTitle
            title.frame = CGRect(x:0, y:250, width:view.frame.size.width, height:40)
            title.textAlignment = .center
            title.font = UIFont.systemFont(ofSize: 20)
            view.addSubview(title)
        }
        
        let providerTitle = UILabel()
        providerTitle.text = "Logged in via: \(user.providerData[0].providerID)"
        providerTitle.frame = CGRect(x:0, y:275, width:view.frame.size.width, height:40)
        providerTitle.textAlignment = .center
        providerTitle.font = UIFont.systemFont(ofSize: 16)
        providerTitle.textColor = .gray
        view.addSubview(providerTitle)
        
    }
    
    
    func showLoginScreen() {
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
        
    }
    
}

extension FUIAuthBaseViewController {
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.title = "Login"
    }
}
