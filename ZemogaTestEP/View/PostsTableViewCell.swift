//
//  PostsTableViewCell.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/7/22.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var isReadedButton: CircleView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var indexPath: IndexPath!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
}
