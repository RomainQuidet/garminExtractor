//
//  gcd.swift
//  garminExtractor
//
//  Created by Romain Quidet on 25/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

class GCD {
    
    private(set) var records = [GCDRecord]()
    let fileUrl: URL
    
	init?(with arguments: [String]) {
		guard arguments.count > 1 else { return nil }
		let gcdFilePath = arguments[1]
		print("init with \(gcdFilePath)")
        fileUrl = URL(fileURLWithPath: gcdFilePath)
		guard let data = try? Data(contentsOf: fileUrl) else { return nil }
		self.parse(data)
	}
	
	private func parse(_ data: Data) {
		var buffer = data
		//HEADER
		let headerData = buffer.prefix(6)
		buffer = buffer.dropFirst(6)
		let versionData = buffer.prefix(2)
		buffer = buffer.dropFirst(2)
		
		print("**** HEADER *****")
		let signature = String(bytes: headerData, encoding: .utf8)
		guard signature == "GARMIN" else {
			print("error, invalid signature")
			return
		}
		print("Signature: \(signature!)")
		let version = versionData.asUInt16
		guard version == 100 else {
			print("error, invalid version number")
			return
		}
		print("Version: \(version)")
        
        print("---- HEADER OK ----")
		
		//RECORDS
		while buffer.count > 0 {
            print("**** RECORD ****")
            
			let recordID = buffer.prefix(2).asUInt16
			buffer = buffer.dropFirst(2)
			let recordLength = buffer.prefix(2).asUInt16
			buffer = buffer.dropFirst(2)
			
            let dataLength = buffer.count > recordLength ? Int(recordLength) : buffer.count
			let recordData = buffer.prefix(dataLength)
			buffer = buffer.dropFirst(dataLength)
            let record = GCDRecord(id: recordID, data: recordData)
            self.records.append(record)
            
            let recordMeaning = record.idMeaning ?? "?"
            print("ID: \(recordID.toHexString) (\(recordMeaning))")
            print("Length: \(recordLength)")
            if let knownID = record.knownId {
                switch knownID {
                case .copyrights:
                    let cr = String(data: record.data, encoding: .utf8)!
                    print("\(cr)")
                case .firmwareDesicriptorStructure,
                     .firmwareDescriptor:
                    let bytes = record.data.map { (byte) -> String in
                        String(byte)
                    }
                    print("\(bytes)")
                default:
                    continue
                }
            }
            print("---- RECORD OK ----")
		}
	}
}

extension Data {
	private func to<T>(type: T.Type) -> T {
		return self.withUnsafeBytes { $0.pointee }
	}
	
	var asUInt8: UInt8 {
		return self.to(type: UInt8.self)
	}
	
	var asUInt16: UInt16 {
		let tmp = self.to(type: UInt16.self)
		return UInt16(littleEndian: tmp)
	}
    var asUInt32: UInt32 {
        let tmp = self.to(type: UInt32.self)
        return UInt32(littleEndian: tmp)
    }
}

extension UInt16 {
	var toHexString: String {
		return String(format:"0x%02X", self)
	}
}

extension UInt8 {
    var toHexString: String {
        return String(format:"0x%01X", self)
    }
}

extension UInt32 {
    var toHexString: String {
        return String(format:"0x%04X", self)
    }
}

extension UInt {
    var toHexString: String {
        return String(format:"0x%04X", self)
    }
}
