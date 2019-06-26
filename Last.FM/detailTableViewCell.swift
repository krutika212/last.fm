//
//  detailTableViewCell.swift
//  Last.FM
//
//  Created by Jenish Dhaduk on 6/26/19.
//  Copyright © 2019 iphone. All rights reserved.
//

import UIKit

class detailTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var lblAlbumImage: UIImageView!
    @IBOutlet weak var lblAlbumName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
