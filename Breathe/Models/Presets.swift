class Presets {
    
    static var exercises: ExercisePresets = .init()
    
    static var constantTracks: ConstantTrackPresets = .init()
    
    static var dynamicTracks: DynamicTrackPresets = .init()
    
    static var customTracks: CustomTrackPresets = .init()
    
}

class ExercisePresets {
    
    fileprivate init(){}
    
    func defaultConstant(order: Int, title: String) -> Exercise {
        .init(
            order: order,
            title: title,
            track: .constant,
            constantTrack: Presets.constantTracks.default(),
            increasingTrack: Presets.dynamicTracks.defaultIncreasing(),
            decreasingTrack: Presets.dynamicTracks.defaultDecreasing(),
            customTrack: Presets.customTracks.default(),
        )
    }
    
    func defaultIncreasing(order: Int, title: String) -> Exercise {
        .init(
            order: order,
            title: title,
            track: .increasing,
            constantTrack: Presets.constantTracks.default(),
            increasingTrack: Presets.dynamicTracks.defaultIncreasing(),
            decreasingTrack: Presets.dynamicTracks.defaultDecreasing(),
            customTrack: Presets.customTracks.default(),
        )
    }
    
    func defaultDecreasing(order: Int, title: String) -> Exercise {
        .init(
            order: order,
            title: title,
            track: .decreasing,
            constantTrack: Presets.constantTracks.default(),
            increasingTrack: Presets.dynamicTracks.defaultIncreasing(),
            decreasingTrack: Presets.dynamicTracks.defaultDecreasing(),
            customTrack: Presets.customTracks.default(),
        )
    }
    
    func defaultCustom(order: Int, title: String) -> Exercise {
        .init(
            order: order,
            title: title,
            track: .custom,
            constantTrack: Presets.constantTracks.default(),
            increasingTrack: Presets.dynamicTracks.defaultIncreasing(),
            decreasingTrack: Presets.dynamicTracks.defaultDecreasing(),
            customTrack: Presets.customTracks.default(),
        )
    }
    
}

class ConstantTrackPresets {
    
    fileprivate init(){}
    
    func `default`() -> ConstantTrack {
        .init(in: 4, inHold: 0, out: 4, outHold: 0, isInfinite: false, repeatTimes: 20)
    }
}

class DynamicTrackPresets {
    
    fileprivate init(){}
    
    func defaultIncreasing() -> DynamicTrack {
        .init(in: 1, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: 1, limit: 10)
    }
    
    func defaultDecreasing() -> DynamicTrack {
        .init(in: 10, inHold: 0, out: 1, outHold: 0, dynamicPhase: .in, add: -1, limit: 1)
    }
}

class CustomTrackPresets {
    
    fileprivate init(){}
    
    func `default`() -> CustomTrack {
        let track = CustomTrack()
        
        track.steps.append(contentsOf: [
            .init(track: track, order: 0, in: 1, inHold: 0, out: 1, outHold: 0),
            .init(track: track, order: 1, in: 2, inHold: 0, out: 2, outHold: 0),
            .init(track: track, order: 2, in: 3, inHold: 0, out: 3, outHold: 0),
            .init(track: track, order: 3, in: 4, inHold: 0, out: 4, outHold: 0),
            .init(track: track, order: 4, in: 5, inHold: 0, out: 5, outHold: 0)
        ])

        return track
    }
}
