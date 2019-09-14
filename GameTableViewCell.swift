//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by Pedro Silva Dos Santos on 03/09/2019.
//  Copyright © 2019 Pedro Silva Dos Santos. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet var ivCover: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbConsole: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func prepare(with game: Game) {
        lbTitle.text = game.title
        print("lbTitle.text", lbTitle.text)
        lbConsole.text = game.console?.name
        print("lbConsole.text", lbConsole.text)
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCover")
        }
    }
}
