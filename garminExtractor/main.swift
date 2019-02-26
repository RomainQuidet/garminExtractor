//
//  main.swift
//  garminExtractor
//
//  Created by Romain Quidet on 25/02/2019.
//  Copyright © 2019 XDAppfactory. All rights reserved.
//

import Foundation

print("GARMIN firmware extractor")

guard let gcd = GCD(with: CommandLine.arguments) else {
	print("need a file arg")
	exit(0)
}

print("=> found \(gcd.records.count) records")

print("**** searching for boot firmware")
guard let bootFirmware = BootFirmware(gcd.records) else {
    print("can't find boot firmware")
    exit(0)
}
print("=> found boot firmware")
bootFirmware.printInfo()
let originalFile = gcd.fileUrl
var bootFmwFile = originalFile.deletingLastPathComponent()
bootFmwFile = bootFmwFile.appendingPathComponent("bootFirmware.bin")
bootFirmware.save(to: bootFmwFile)
print("---- boot firmware saved to \(bootFmwFile)")

print("**** searching for firmware")
guard let firmware = Firmware(gcd.records) else {
    print("can't find firmware")
    exit(0)
}
print("=> found firmware")
firmware.printInfo()
var fmwFile = originalFile.deletingLastPathComponent()
fmwFile = fmwFile.appendingPathComponent("firmware.bin")
firmware.save(to: fmwFile)
print("---- firmware saved to \(fmwFile)")


