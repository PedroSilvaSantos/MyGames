//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Pedro Silva Dos Santos on 03/09/2019.
//  Copyright © 2019 Pedro Silva Dos Santos. All rights reserved.
//

import UIKit

class ConsolesTableViewController: UITableViewController {
    
    var consolesManager = ConsolesManager.share
   

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadConsoles()
    }
    
    
    //Carregando todas as plataformas
    func loadConsoles() {
        consolesManager.loadConsoles(with: context)
        //atualizando a tabela
        tableView.reloadData()
    }
    
    @IBAction func addConsole(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
    }
    
    //Esse metodo será resposavel por enviar alerta de inclusao de dados
    func showAlert(with console: Console?) {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + "plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField { (textFild) in
            textFild.placeholder = "Nome da plataforma"
            
            //se eu conseguir pegar o valor de nome, signoifica que estou no modo de adicionar
            if let name = console?.name {
                textFild.text = name
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            //Tento desembrulhar o console se for para adicionar.
            //se nao conseguiir, é porque é uma edicao, entao crio um novo
            let console = console ?? Console(context: self.context)
            //recuperei o textfild do alert
            console.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadConsoles()
                self.tableView.reloadData()
            }catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        //apresentar o alerta na tela
        //mudando a cor do tint
        alert.view.tintColor = UIColor(named: "second")
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consolesManager.consoles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name
        print("ConsolesTableViewController - console.name", console.name)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consolesManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            //volta na tabela e deleta a infomacao tbm
            tableView.deleteRows(at: [indexPath], with: .fade )
        }
    }
}



