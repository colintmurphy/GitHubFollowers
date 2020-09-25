//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class FollowerListVC: GFDataLoadingVC { /// inherit functions from this class
    
    // MARK: - Section enum
    
    enum Section { case main }
    
    // MARK: - Variables
    
    var username: String!
    var followers: [Follower]           = []
    var filteredFollowers: [Follower]   = []
    var page                            = 1
    var hasMoreFollowers                = true
    var isSearching                     = false
    var isLoadingMoreFollowers          = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    // MARK: - Inits
    
    init(username: String) {
        
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Load Info
    
    func getFollowers(username: String, page: Int) {
        
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    func updateUI(with followers: [Follower]) {
        
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😃."
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        self.updateData(on: self.followers)
    }
    
    func updateData(on followers: [Follower]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func addButtonTapped() {
        
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] results in
            
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch results {
            case .success(let user):
                self.addUserToFavorites(user: user)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func addUserToFavorites(user: User) {
        
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] (error) in
            
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success", message: "You've successfully favorited this user 🎉", buttonTitle: "Hooray!")
                return
            }
            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    // MARK: - Configure
    
    func configureViewController() {
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell else { fatalError("couldn't create FollowerCell") }
            cell.set(follower: follower)
            return cell
        })
    }
}

// MARK: - UICollectionViewDelegate

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY         = scrollView.contentOffset.y /// y coordinate
        let contentHeight   = scrollView.contentSize.height /// the entire scrollView (everything, all cells)
        let height          = scrollView.frame.size.height /// height of screen
        
        if offsetY > contentHeight - height { /// if at the bottom
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return } /// make sure more followers aren't currently in loading process
            
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeArray         = isSearching ? filteredFollowers : followers
        let follower            = activeArray[indexPath.item]
        
        let destinationVC       = UserInfoVC()
        destinationVC.username  = follower.login
        destinationVC.delegate  = self
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController)  {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers) /// when text empty, want to use all of followers
            isSearching = false
            return
        }
        
        isSearching         = true
        filteredFollowers   = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
}

// MARK: - UserInfoListVCDelegate

extension FollowerListVC: UserInfoListVCDelegate {
    
    func didRequestFollowers(for username: String) {
        
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}

/*
 
 EDUCATIONAL NOTES:
    - Memory Management in swift:
        - ARC (Automatic, Reference, Counting): keeps account of a reference
            - declare 1 object (var sean: Developer) <- reference count = 1
            - declare 2 objects that point to each other (sean has laptop, laptop has sean) <- reference count = 2 for BOTH objects
                - objects strongly reference each other
            ---> if 1 of the objects goes out of scope: we would not deallocate either, bc the reference count would only go down to 1 --> this causes a memory leak (if sean is out of scope, but the laptop points to him: this is a memory leak, sean is lost)
            - memory only deallocated when the reference count = 0
            - to fix memory leak: in the laptop object, we need to make the owner var "weak var owner: Device" --> this keeps the reference count from going to 2, it keeps it at just 1, so then when it goes out of scope it'll be 0 and get deallocated (can do to either object, but just chose laptop)
            - common example: a network call
    - ternary expression: What ? True : False
    - delegates: waiting for an action/told to do something
    - [weak self]: needing to refer to self in "closures/completes" (?not sure correct terminology?)
    - "searchController.obscuresBackgroundDuringPresentation = false": gets rid of darker look when searching
    - "collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))" -> view.bounds: fill up the view with the collectionView
    - [weak self]: (this is called a capture list) -> added to make self weak, (self = FollowerListVC), doing this to stop memory leaks at self.followers can do unowned, instead of weak in [weak self], but this force unwraps it
    - "guard let self = self else { return }": self now made optional bc its weak, so it can now be nil
    - "#warning("Call Dismiss")": can be set as a reminder, kinda like a comment, but with color
    - "enum Section": set as enum bc enums are Hashable by default, and we need that for UICollectionViewDiffableDataSource
    - snapshot: need to pass in sections and items; and these items go through the hash function to give it a unique value; and thats how the dataSource tracks it; takes a snapshot of that data; and the new data that is changed, then it merges them behind the scenes
        - object needs to be hashable
        - WWDC says you can call apply() on snapshot of DiffableDataSource from the background thread
            - BUT be consistent. Either always call it from background queue, or always call it from the main queue
 
 */
