//
//  ViewController+CoreData.swift
//  MyGames
//
//  Created by Pedro Silva Dos Santos on 04/09/2019.
//  Copyright © 2019 Pedro Silva Dos Santos. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
