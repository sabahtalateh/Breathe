import SwiftUI
import SwiftData

struct IncreasingTrackView: View {
    
    @Bindable var increasingTrack: DynamicTrack
      
    @State var increaseFrom: Int = 0
    @State var increaseTo: Int = 0
    
    var body: some View {
        Section {
            
            CustomStepper(
                label: phaseTitles[.in]!,
                icon: phaseIcons[.in]!,
                in: 1...99,
                value: $increasingTrack.in
            )
            
            CustomStepper(
                label: phaseTitles[.inHold]!,
                icon: phaseIcons[.inHold]!,
                in: 0...99,
                value: $increasingTrack.inHold,
                dimLowest: true,
                replaceValues: [0: Image(systemName: "forward.fill")]
            )
            
            CustomStepper(
                label: phaseTitles[.out]!,
                icon: phaseIcons[.out]!,
                in: 1...99,
                value: $increasingTrack.out
            )
            
            CustomStepper(
                label: phaseTitles[.outHold]!,
                icon: phaseIcons[.outHold]!,
                in: 0...99,
                value: $increasingTrack.outHold,
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
                            increasingTrack.dynamicPhase = phase
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
                        Text(phaseTitles[increasingTrack.dynamicPhase]!)
                    } icon: {
                        phaseIcons[increasingTrack.dynamicPhase]!
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
            
            CustomStepper(
                label: "Increase to",
                icon: Image(systemName: "arrow.up.right"),
                in: increaseFrom...increaseTo,
                value: $increasingTrack.limit
            )
            .onAppear {
                adjustIncreaseRange()
            }
            .onChangeOfDynamicTrack(track: increasingTrack) {
                adjustIncreaseRange()
            }
            
            CustomStepper(
                label: "Increase by",
                icon: Image(systemName: "repeat"),
                in: 1...99,
                value: $increasingTrack.add
            )
            
        } header: {
            Text("Increase")
        } footer: {
            Text("Select increasing phase. Set its duration at the end of exercise and increasing rate")
        }
    }
    
    func adjustIncreaseRange() {
        let initDur = increasingTrack.dynamicPhaseDuration

        let rngStart = initDur + 1
        let rngEnd = initDur + 99
        
        increaseFrom = rngStart
        increaseTo = rngEnd
        
        if increasingTrack.limit < rngStart {
            increasingTrack.limit = rngStart
        }
        
        if increasingTrack.limit > rngEnd {
            increasingTrack.limit = rngEnd
        }
    }
    
    
}

#Preview {
    Form {
        IncreasingTrackView(increasingTrack: Presets.dynamicTracks.defaultIncreasing())
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
}
