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
    let items: [fwInfoItem]
    
    init(fmwDscStr: FirmwareDescriptorStructure, fmwDsc: Data) {
        
    }
}
