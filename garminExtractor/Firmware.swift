//
//  Firmware.swift
//  garminExtractor
//
//  Created by Romain Quidet on 26/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

class Firmware {
    
    private let data: Data
    private let fmwInfo: FirmwareInfo
    
    init?(_ records: [GCDRecord]) {
        var firmwareDescriptorStructure: GCDRecord?
        var firmwareDescriptor: GCDRecord?
        var firmware: [GCDRecord]?
        for record in records {
            guard let knownID = record.knownId else { continue }
            if firmware != nil && knownID != .firmwareChunk {
                break
            }
            if knownID == .firmwareDesicriptorStructure {
                firmwareDescriptorStructure = record
            }
            else if knownID == .firmwareDescriptor {
                firmwareDescriptor = record
            }
            else if knownID == .firmwareChunk {
                if firmware == nil {
                    firmware = []
                }
                firmware?.append(record)
            }
        }
        
        guard let fmwDscStr = FirmwareDescriptorStructure(firmwareDescriptorStructure),
            let fmwDsc = firmwareDescriptor,
            let fmw = firmware else { return nil }
        
        var tmpData = Data()
        fmw.forEach { (record) in
            tmpData.append(record.data)
        }
        self.data = tmpData
        self.fmwInfo = FirmwareInfo(fmwDscStr: fmwDscStr, fmwDsc: fmwDsc.data)
    }
    
    func printInfo() {
        print("Firmware descriptor structure")
        self.fmwInfo.items.forEach { (item) in
            print("item: \(item.fieldID): \(item.fieldValue.toHexString)")
        }
    }
    
    func save(to path: URL) {
        try? self.data.write(to: path)
    }
}
