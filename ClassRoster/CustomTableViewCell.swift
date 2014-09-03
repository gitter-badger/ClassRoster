//
//  CustomTableViewCell.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/27/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
