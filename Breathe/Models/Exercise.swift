import SwiftData
import Foundation

enum Track: String, Codable {
    case constant = "constant"
    case increasing = "increasing"
    case decreasing = "decreasing"
    case custom = "custom"
}

enum Phase: String, Codable, CaseIterable {
    case `in` = "in"
    case inHold = "in_hold"
    case out = "out"
    case outHold = "out_hold"
}

@Model
class Exercise {
    
    @Attribute(.unique) var id: UUID
    
    var order: Int
    var title: String
    
    var track: Track
    
    @Relationship(deleteRule: .cascade) var constantTrack: ConstantTrack
    @Relationship(deleteRule: .cascade) var increasingTrack: DynamicTrack
    @Relationship(deleteRule: .cascade) var decreasingTrack: DynamicTrack
    @Relationship(deleteRule: .cascade) var customTrack: CustomTrack
    
    init(
        order: Int,
        title: String,
        track: Track,
        constantTrack: ConstantTrack,
        increasingTrack: DynamicTrack,
        decreasingTrack: DynamicTrack,
        customTrack: CustomTrack,
    ) {
        self.id = UUID()
        self.order = order
        self.title = title
        self.track = track
        self.constantTrack = constantTrack
        self.increasingTrack = increasingTrack
        self.decreasingTrack = decreasingTrack
        self.customTrack = customTrack
    }
}

@Model
class ConstantTrack {
    
    @Attribute(.unique) var id: UUID
    
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int
    var isInfinite: Bool
    var repeatTimes: Int
    
    init(
        `in`: Int,
        inHold: Int,
        out: Int,
        outHold: Int,
        isInfinite: Bool,
        repeatTimes: Int
    ) {
        self.id = UUID()
        self.in = `in`
        self.inHold = inHold
        self.out = out
        self.outHold = outHold
        self.isInfinite = isInfinite
        self.repeatTimes = repeatTimes
    }
}

@Model
class DynamicTrack {
    
    @Attribute(.unique) var id: UUID
    
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int
    
    var dynamicPhase: Phase
    var add: Int
    var limit: Int
    
    init(
        `in`: Int,
        inHold: Int,
        out: Int,
        outHold: Int,
        dynamicPhase: Phase,
        add: Int,
        limit: Int
    ) {
        self.id = UUID()
        self.in = `in`
        self.inHold = inHold
        self.out = out
        self.outHold = outHold
        self.dynamicPhase = dynamicPhase
        self.add = add
        self.limit = limit
    }
    
    var dynamicPhaseDuration: Int {
        switch dynamicPhase {
        case .in: `in`
        case .inHold: inHold
        case .out: out
        case .outHold: outHold
        }
    }
}

@Model
class CustomTrack {
    
    @Attribute(.unique) var id: UUID
    
    @Relationship(deleteRule: .cascade) var steps: [CustomTrackStep] = []
    
    init() {
        self.id = UUID()
    }
}

@Model
class CustomTrackStep {
    
    @Attribute(.unique) var id: UUID
    
    var track: CustomTrack
    
    var order: Int
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int

    init(track: CustomTrack, order: Int, `in`: Int, inHold: Int, out: Int, outHold: Int) {
        self.id = UUID()
        self.track = track
        self.order = order
        self.in = `in`
        self.inHold = inHold
        self.out = out
        self.outHold = outHold
    }
}
