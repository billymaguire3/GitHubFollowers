//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by William Maguire on 3/23/21.
//

import UIKit

class SearchViewController: UIViewController {

    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    // Computed Property
    // Returns True if the text field is not empty due to bang operator
    var doesUsernameExist: Bool { return !usernameTextField.text!.isEmpty }
    
    // MARK: - Lifecycle Methods
    // Only gets called the first time the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    // Gets called every time we go back to the view and the view reappears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextField.text = ""
    }
    
    // MARK: - Buttons Delegates/Targets
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // Must use Obj-C when using #selector
    // This is our Passing Data Function
    // Step 1: Create the Object
    // Step 2: Configure the data I want to pass
    // Step 3: Push the View Controller onto the stack
    @objc func pushFollowerListVC () {
        guard doesUsernameExist else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please Enter a Username! 🙃", buttonTitle: "Ok ")
            return
        }
        usernameTextField.resignFirstResponder()
        
        guard let userInput = usernameTextField.text else { return }
        let followerListVC = FollowerListViewController(username: userInput)
//        followerListVC.username = usernameTextField.text
//        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    // MARK: - UI Configurations
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.ghLogo
        
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([ // Y coordinate
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // X coordinate
            logoImageView.heightAnchor.constraint(equalToConstant: 200), // Height
            logoImageView.widthAnchor.constraint(equalToConstant: 200) // Width
        ])
    }
    
    func configureTextField() {
        view.addSubview(usernameTextField)
        
        // Setting the delegate
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50), // new way of doing the width
            usernameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Pass the data to the next screen
        pushFollowerListVC()
        return true
    }
}
