//
//  bootFirmware.swift
//  garminExtractor
//
//  Created by Romain Quidet on 25/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

class BootFirmware {
    
    private let data: Data
    private let fmwDscStr: FirmwareDescriptorStructure
    private let fmwDsc: GCDRecord
    
    init?(_ records: [GCDRecord]) {
        var firmwareDescriptorStructure: GCDRecord?
        var firmwareDescriptor: GCDRecord?
        var firmware: [GCDRecord]?
        for record in records {
            guard let knownID = record.knownId else { continue }
            if firmware != nil && knownID != .bootFirmwareChunk {
                break
            }
            if knownID == .firmwareDesicriptorStructure {
                firmwareDescriptorStructure = record
            }
            else if knownID == .firmwareDescriptor {
                firmwareDescriptor = record
            }
            else if knownID == .bootFirmwareChunk {
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
        self.fmwDscStr = fmwDscStr
        self.fmwDsc = fmwDsc
    }
    
    func printInfo() {
        print("Firmware descriptor structure")
        self.fmwDscStr.items.forEach { (item) in
            print("item: \(item.fieldID): \(item.fieldType.toHexString)")
        }
    }
}
