//
//  Task+Sleep.swift
//  WeatherApp
//
//  Created by alekseevpg on 01.02.2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {

    public static func sleep(ms: UInt64) async throws {
        try await sleep(nanoseconds: ms * 1_000_000)
    }

    public static func sleep(s: TimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(s * Double(NSEC_PER_SEC)))
    }

}
