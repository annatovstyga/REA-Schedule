//
//  CustomTableViewCell.swift
//  Raspisaniye
//
//  Created by rGradeStd on 2/9/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var placeCell: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
