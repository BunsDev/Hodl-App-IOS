//
//  ExchangeTableViewCell.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import UIKit

class ExchangeTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var exchangeImageView: UIImageView!
    
    @IBOutlet weak var exchangeNameLabel: UILabel!
    
    @IBOutlet weak var exchangeTrustScoreRankLabel: UILabel!
    
    @IBOutlet weak var exchangeVolumeBtc24hLabel: UILabel!
    
    @IBOutlet weak var exchangeTrustScoreLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
