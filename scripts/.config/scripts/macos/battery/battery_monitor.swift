#!/usr/bin/swift
import Foundation
import IOKit.ps

var lowNotified  = false
var highNotified = false

func getBatteryInfo() -> (percent: Int, isCharging: Bool)? {
    guard
        let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
        let sources  = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
        let source   = sources.first,
        // "Get" function — takeUnretainedValue, NOT takeRetainedValue
        let desc     = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any]
    else { return nil }

    guard
        let current = desc[kIOPSCurrentCapacityKey] as? Int,
        let max     = desc[kIOPSMaxCapacityKey] as? Int,
        max > 0
    else { return nil }

    let percent    = (current * 100) / max
    let isCharging = (desc[kIOPSPowerSourceStateKey] as? String) == kIOPSACPowerValue
    return (percent, isCharging)
}

func notify(title: String) {
    let script = "display notification \"\" with title \"\(title)\" sound name \"Glass\""
    let task   = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    task.arguments     = ["-e", script]
    try? task.run()
    task.waitUntilExit()
}

func log(_ msg: String) {
    let ts = ISO8601DateFormatter().string(from: Date())
    print("[\(ts)] \(msg)")
    fflush(stdout)
}

func checkAndNotify() {
    guard let (percent, isCharging) = getBatteryInfo() else {
        log("ERROR: Could not read battery info")
        return
    }

    log("\(percent)% | \(isCharging ? "charging" : "discharging")")

    if isCharging {
        lowNotified = false
        if percent >= 80 && !highNotified {
            notify(title: "can unplug charger!")
            highNotified = true
            log("Notified: high_80")
        } else if percent < 75 {
            highNotified = false
        }
    } else {
        if percent < 75 { highNotified = false }
        if percent <= 30 && !lowNotified {
            notify(title: "low battery")
            lowNotified = true
            log("Notified: low_30")
        } else if percent > 35 {
            lowNotified = false
        }
    }
}

let source = IOPSNotificationCreateRunLoopSource(
    { _ in checkAndNotify() },
    nil
).takeRetainedValue()

CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .defaultMode)
log("Battery monitor started")
checkAndNotify()
CFRunLoopRun()
