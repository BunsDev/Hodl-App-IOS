//
//  CoinTableViewCell.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coinImageView: UIImageView!
    
    @IBOutlet weak var coinSymbolLabel: UILabel!
    
    @IBOutlet weak var coinPercentageChange24hLabel: UILabel!
    
    @IBOutlet weak var coinNameLabel: UILabel!
    
    @IBOutlet weak var coinPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
