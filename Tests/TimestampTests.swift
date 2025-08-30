import Testing
@testable import Relux

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

@Suite("timestamp invariants")
struct TimestampTests {
    
    @Test("seconds is close to wall-clock now")
    func secondsCloseToNow() {
        let nowSec = Int(Date().timeIntervalSince1970)
        let s = timestamp.seconds
        // Allow a few seconds of skew so CI/virtualized clocks don't flake.
        #expect(abs(s - nowSec) <= 5)
    }
    
    @Test("milliseconds is consistent with seconds")
    func millisecondsConsistent() {
        let s = timestamp.seconds
        let ms = timestamp.milliseconds
        
        // ms should be within the current or next second in ms
        #expect(ms >= s * 1_000)
        #expect(ms <= (s + 1) * 1_000)
    }
    
    @Test("microseconds is consistent with milliseconds (round-half-up)")
    func microsecondsConsistent() {
        let ms = timestamp.milliseconds
        let us = timestamp.microseconds
        
        // 1 ms = 1000 µs; rounding differences should keep them within < 1000 µs.
        #expect(abs(us - (ms * 1_000)) < 1_000)
    }
    
    @Test("nondecreasing within a short window (tolerant)")
    func nondecreasingTolerant() async throws {
        // Real-time clocks can jump backwards slightly; we only assert a very tolerant bound.
        let s1 = timestamp.seconds
        try await Task.sleep(nanoseconds: 50_000_000) // ~50ms
        let s2 = timestamp.seconds
        #expect(s2 >= s1 || (s1 - s2) <= 1) // allow tiny backward step
    }
}
