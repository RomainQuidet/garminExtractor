//
//  FirmwareInfo.swift
//  garminExtractor
//
//  Created by Romain Quidet on 25/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

struct FirmwareInfo {
    typealias fwInfoItem = (fieldID: UInt8, fieldValue: UInt)
    private(set) var items = [fwInfoItem]()
    
    init(fmwDscStr: FirmwareDescriptorStructure, fmwDsc: Data) {
        var buffer = fmwDsc
        while buffer.count > 0 {
            let itemFieldID = buffer.prefix(1).asUInt8
            buffer = buffer.dropFirst()
            guard let fmwDscStrItem = fmwDscStr.items.first(where: { (item) -> Bool in
                return item.fieldID == itemFieldID
            }) else {
                buffer = buffer.dropFirst()
                continue
            }
            var itemValue: UInt = 0
            switch fmwDscStrItem.fieldType {
            case 0:
                itemValue = UInt(buffer.prefix(1).asUInt8)
                buffer = buffer.dropFirst()
            case 0x10:
                itemValue = UInt(buffer.prefix(2).asUInt16)
                buffer = buffer.dropFirst(2)
            case 0x20:
                itemValue = UInt(buffer.prefix(4).asUInt32)
                buffer = buffer.dropFirst(4)
            case 0x50:
                continue
            default:
                continue
            }
            let item: fwInfoItem = (itemFieldID, itemValue)
            items.append(item)
        }
    }
}
