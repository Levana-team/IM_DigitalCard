//
//  ClientsListView.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//

import SwiftUI
import CoreData

struct FilteredListView<U: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<U>
    var items: FetchedResults<U> { fetchRequest.wrappedValue }
    
    let content: (U) -> Content
    
    init(searchText: String, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate, @ViewBuilder content: @escaping (U) -> Content) {
        fetchRequest = FetchRequest<U>(entity: U.entity(),
                                             sortDescriptors: sortDescriptors,
                                             predicate: predicate
        )
        
        self.content = content
    }
    
    var body: some View {
        List(items, id: \.self) { (item: U) in
            content(item)
        }
    }
}
