//
//  DogTableCell.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-09.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class DogTableCell: UITableViewCell {

    @IBOutlet weak var dogCellName: UILabel!
    @IBOutlet weak var dogCellDisplay: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
