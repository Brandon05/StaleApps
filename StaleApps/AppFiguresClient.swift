//
//  AppFiguresClient.swift
//  StaleApps
//
//  Created by Brandon Sanchez on 4/17/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(String)
}

class AppFiguresClient: NSObject {
    
    let appList = [
        "Tarascon Pharmacopoeia",
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
        "Davis\'s Drug Guide for Nurses",
        "Paramedic Field Guide",
        "IDdx",
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
    
    fileprivate let baseURl = "https://api.appfigures.com/v2/"
    fileprivate let productsURL = "products/mine/?"
    fileprivate let clientKey = "0d4c90500cca4531984066853f0b2ca9"
    fileprivate let username = "xzheng@atmoapps.com"
    fileprivate let password = "7873898qq"
    
    func urlConnection(completion: @escaping (Result<[App]>) -> Void) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        // create the request
        let url = URL(string: baseURl + productsURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue(clientKey, forHTTPHeaderField: "X-Client-Key")
        
        // fire off the request
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error: \(error)")
                return
            }
            
            guard let results = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: results, options: []) as? NSDictionary else {
                    print("error trying to convert data to JSON")
                    print(results.description)
                    return
                }
                
                var apps = [App]()
                
                self.addApp(for: json, into: &apps)
                
                completion(Result.success(apps))
                
            } catch {
                completion(Result.failure("Error serializing json"))
            }
            
        }
        
        task.resume()
    }
    
    func addApp(for json: NSDictionary, into apps: inout [App]) {
        // 1. Loop through json which is [Int: NSDictionary]
        for (_, value) in json {
            if let product = value as? NSDictionary {
                var name = product["name"] as? String
                let store = product["store_id"] as? Int
                let updatedDate = product["updated_date"] as? String
                
                // 2. Check name against app list
                name = verifyApp(name: &name!)
                
                // If name is not in app list, continue through loop from here
                guard name != nil, store != nil, updatedDate != nil else {
                    continue
                }
                
                // 3. Grab store key i.e "apple" or "google"; Add app to results array
                if let storeID = getStoreID(for: store!) {
                    addProduct(into: &apps, for: name!, date: updatedDate!, storeID: storeID)
                }
                
            }
            
        }
    }
    
    // Check app name against app list
    
    func verifyApp(name: inout String) -> String? {
        for app in self.appList {
            if name.lowercased().contains(app.lowercased()) && !name.lowercased().contains("subscription"), !name.lowercased().contains("discount") {
                name = app
                return name
            }
        }
        
        return nil
    }
    
    // Switch case for store ID
    func getStoreID(for store: Int) -> String? {
        switch store {
        case 1:
            return "apple"
        case 2:
            return "google"
        default:
            return nil
        }
    }
    
    func addProduct(into apps: inout [App], for name: String, date: String, storeID: String) {
        
        var existingAppIndex: Int!
        
        // Check if app already exists, if so save the index
        if apps.contains(where: { app -> Bool in
            
            if app.name == name {
                existingAppIndex = apps.index(of: app)
            }
            
            return app.name == name
        }) {
            // If app exists, add appropriate date
            addDate(for: &apps[existingAppIndex], date: date, storeID: storeID)
        } else {
            let app = App(name: name, updateDates: [storeID : date])
            apps.append(app)
        }
    }
    
    // Check if date already exists, if so compare and save most recent (json is funky, may return multiple instances of app with different date
    func addDate(for app: inout App, date: String, storeID: String) {
        if let currentDate = app.updateDates?[storeID] {
            app.updateDates?[storeID] = formatedDate(currentDate) > formatedDate(date) ? currentDate : date
        } else {
            app.updateDates?[storeID] = date
        }
    }
    
    // Date formatter
    func formatedDate(_ string: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: string)!
    }
}





