//
//  JournalController.swift
//  CloudKitJournal
//
//  Created by Austin Goetz on 10/14/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CloudKit

class JournalController {
    
    // sharedInstance
    static let shared = JournalController()
    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    // SoT
    var entries: [Entry] = []
    
    // CRUD
    
    // Create
    func save(with title: String, body: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let newEntry = Entry(title: title, body: body)
        
        let entryRecord = CKRecord(entry: newEntry)
        
        privateDataBase.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
            let saveEntry = Entry(ckRecord: record)
                else {completion(false); return}
            
            self.entries.append(saveEntry)
            print("Saved entry successfully")
            completion(true)
        }
    }
    
    func addEntry(with title: String, body: String, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(title: title, body: body)
        entries.append(newEntry)
    }
    
    func fetchEntries(completion: @escaping (_ success: Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: JournalStrings.recordTypeKey, predicate: predicate)
        
        privateDataBase.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let records = foundRecords else {completion(false); return}
            
            let entries = records.compactMap( { Entry(ckRecord: $0) } )
            
            self.entries = entries
            print("Fetched entries successfully")
            completion(true)
        }
    }
    
    func remove(with entry: Entry) {
        guard let entryIndex = entries.firstIndex(of: entry) else {return}
        entries.remove(at: entryIndex)
    }
}
