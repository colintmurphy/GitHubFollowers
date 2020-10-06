//
//  FavoritesListVC.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
    
    // MARK: - Variables
    
    private let tableview = UITableView()
    private var favorites: [Follower] = []
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    // MARK: - Get Favorites
    
    private func getFavorites() {
        
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    // MARK: - Update UI
    
    private func updateUI(with favorites: [Follower]) {
        
        if favorites.isEmpty {
            self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
        } else {
            self.favorites = favorites
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.view.bringSubviewToFront(self.tableview) // bring table on top, just incase empty state shows
            }
        }
    }
    
    // MARK: - Configure
    
    private func configureViewController() {
        
        view.backgroundColor    = .systemBackground
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        
        view.addSubview(tableview)
        tableview.frame         = view.bounds // fill the whole view
        tableview.rowHeight     = 80
        tableview.delegate      = self
        tableview.dataSource    = self
        
        tableview.removeExtraCells()
        tableview.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}

// MARK: - UITableViewDelegate

extension FavoritesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let favorite    = favorites[indexPath.row]
        let destVC      = FollowerListVC(username: favorite.login)
        navigationController?.pushViewController(destVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FavoritesListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableview.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as? FavoriteCell else { fatalError("couldn't create FavoriteCell") }
        cell.set(favorite: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

/*
 
 EDUCATIONAL NOTES:
    - Persistence: saving in UserDefaults, save + retrieve function necessary
    - dataSource breaks MVC here. we can abstract it out of VC bc it doesn't need to know about it, BUT w/ our simple use of it, keeping it here makes it easier to read
 */
