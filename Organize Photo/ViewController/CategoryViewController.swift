//
//  CategoryViewController.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import UIKit
import Photos
import CoreData
import SVProgressHUD

class CategoryViewController: UITableViewController {
    
    private final let cellId = "CategoryCell"
    private var photos: PHFetchResult<PHAsset>?
    
    private var filteredCategories = [Category]()
    private var fetchedResultsCategory: NSFetchedResultsController<Category>!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchBar()
        SVProgressHUD.setupProgressHUDStyle()
        
        requestPhotoLibraryAuthorization()
        
        fetchedResultsCategory = CategoryEntity.fetchCategories()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setupNavigationBar() {
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBarButton_TouchUpInside))
        navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarButton_TouchUpInside))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "Category"
        navigationController?.navigationBar.tintColor = .orange
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Categories"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func refreshBarButton_TouchUpInside() {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            SVProgressHUD.show(withStatus: "Loading...")
            performMLOnPhotos {
                DispatchQueue.main.async {
                    self.fetchedResultsCategory = CategoryEntity.fetchCategories()
                    SVProgressHUD.showSuccess(withStatus: "Done")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.tableView.reloadData()
                }
            }
        } else {
            let title = "No Access to Photo Library"
            let message = "Please allow our app to have access to your photos library"
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            let alert = UIAlertController.createAlertController(title: title, message: message, actions: [action])
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func searchBarButton_TouchUpInside() {
        navigationItem.searchController?.isActive = true
    }
    
    private func performMLOnPhotos(completion: @escaping () -> ()) {
        let mlQueue = DispatchQueue(label: "com.OrganizePhotos.queue", qos: .userInteractive, attributes: [.concurrent])
        
        if let photos = photos {
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .original
            options.isSynchronous = true
            
            mlQueue.async {
                for i in 0..<(photos.count) {
                    
                    manager.requestImageData(for: photos[i], options: options) { data, _, _, _ in
                        if let data = data {
                            // create Image Core Data
                            let image = ImageEntity.createImage(data: data)
                            
                            let categoryDesc = MLClass.performObjectRecognition(data: data)
                            let categoryArray = categoryDesc.components(separatedBy: ", ")
                            
                            for desc in categoryArray {
                                let str = desc.prefix(1).uppercased() + desc.lowercased().dropFirst()
                                CategoryEntity.createCategoryWithImageRelationship(desc: str, image: image)
                            }
                        }
                    }
                }
                CoreDataStack.shared.saveContext()
                completion()
            }
        }
    }
    
    private func requestPhotoLibraryAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                self.photos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            case .denied, .restricted:
                let title = "Cannot Organize Your Photos"
                let message = "Please allow our app to have access to your photos library in order to work"
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                let alert = UIAlertController.createAlertController(title: title, message: message, actions: [action])
                self.present(alert, animated: true, completion: nil)
            case .notDetermined:
                print("Not determined yet")
            @unknown default:
                NSLog("Nothing")
            }
        }
    }
    
}

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCategories.count
        }
        return (fetchedResultsCategory.sections![section]).numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.category = isFiltering() == true ? filteredCategories[indexPath.row] : fetchedResultsCategory.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let imagesVC = CategoryImagesViewController(collectionViewLayout: layout)
        if isFiltering() {
            imagesVC.category = filteredCategories[indexPath.row]
        } else {
            imagesVC.category = fetchedResultsCategory.object(at: indexPath)
        }
        navigationController?.pushViewController(imagesVC, animated: true)
    }
    
}

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController?.isActive = false
    }
    
}

extension CategoryViewController: UISearchResultsUpdating {
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCategories = fetchedResultsCategory.fetchedObjects!.filter({( category : Category) -> Bool in
            return category.label!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
}
