import SwiftUI
import SwiftData

struct DecreasingTrackView: View {
    
    @Bindable var decreasingTrack: DynamicTrack
    
    @State private var decreaseFrom: Int = 0
    @State private var decreaseTo: Int = 0
    
    @State private var decreaseBy: Int = 0
    
    var body: some View {
        Section {
            CustomStepper(
                label: phaseTitles[.in]!,
                icon: phaseIcons[.in]!,
                in: 1...99,
                value: $decreasingTrack.in
            )
            
            CustomStepper(
                label: phaseTitles[.inHold]!,
                icon: phaseIcons[.inHold]!,
                in: 0...99,
                value: $decreasingTrack.inHold,
                dimLowest: true,
                replaceValues: [0: Image(systemName: "forward.fill")],
            )
            
            CustomStepper(
                label: phaseTitles[.out]!,
                icon: phaseIcons[.out]!,
                in: 1...99,
                value: $decreasingTrack.out
            )
            
            CustomStepper(
                label: phaseTitles[.outHold]!,
                icon: phaseIcons[.outHold]!,
                in: 0...99,
                value: $decreasingTrack.outHold,
                dimLowest: true,
                replaceValues: [0: Image(systemName: "forward.fill")]
            )
        } header: {
            Text("Initial Durations")
        } footer: {
            Text("Set initial breathing cycle phases durations. Durations are measured in seconds")
        }
        
        Section {
            HStack {
                Menu {
                    ForEach(Phase.allCases, id: \.self) { phase in
                        Button {
                            decreasingTrack.dynamicPhase = phase
                        } label: {
                            Label {
                                Text(phaseTitles[phase]!)
                            } icon: {
                                phaseIcons[phase]!
                            }
                        }
                    }
                } label: {
                    Label {
                        Text(phaseTitles[decreasingTrack.dynamicPhase]!)
                    } icon: {
                        phaseIcons[decreasingTrack.dynamicPhase]!
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
            
            CustomStepper(
                label: "Decrease to",
                icon: Image(systemName: "arrow.up.right"),
                in: decreaseFrom...decreaseTo,
                value: $decreasingTrack.limit
            )
            .onAppear {
                adjustDecreaseRange()
            }
            .onChangeOfDynamicTrack(track: decreasingTrack) {
                adjustDecreaseRange()
            }

            CustomStepper(
                label: "Decrease by",
                icon: Image(systemName: "repeat"),
                in: 1...99,
                value: $decreaseBy
            )
            .onAppear {
                decreaseBy = -decreasingTrack.add
            }
            .onChange(of: decreaseBy) { _, newValue in
                decreasingTrack.add = -newValue
            }
            
        } header: {
            Text("Decrease")
        } footer: {
            Text("Select decreasing phase. Set its duration at the end of exercise and decreasing rate")
        }
    }
    
    func adjustDecreaseRange() {
        let initDur = decreasingTrack.dynamicPhaseDuration
        
        var rngStart = switch decreasingTrack.dynamicPhase {
        case .in, .out:
            1
        default:
            0
        }
        var rngEnd = initDur - 1
        if rngEnd < 0 {
            rngEnd = 0
        }
        
        if rngStart > rngEnd {
            rngStart = rngEnd
        }
        
        decreaseFrom = rngStart
        decreaseTo = rngEnd
        
        if decreasingTrack.limit < rngStart {
            decreasingTrack.limit = rngStart
        }
        
        if decreasingTrack.limit > rngEnd {
            decreasingTrack.limit = rngEnd
        }
    }
    
}

#Preview {
    Form {
        DecreasingTrackView(decreasingTrack: Presets.dynamicTracks.defaultDecreasing())
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
}
