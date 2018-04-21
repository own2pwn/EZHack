import Foundation
import SwiftyBeaver

typealias log = SwiftyBeaver

public final class Logger {
    static func setupLogging() {
        let console = ConsoleDestination()
        log.addDestination(console)
    }
}
