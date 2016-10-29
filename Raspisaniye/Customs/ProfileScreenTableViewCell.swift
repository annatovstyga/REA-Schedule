//
//  ProfileScreenTableViewCell.swift
//  Raspisaniye
//
//  Created by Ilya Mudriy on 14.02.16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//
import UIKit

class ProfileScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var changeType: UILabel!
    @IBOutlet weak var changeDate: UILabel!
    @IBOutlet weak var changeTime: UILabel!
    @IBOutlet weak var changePlace: UILabel!
    @IBOutlet weak var changeTitle: UILabel!
    @IBOutlet weak var changeDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
