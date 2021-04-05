//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by William Maguire on 4/5/21.
//

import UIKit

class UserInfoViewController: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneButton
        
        guard let username = username else { return }
        
        print("username: \(username)")
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}
