//
//  TuduListCell.swift
//  TuduList
//
//  Created by Bruno Paulino on 10/6/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

class TuduListCell: UITableViewCell {
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var checkedImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
