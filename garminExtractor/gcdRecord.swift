//
//  gcdRecord.swift
//  garminExtractor
//
//  Created by Romain Quidet on 25/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

class GCDRecord {
    
    enum GCDRecordID: UInt16 {
        case copyrights = 0x0005
        case firmwareDesicriptorStructure = 0x0006
        case firmwareDescriptor = 0x0007
        case bootFirmwareChunk = 0x0008
        case firmwareChunk = 0x02BD
    }
    
    let knownId: GCDRecordID?
    let data: Data
    
    private let id: uint16
    
    init(id: uint16, data: Data) {
        self.id = id
        self.data = Data(data)
        self.knownId = GCDRecordID(rawValue: id)
    }
    
    var idMeaning: String? {
        var result: String?
        switch self.id {
        case 0x0001:
            result = "Checkpoint"
        case 0x0002:
            result = "Filler"
        case 0x0003:
            result = "Main Header"
        case 0x0005:
            result = "Copyrights"
        case 0x0006:
            result = "Firmware descriptor structure"
        case 0x0007:
            result = "Firmware descriptor"
        case 0x0008:
            result = "boot.bin"
        case 0x02BD:
            result = "fw_all.bin"
        case 0x0401:
            result = "external_data.bin"
        case 0x0505:
            result = "firmware file *.BIN"
        case 0x0510:
            result = "logo (Garmin Bitmap)"
        case 0xFFFF:
            result = "END"
        default:
            result = nil
        }
        return result
    }
}
