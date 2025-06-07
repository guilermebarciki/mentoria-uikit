
import Foundation
import CoreData

final class FavoritePokemonCoreDataRepository: FavoritePokemonRepositoryProtocol {
    static let shared = FavoritePokemonCoreDataRepository()
    
    private let entityName = "FavoritePokemon"
    private let nameAttribute = "name"
    
    // Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        // Create model description
        let model = NSManagedObjectModel()
        
        // Create entity description
        let entity = NSEntityDescription()
        entity.name = entityName
        entity.managedObjectClassName = NSManagedObject.self.description()
        
        // Create attribute
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = self.nameAttribute
        nameAttribute.attributeType = .stringAttributeType
        nameAttribute.isOptional = false
        nameAttribute.isIndexed = true
        
        // Add attribute to entity
        entity.properties = [nameAttribute]
        
        // Add entity to model
        model.entities = [entity]
        
        // Create container with in-memory store
        let container = NSPersistentContainer(name: "PokemonModel", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PokemonFavorites.sqlite")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Repository Protocol Methods
    
    func add(_ name: String) {
        let lowercaseName = name.lowercased()
        
        // Check if it already exists
        if contains(lowercaseName) {
            return
        }
        
        // Create new favorite
        let favorite = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: entityName, in: context)!, insertInto: context)
        favorite.setValue(lowercaseName, forKeyPath: nameAttribute)
        
        saveContext()
    }
    
    func remove(_ name: String) {
        let lowercaseName = name.lowercased()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", nameAttribute, lowercaseName)
        
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject], !results.isEmpty {
                for object in results {
                    context.delete(object)
                }
                saveContext()
            }
        } catch {
            print("Error deleting favorite from Core Data: \(error)")
        }
    }
    
    func contains(_ name: String) -> Bool {
        let lowercaseName = name.lowercased()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", nameAttribute, lowercaseName)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if favorite exists in Core Data: \(error)")
            return false
        }
    }
    
    func allFavorites() -> [String] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: nameAttribute, ascending: true)]
        
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                return results.compactMap { $0.value(forKey: nameAttribute) as? String }
            }
        } catch {
            print("Error fetching favorites from Core Data: \(error)")
        }
        
        return []
    }
    
    // MARK: - Core Data Helpers
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
