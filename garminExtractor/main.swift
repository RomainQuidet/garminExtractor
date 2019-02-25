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

guard let bootFirmware = BootFirmware(gcd.records) else {
    print("can't find boot firmware")
    exit(0)
}

print("=> found boot firmware")
bootFirmware.printInfo()
