//
//  FavoriteProvider.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 10/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import CoreData
import UIKit

class FavoriteProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameCatalogue")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return taskContext
    }
    
    func createFavorite(
        _ id: Int,
        _ name: String,
        _ released: String,
        _ backgroundImage: Data,
        _ backgroundImageAdditional: Data,
        _ rating: Double,
        _ overview: String,
        _ genres: String,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKey: "id")
                game.setValue(name, forKey: "name")
                game.setValue(released, forKey: "released")
                game.setValue(backgroundImage, forKey: "backgroundImage")
                game.setValue(backgroundImageAdditional, forKey: "backgroundImageAdditional")
                game.setValue(rating, forKey: "rating")
                game.setValue(overview, forKey: "overview")
                game.setValue(genres, forKey: "genres")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func getFavorites(completion: @escaping(_ favorites: [FavoriteModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [FavoriteModel] = []
                for result in results {
                    let favorite = FavoriteModel(
                        id: result.value(forKeyPath: "id") as? Int64,
                        name: result.value(forKeyPath: "name") as? String,
                        released: result.value(forKeyPath: "released") as? String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? Data,
                        backgroundImageAdditional: result.value(forKeyPath: "backgroundImageAdditional") as? Data,
                        rating: result.value(forKeyPath: "rating") as? Double,
                        overview: result.value(forKeyPath: "overview") as? String,
                        genres: result.value(forKey: "genres") as? String
                    )
                    favorites.append(favorite)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func checkDataExistence(_ id: Int) -> Bool {
        var isExist = false
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            let result = try taskContext.fetch(fetchRequest)
            if result.count > 0 {
                isExist = true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return isExist
    }
    
    func deleteFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult =
                try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }

}
