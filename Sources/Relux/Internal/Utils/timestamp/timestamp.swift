#if canImport(Darwin)
import Darwin
#elseif os(Linux)
@preconcurrency import Glibc
#elseif canImport(Bionic)
@preconcurrency import Bionic
#elseif canImport(Musl)
@preconcurrency import Musl
#elseif canImport(WinSDK)
import WinSDK
#elseif os(Windows)
import ucrt
#else
#error("Unsupported platform")
#endif

@usableFromInline
struct timestamp {
    
    @usableFromInline
    static var seconds: Int {
        let ts = _nowTimespec()
        return Int(ts.tv_sec)
    }
    
    @usableFromInline
    static var milliseconds: Int {
        let ts = _nowTimespec()
        var millis = Int(ts.tv_sec) * 1_000
        let nsec = Int(ts.tv_nsec)
        millis += nsec / 1_000_000
        // round half up
        if (nsec % 1_000_000) >= 500_000 {
            millis += 1
        }
        return millis
    }
    
    @usableFromInline
    static var microseconds: Int {
        let ts = _nowTimespec()
        var micros = Int(ts.tv_sec) * 1_000_000
        let nsec = Int(ts.tv_nsec)
        micros += nsec / 1_000
        // round half up
        if (nsec % 1_000) >= 500 {
            micros += 1
        }
        return micros
    }
}


@inline(__always)
private func _nowTimespec() -> timespec {
#if canImport(WinSDK)
    // Use FILETIME (100ns ticks since 1601-01-01) → Unix epoch
    var ft = FILETIME()
    GetSystemTimePreciseAsFileTime(&ft)
    let hi = UInt64(ft.dwHighDateTime)
    let lo = UInt64(ft.dwLowDateTime)
    // 100ns units
    let ticks100ns = (hi << 32) | lo
    // Convert to nanoseconds
    let nanosTotal = ticks100ns * 100
    // Difference between 1601-01-01 and 1970-01-01 in seconds
    let secBetweenEpochs: UInt64 = 11_644_473_600
    let sec = nanosTotal / 1_000_000_000
    let nsec = nanosTotal % 1_000_000_000
    var ts = timespec()
    // Guard underflow if clock is weird (shouldn’t happen)
    if sec >= secBetweenEpochs {
        ts.tv_sec  = Int(sec - secBetweenEpochs)
        ts.tv_nsec = Int(nsec)
    } else {
        ts.tv_sec  = 0
        ts.tv_nsec = 0
    }
    return ts
#else
    var ts = timespec()
    // `clock_gettime` is available on Darwin, glibc, musl, bionic
    _ = clock_gettime(CLOCK_REALTIME, &ts)
    return ts
#endif
}
