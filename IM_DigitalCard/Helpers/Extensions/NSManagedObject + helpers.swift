//
//  NSManagedObject + helpers.swift
//  IM_DigitalCard
//
//  Created by elie buff on 30/12/2020.
//

import CoreData

extension NSManagedObject{
    static func getEntityName() -> String{
        return self.entity().name ?? ""
    }
    
    static func emptyEntity(){
        let context = CoreDataStack.shared.backgroundContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: getEntityName())
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
    
    static func getRecords(by ids:[String]? = nil, sortDescriptors:[(key:String, ascending:Bool)]? = nil) -> [NSManagedObject]?{
        let context = CoreDataStack.shared.viewContext
        let templatetFetch = NSFetchRequest<NSFetchRequestResult>(entityName: getEntityName())
        
        if let ids = ids{
            let pred = NSPredicate(format: "id IN %@",ids)
            templatetFetch.predicate = pred
        }
        
        if let sortDescriptors = sortDescriptors{
            var sortBy = [NSSortDescriptor]()
            
            for sortItem in sortDescriptors{
                sortBy.append(NSSortDescriptor(key: sortItem.key, ascending: sortItem.ascending))
            }
            templatetFetch.sortDescriptors = sortBy
        }
        
        do {
            let fetchedRecords = try context.fetch(templatetFetch) as! [NSManagedObject]
            if fetchedRecords.count > 0{
                return fetchedRecords
            }
            return nil
        } catch {
            fatalError("Failed to fetch record: \(error)")
        }
        return nil
    }
}
