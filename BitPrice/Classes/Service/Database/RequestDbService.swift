//
//  RequestDbService.swift
//  BitPrice
//
//  Created by Bruno Tortato Furtado on 27/01/18.
//  Copyright © 2018 Bruno Tortato Furtado. All rights reserved.
//

import CoreData
import Foundation

class RequestDbService {

    func insert(url: String, responseBody: String, date: Date) {
        let stack = CoreDataStack.shared
        let context = stack.context
        _ = RequestEntity(url: url, responseBody: responseBody, date: date)
        
        do {
            try context.save()
            stack.saveContext()
        } catch let error {
            debugPrint("error: \(error)")
        }
    }
    
    func fetch(url: String) -> RequestEntity? {
        let context = CoreDataStack.shared.context
        var request: RequestEntity?
        
        let fetchRequest: NSFetchRequest<RequestEntity> = RequestEntity.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "url = %@", url)

        do {
            request = try context.fetch(fetchRequest).first as RequestEntity?
        } catch let error {
            debugPrint("error: \(error)")
        }
        
        return request
    }
    
    func delete(url: String) {
        let stack = CoreDataStack.shared
        let context = stack.context
        let request = fetch(url: url)
        
        if let request = request {
            context.delete(request)
            stack.saveContext()
        }
    }
    
}
