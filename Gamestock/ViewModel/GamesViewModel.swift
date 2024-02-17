//
//  GamesViewModel.swift
//  Gamestock
//
//  Created by IT on 10/02/24.
//

import Foundation
import Alamofire
import CoreData

class GamesViewModel: ObservableObject {
    @Published var games: [GamesModel] = []
    @Published var favoriteGames: [GamesModel] = []
    @Published var detailGame: DetailGamesModel?

    @Published var isLoadGamesError: Bool = false
    @Published var isLoadDetailGamesError: Bool = false
    @Published var isFavoriteLoading: Bool = false

    func getGamesData() async {
        let response = await AF.request(AppConfigs.API_GAMES + "?key=\(AppConfigs.API_KEY)", method: .get)
            .cacheResponse(using: .cache)
            .serializingDecodable(GameResponse.self)
            .response

        DispatchQueue.main.async {
            if response.error != nil {
                self.isLoadGamesError = true
            } else {
                self.games = response.value?.results ?? []
                print(self.games)
            }
        }
    }

    func getDetailGameData(id: Int) async {
        let response = await AF.request(AppConfigs.API_GAMES + "/\(id)" + "?key=\(AppConfigs.API_KEY)", method: .get)
            .cacheResponse(using: .cache)
            .serializingDecodable(DetailGamesModel.self)
            .response

        DispatchQueue.main.async {
            if response.error != nil {
                self.isLoadDetailGamesError = true
            } else {
                self.detailGame = response.value
            }
        }
    }

    func loadFavoriteGames() {
        self.getListFavoriteGames { result in
            DispatchQueue.main.async {
                self.isFavoriteLoading = true
                self.favoriteGames = result
                self.isFavoriteLoading = false
            }
        }
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GamesDataModel")

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

        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }

    func getListFavoriteGames(completion: @escaping(_ gamesData: [GamesModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Games")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GamesModel] = []
                for result in results {
                    guard let idData = result.value(forKeyPath: "id") as? Int else { return }
                    guard let ratingData = result.value(forKeyPath: "rating") as? Float else { return }
                    guard let nameData = result.value(forKeyPath: "name") as? String else { return }

                    let gamesModel = GamesModel(
                        id: Int(idData),
                        name: nameData,
                        released: result.value(forKeyPath: "released") as? String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                        rating: CGFloat(ratingData)
                    )

                    games.append(gamesModel)
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    func getGame(_ id: Int, completion: @escaping(_ gameData: GamesModel?) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Games")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")

            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    guard let idData = result.value(forKeyPath: "id") as? Int else { return }
                    guard let ratingData = result.value(forKeyPath: "rating") as? Float else { return }
                    guard let nameData = result.value(forKeyPath: "name") as? String else { return }

                    let gamesModel = GamesModel(
                        id: Int(idData),
                        name: nameData,
                        released: result.value(forKeyPath: "released") as? String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                        rating: CGFloat(ratingData)
                    )

                    completion(gamesModel)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    func insertFavoriteGame(
        _ gamesData: GamesModel,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Games", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(gamesData.id, forKey: "id")
                game.setValue(gamesData.name, forKey: "name")
                game.setValue(Float(gamesData.rating), forKey: "rating")
                game.setValue(gamesData.backgroundImage, forKey: "backgroundImage")
                game.setValue(gamesData.released, forKey: "released")

                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }

    func deleteFavoriteGame(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Games")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
}
