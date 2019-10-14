//
//  Journal.swift
//  CloudKitJournal
//
//  Created by Austin Goetz on 10/14/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CloudKit

struct JournalStrings {
    
    static let recordTypeKey = "Entry"
    fileprivate static let titleKey = "title"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let ckRecordIDKey = "ckRecordID"
}

class Entry {
    
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let title = ckRecord[JournalStrings.titleKey] as? String,
            let body = ckRecord[JournalStrings.bodyKey] as? String,
            let timestamp = ckRecord[JournalStrings.timestampKey] as? Date
            else {return nil}
        
        self.init(title: title, body: body, timestamp: timestamp)
    }
}

extension CKRecord {
    
    convenience init(entry: Entry) {
        self.init(recordType: JournalStrings.recordTypeKey, recordID: entry.ckRecordID )
        
        self.setValuesForKeys([
            JournalStrings.titleKey : entry.title,
            JournalStrings.bodyKey : entry.body,
            JournalStrings.timestampKey : entry.timestamp
        ])
    }
    
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
