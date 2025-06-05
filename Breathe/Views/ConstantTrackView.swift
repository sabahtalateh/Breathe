import SwiftUI

struct ConstantTrackView: View {
    
    @Bindable var constantTrack: ConstantTrack
    
    var body: some View {
        
        Section {
            
            CustomStepper(
                label: phaseTitles[.in]!,
                icon: phaseIcons[.in]!,
                in: 1...99,
                value: $constantTrack.in
            )
            
            CustomStepper(
                label: phaseTitles[.inHold]!,
                icon: phaseIcons[.inHold]!,
                in: 0...99,
                value: $constantTrack.inHold,
                dimLowest: true,
                replaceValues: [0: Image(systemName: "forward.fill")],
            )
            
            CustomStepper(
                label: phaseTitles[.out]!,
                icon: phaseIcons[.out]!,
                in: 1...99,
                value: $constantTrack.out,
            )
            
            CustomStepper(
                label: phaseTitles[.outHold]!,
                icon: phaseIcons[.outHold]!,
                in: 0...99,
                value: $constantTrack.outHold,
                dimLowest: true,
                replaceValues: [0: Image(systemName: "forward.fill")],
            )
            
        } header: {
            Text("Durations")
        } footer: {
            Text("Set breathing cycle phases durations. Durations are measured in seconds")
        }
        
        Section {
            Toggle(isOn: $constantTrack.isInfinite) {
                Label {
                    VStack(alignment: .leading) {
                        Text("Infinite Repeat")
                        Text(constantTrack.isInfinite ? "Exercise will run until manually stopped" : "Exercise will run for a specified number of times")
                            .padding(.trailing)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "infinity")
                }
            }
            .tint(.secondary)

            if !constantTrack.isInfinite {
                CustomStepper(
                    label: "Repeat Times",
                    icon: Image(systemName: "repeat"),
                    in: 1...99,
                    value: $constantTrack.repeatTimes
                )
            }
            
        } header: {
            Text("Repeat")
        } footer: {
            Text("Set number of repetitions of breathing cycle")
        }
        
    }
}

#Preview {
    Form {
        ConstantTrackView(constantTrack: Presets.constantTracks.default())
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
}
