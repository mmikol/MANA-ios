//
//  WorkoutTableViewCell.swift
//  MANA
//
//  Created by Miliano Mikol on 2/13/21.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
