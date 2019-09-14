//
//  GameViewController.swift
//  MyGames
//
//  Created by Pedro Silva Dos Santos on 03/09/2019.
//  Copyright © 2019 Pedro Silva Dos Santos. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
        print("Titulo e Console",lbTitle.text)
        if let releaseDate = game.releaseDate {
            let formartter = DateFormatter()
            formartter.dateStyle = .long //defini o estilo que queremos apresentar
            formartter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = "Lançamento: " + formartter.string(from: releaseDate)
        }
        
        //se existir uma imagem persistida eu adicono no ivCover
        if let image = game.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as!  AddEditViewController
        vc.game = game
    }
}
