import Testing
import SwiftData
@testable import Breathe

struct DurationTests {
    
    @Test func testConstantTrackDuration() throws {
        
        // Test for a track with a single cycle
        let track = ConstantTrack(in: 1, inHold: 2, out: 3, outHold: 4, isInfinite: false, repeatTimes: 1)
        #expect(track.duration == 10) // 1+2+3+4 = 30
        
        // Test for a regular track with multiple repetitions
        let track2 = ConstantTrack(in: 5, inHold: 3, out: 4, outHold: 2, isInfinite: false, repeatTimes: 3)
        #expect(track2.duration == 42) // (5+3+4+2) * 3 = 14 * 3 = 42
        
        // Test for an infinite track
        let track3 = ConstantTrack(in: 5, inHold: 5, out: 5, outHold: 5, isInfinite: true, repeatTimes: 10)
        #expect(track3.duration == 0) // Infinite track returns 0
        
        // Test for a track with zero repeat times
        let track4 = ConstantTrack(in: 1, inHold: 2, out: 3, outHold: 4, isInfinite: false, repeatTimes: 0)
        #expect(track4.duration == 0) // 1+2+3+4 = 30
    }
    
    @Test func testIncreasingTrackDuration() throws {
        // (1, 0, 1, 0) + (1, 0, 2, 0) = 2 + 3 = 5
        let track = DynamicTrack(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 1, limit: 2)
        #expect(track.duration == 5)
        
        // (1, 0, 1, 0) + (1, 0, 2, 0) = 2 + 3 = 5
        let track2 = DynamicTrack(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 2, limit: 2)
        #expect(track2.duration == 5)
        
        // (1, 0, 1, 0) + (1, 0, 2, 0) = 2 + 3 = 5
        let track3 = DynamicTrack(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 99, limit: 2)
        #expect(track3.duration == 5)
        
        // (1, 0, 1, 0) + (1, 0, 6, 0) + (1, 0, 10, 0) = 2 + 7 + 11 = 20
        let track4 = DynamicTrack(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 5, limit: 10)
        #expect(track4.duration == 20)
        
        // (1, 0, 1, 0) + (1, 0, 11, 0) + (1, 0, 15, 0) = 2 + 12 + 16 = 30
        let track5 = DynamicTrack(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 10, limit: 15)
        #expect(track5.duration == 30)

        // add = 0
        let zeroAdd = DynamicTrack(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 0, limit: 2)
        #expect(zeroAdd.duration == 0)
    }
}
