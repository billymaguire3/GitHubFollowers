//
//  FollowerListViewController.swift
//  GHFollowers
//
//  Created by William Maguire on 3/25/21.
//

import UIKit

class FollowerListViewController: UIViewController {

    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    
    var collectionView: UICollectionView!
    // Declaring the data source: has to know about our section and our items
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.resuseID)
    }
    
    func getFollowers() {
        // MARK: - New Swift 5 Result type of calling our network request
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let followers):
                self.followers = followers
                self.updateData()
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            // create cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.resuseID, for: indexPath) as! FollowerCell
            // configure follower from Follower Cell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        // use of calling from a background thread in our getFollowers function
        dataSource.apply(snapshot, animatingDifferences: true)
        // use of calling on Main thread
//        DispatchQueue.main.async {
//            self.dataSource.apply(snapshot, animatingDifferences: true) {
//                print("Successfully applied snapshot to Collection View")
//            }
//        }
    }
}






// MARK: - Old/Fundamental Way of calling our network request
//        NetworkManager.shared.getFollowers(for: username, page: 1) { (followers, errorMessage) in
//            guard let followers = followers else {
//                self.presentGFAlertOnMainThread(title: "Error", message: errorMessage!.rawValue, buttonTitle: "Ok")
//                return
//            }
//        print("Followers.count = \(followers.count)")
//        print("Followers Array = \(followers)")
