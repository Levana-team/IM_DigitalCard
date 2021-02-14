//
//  SOQLQueries.swift
//  IM_DigitalCard
//
//  Created by Elie Buff on 14/01/2021.
//

import Foundation
class SOQLQueries {
    
    static func getMyStoreClients(fromDate: Date?) -> String {
        
        var clientQuery = Queries.getQuery(by: "Clients")
        
        //if let fromDate = fromDate {
        //    clientQuery.append(" AND LastModifiedDate >= \(fromDate.toString(format: .sfDateTime))")
        //}
        
        clientQuery.append(" ORDER BY lastName, firstName ")
        return clientQuery
    }
    
    static func getClientListItems(clientListItem: ClientList) -> String {
        let clientListQuery =  "\(Queries.getQuery(by: "Clients")) \(clientListItem.query ?? "") order by \(clientListItem.orderByField ?? "firstName") \(clientListItem.orderByAscDesc ?? "asc") limit \(clientListItem.limit )"
        return clientListQuery
    }
}
