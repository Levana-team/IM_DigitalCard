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
}
