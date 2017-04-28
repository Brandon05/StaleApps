//
//  ProductCell.swift
//  StaleApps
//
//  Created by Brandon Sanchez on 4/17/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var productBackgroundView: UIView!
    @IBOutlet weak var appleUpdatedLabel: UILabel!
    @IBOutlet weak var googleUpdatedLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productTitleLabel.preferredMaxLayoutWidth = productBackgroundView.frame.width - 16
        appleUpdatedLabel.preferredMaxLayoutWidth = productBackgroundView.frame.width - 16
        googleUpdatedLabel.preferredMaxLayoutWidth = productBackgroundView.frame.width - 16
        
        productBackgroundView.layer.cornerRadius = 4
        productBackgroundView.layer.shadowOpacity = 0.8
        productBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        productBackgroundView.layer.shadowRadius = 6
        productBackgroundView.layer.shadowColor = UIColor.black.cgColor
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func bind(_ app: App) -> Self {
        
        productTitleLabel.text = app.name
        appleUpdatedLabel.text = "N/A"
        googleUpdatedLabel.text = "N/A"
        
        if let appleDate = app.updateDates?["apple"] {
            appleUpdatedLabel.text = formatedDate(appleDate)
        }
        
        if let googleDate = app.updateDates?["google"] {
            googleUpdatedLabel.text = formatedDate(googleDate)
            
        }
        
        return self
        
    }
    
    func formatedDate(_ string: String) -> String {
        
        let dateFormatter = DateFormatter()
        //print(string)
        //format in which recived Date Present
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let newDate = dateFormatter.date(from: string)
        //print(newDate)
        
        // format to which you need your date to convert
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        if let newDate  = newDate{
            let dateStr = dateFormatter.string(from: newDate)
            
            return dateStr //Output: MAR-20-2017
            
        }
        
        return "Date error"
    }

}
