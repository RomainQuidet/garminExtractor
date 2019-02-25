//
//  FirmwareDescriptorStructure.swift
//  garminExtractor
//
//  Created by Romain Quidet on 25/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

struct FirmwareDescriptorStructure {
    typealias fdsItem = (fieldID: UInt8, fieldType: UInt8)
    let items: [fdsItem]
    
    init?(_ record: GCDRecord?) {
        guard let record = record,
            let knownID = record.knownId,
            knownID == .firmwareDesicriptorStructure else { return nil }
        
        var tmpItems = [fdsItem]()
        for i in stride(from: 0, to: record.data.count, by: 2) {
            let item = fdsItem(record.data[i], record.data[i+1])
            tmpItems.append(item)
        }
        self.items = tmpItems
    }
}
