import Foundation

print("GARMIN firmware extractor")

guard let gcd = GCD(with: CommandLine.arguments) else {
	print("need a file arg")
	exit(0)
}

print("=> found \(gcd.records.count) records")

