//
//  Logging.swift
//  WeatherApp
//
//  Created by Pavel Alekseev.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

struct Logging {

    static func start() {
        guard let fileURL = Logging.logURL else {
            log.error("no log file URL")
            return
        }

        let console = ConsoleDestination()

        console.levelString.verbose = "[VERBOSE]"
        console.levelString.debug = "[DEBUG]"
        console.levelString.info = "[INFO]"
        console.levelString.warning = "[WARNING]"
        console.levelString.error = "[ERROR]"

        // add context $X right after level
        // log message looks like
        // 12:35:58.501 [DEBUG🔄] ReusablePlayer.prepareToPlay():45 - FDF424448D89 is now preloading (...)
        console.format = "$DHH:mm:ss.SSS$d $C$L$X$c $N.$F:$l - $M"
        console.minLevel = .verbose

        console.levelColor.verbose = ""
        console.levelColor.debug = ""
        console.levelColor.info = ""
        console.levelColor.warning = "⚠️"
        console.levelColor.error = "🚨"
        log.addDestination(console)

        let file = FileDestination(logFileURL: fileURL)
        file.logFileMaxSize = 1 * 1024 * 1024
        file.logFileAmount = 5
        file.minLevel = .debug
        log.addDestination(file)
    }

    static var logURL: URL? {
        guard let appSupport = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory,
            .userDomainMask,
            true).first
        else {
            log.error("no app support folder found")
            return nil
        }

        let dirURL = URL(fileURLWithPath: appSupport).appendingPathComponent("logs")
        return dirURL.appendingPathComponent("weatherApp.log")
    }
}

extension DefaultStringInterpolation {
    /// Default to `<nil>` for nil values in optional and print actual values without the `Optional(<value>)`
    mutating func appendInterpolation<T>(_ optional: T?) {
        if let nonOptional = optional {
            appendInterpolation(nonOptional)
        } else {
            appendInterpolation("<nil>")
        }
    }
}
