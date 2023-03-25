//
//  PortfolioTableViewCell.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 3.01.2023.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var coinNameLabel: UILabel!
    
    @IBOutlet weak var coinAmountLabel: UILabel!
    
    @IBOutlet weak var coinValueInUsdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
