//
//  ProductsViewController.swift
//  StaleApps
//
//  Created by Brandon Sanchez on 4/17/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchControllerContainerView: UIView!
    
    let appList = [
        "Tarascon Pharmacopeia",
        "Tarascon Medical Procedures",
        "Tarascon Global Health",
        "Tarascon Gastroenterology",
        "Tarascon Emergency Medicine",
        "Tarascon Urologica",
        "Tarascon Hospital Medicine",
        "Tarascon Primary Care",
        "Tarascon Pediatric Inpatient",
        "Tarascon Rheumatologica",
        "Tarascon Adult Emergency Pocketbook",
        "Tarascon Rx Essentials",
        "GRS Flashcards",
        "Infectious Disease Advisor",
        "AACN Essentials of Critical-Care Nursing Pocket Handbook",
        "MPR",
        "Clinical Pain Advisor",
        "Cardiology Drug Guide",
        "PICU Pediatric Critical Care",
        "Konica Minolta Sales",
        "Jones & Bartlett\'s Nurse\'s Drug Handbook",
        "Psychiatry Advisor",
        "FP Notebook",
        "Mobile Medical Emergencies",
        "MyEpiPen",
        "Taber\'s Medical Dictionary",
        "Oncology Nurse Advisor",
        "Mobile EMT",
        "Endocrinology Advisor",
        "Geriatrics at your Fingertips",
        "Renal & Urology News",
        "ACS Essentials",
        "Drugs & Bugs",
        "Mylan GBR Guide",
        "Rheumatology Advisor",
        "Clinical Prediction Rules",
        "Pocket Guide to Hematologic Cancer Chemotherapy Protocols: Leukemia",
        "myCME Bank",
        "AGS Pocket Guide to Common Immunizations for the Older Adult",
        "Cancer Therapy Advisor",
        "Stroke Essentials",
        "ScriptMe",
        "SC Magazine",
        "Mobile Paramedic",
        "myGainesville - Events Guide to the Greater Gainesville Area",
        "Clinician\'s Pocket Reference",
        "MIMS",
        "AGS GEMS",
        "myCME",
        "Nurse\'s Drug Handbook",
        "ACS Essentials (Acute Coronary Syndromes)",
        "The Cardiology Advisor",
        "IDdx: Infectious Disease Queries",
        "Davis\'s Drug Guide for Nurses",
        "Paramedic Field Guide",
        "IDdx: Infectious Diseases",
        "Family Practice Notebook App: Free Medical Reference for Primary Care and Emergency Clinician Professionals",
        "MIMS Diagnosis & Management",
        "Emergency Medicine Handbook",
        "Jones & Bartlett Learning Nurse\'s Drug Handbook",
        "iGeriatrics",
        "Neurology Advisor",
        "ObGyn and Infertility Handbook",
        "AACN Critical Care Nursing",
        "Clinical Advisor",
        "Oak Hall",
        "Pocket Guide to Hematologic Cancer Chemotherapy Protocols",
        "Short Haul"
    ]
    
    var apps = [App]() {
        didSet {
            DispatchQueue.main.sync {
                self.productsCollectionView.reloadData()
            }
            
        }
    }
    
    var filteredApps = [App]()
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        productsCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        if let flowLayout = productsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout { flowLayout.estimatedItemSize = CGSize(width: 1, height: 1) }
        
        addSearchBar()
        navigationItem.title = "Products" //titleTextAttributes = ["Products" : NSString]

        getProducts()
    }
    
    func addSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        //let searchBar = searchController.searchBar
        
        //searchBar = UISearchBar(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 50))
        
        searchController.searchBar.barStyle = .blackOpaque
        
        searchControllerContainerView.addSubview(searchController.searchBar)
    }
    
    func getProducts() {
        AppFiguresClient().urlConnection {
            result in
            switch result {
            case .success(let products):
                for app in products {
                    //print(app.name)
                }
                self.apps = products
            case .failure(let errorMessage):
                print(errorMessage)
            }
        }
    }

    public func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            filterContentForSearchText(searchText: searchController.searchBar.text!)
            
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredApps = apps.filter { app in
            return (app.name?.lowercased().contains(searchText.lowercased()))!
        }
        
        productsCollectionView.reloadData()
        productsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        productsCollectionView.reloadData()
        productsCollectionView.collectionViewLayout.invalidateLayout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredApps.count
        }
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        var product = apps[indexPath.row]
        if searchController.isActive && searchController.searchBar.text != "" {
            product = filteredApps[indexPath.row]
        }
        
        
        return cell.bind(product)
    }
    
}
