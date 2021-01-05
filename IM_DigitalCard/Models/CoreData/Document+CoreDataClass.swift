//
//  Document+CoreDataClass.swift
//  IM_DigitalCard
//
//  Created by elie buff on 31/12/2020.
//
//

import Foundation
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    
    static func addDocument(context :NSManagedObjectContext, docId: String, fileName: String, fileData: Data, docType: String) -> Document? {
        let filePath = FileManagement.sharedInstance.createFile(fileData: fileData, fileName: fileName)
        
        let documentItem = Document(context: context)
        documentItem.filename = fileName
        documentItem.docID = docId
        documentItem.identifier = docType
        documentItem.fileURL = filePath
          
        CoreDataStack.shared.save(context: context)
        
        return documentItem
    }
    
    static func documentExists(context :NSManagedObjectContext, docId: String) -> Bool {
        let itemFetch = NSFetchRequest<NSFetchRequestResult>(entityName: getEntityName())
        
        var subpredicates = [NSPredicate]();
        subpredicates.append(NSPredicate(format:"docID == %@", docId))
        itemFetch.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: subpredicates)
        
        
        do {
            let fetchedItems = try context.fetch(itemFetch) as! [Document]
            return fetchedItems.count > 0
        } catch {
            fatalError("Failed to fetch Story Items: \(error)")
        }
        
    }
    
    static func getDocumentUrl(by type: String) -> String? {
        let itemFetch = NSFetchRequest<NSFetchRequestResult>(entityName: getEntityName())
        let context = CoreDataStack.shared.backgroundContext
        
        var subpredicates = [NSPredicate]();
        subpredicates.append(NSPredicate(format:"identifier == %@", type))
        itemFetch.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: subpredicates)
        
        
        do {
            let fetchedItems = try context.fetch(itemFetch) as! [Document]
            if fetchedItems.count > 0{
                return fetchedItems[0].fileURL
            }
            return nil
        } catch {
            fatalError("Failed to fetch Story Items: \(error)")
        }
    }
    

}
