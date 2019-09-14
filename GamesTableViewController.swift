//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Pedro Silva Dos Santos on 03/09/2019.
//  Copyright © 2019 Pedro Silva Dos Santos. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    var consolesManager = ConsolesManager.share
    var fetcheResultController: NSFetchedResultsController<Game>!
    let searchController = UISearchController(searchResultsController: nil)
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        tableView.reloadData()
        setupSearch()
    }

    
    func setupSearch() {
        //se tiver uma atualizacao a ser feita, será realizada pela propria classe
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true //insere uma view escura na view e da foco na tela de pesquisa
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            //primeiro resgato a viewController
          let vc = segue.destination as! GameViewController
            if let games = fetcheResultController.fetchedObjects { 
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
        }
    }

    
    func loadGames(filtering: String = "") {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        //existe uma pesquisa
        if !filtering.isEmpty {
            //para fazer filtro no coredate, precisamos implementar essa classe
            //predite -> é um conjunto de regra que implementamos para filtrar no banco de dados.
            //Ex: traga tudo que contem essa string
            let predicate = NSPredicate(format: "title contains [c] %@", filtering) //[c] para formatar como case in sensitive, aceita todos os tipos de formatacao
            fetchRequest.predicate = predicate
        }
        
        fetcheResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetcheResultController.delegate = self //o delegate é a propria clase
        
        //esse metodo vai buscar as informacoes
        do {
            try fetcheResultController.performFetch() //acabei de faxer uma chamada ao banco
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetcheResultController.fetchedObjects?.count ?? 0 //operador de colalecencia
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        guard let game = fetcheResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepare(with: game)
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             //pego o indice do meu jogo
            guard let game = fetcheResultController.fetchedObjects?[indexPath.row] else {return}
            //deleta o contexto, mas nao podemos esquecer de deletar o indice da tabela
            context.delete(game)
        } else if editingStyle == .insert {

        }    
    }
}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
    //retorna metodo para sabermos o que esta ocorrendo com a consulta
    //SEMPRE QUE algum objeto for modificado, esse metodo será chamado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("Objeto modificado = type", type)
        switch type {
        case .delete:
            if let indexPath = indexPath {
                 tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            tableView.reloadData() //qla outro cenario, vamos atualizar a tabela
        }
    }
}

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    //cancelou a pesquisa
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //se o usuario cancelou, eu passo o load dos jogos sem nenhum tipo de filtro
        loadGames()
        tableView.reloadData()
    }
    
    //fazendo a pesquisa
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //se o usuario pesquisou, eu passo o load dos jogos com um tipo de filtro
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
