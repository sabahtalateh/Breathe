import SwiftUI
import SwiftData

struct CustomTrackView: View {
    
    @Bindable var customTrack: CustomTrack
    
    @Environment(\.modelContext) private var modelContext
    @Query private var steps: [CustomTrackStep]
    
    var scroller: ScrollViewProxy
    
    init(customTrack: CustomTrack, scroller: ScrollViewProxy) {
        self.customTrack = customTrack
        self.scroller = scroller
        
        // !! It is required to put id to local variable so #Predicate to work
        let trackID = customTrack.id
        let stepsOfTrack = #Predicate<CustomTrackStep> { step in step.track.id == trackID }
        _steps = Query(filter: stepsOfTrack, sort: \CustomTrackStep.order)
    }
    
    var body: some View {
        Section {
            List {
                ForEach(steps) { step in
                    StepEditor(
                        step: step
                    )
                    .id(step.id)
                }
                .onDelete(perform: deleteSteps)
                .onMove(perform: moveSteps)
            }
        } header: {
            Text("Breathing Cycles")
        }
    }
    
    private func moveSteps(from source: IndexSet, to destination: Int) {

        var mutableSteps = steps
        
        mutableSteps.move(fromOffsets: source, toOffset: destination)
        
        for (index, step) in mutableSteps.enumerated() {
            step.order = index
        }
        
        // try? modelContext.save() (???)
    }
    
    private func deleteSteps(at indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(steps[index])
        }
    }
}

struct StepEditor: View {
    @Bindable var step: CustomTrackStep
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            Section {
                CustomStepper(
                    label: phaseTitles[.in]!,
                    icon: phaseIcons[.in]!,
                    in: 1...99,
                    value: $step.in
                )
                
                CustomStepper(
                    label: phaseTitles[.inHold]!,
                    icon: phaseIcons[.inHold]!,
                    in: 0...99,
                    value: $step.inHold,
                    dimLowest: true,
                    replaceValues: [0: Image(systemName: "forward.fill")]
                )
                
                CustomStepper(
                    label: phaseTitles[.out]!,
                    icon: phaseIcons[.out]!,
                    in: 1...99,
                    value: $step.out
                )
                
                CustomStepper(
                    label: phaseTitles[.outHold]!,
                    icon: phaseIcons[.outHold]!,
                    in: 0...99,
                    value: $step.outHold,
                    dimLowest: true,
                    replaceValues: [0: Image(systemName: "forward.fill")]
                )
            } header: {
                Text("Breathing Cycle \(step.order + 1)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: Exercise(
                order: 1,
                title: "Test Exercise",
                track: .custom,
                constantTrack: Presets.constantTracks.default(),
                increasingTrack: Presets.dynamicTracks.defaultIncreasing(),
                decreasingTrack: Presets.dynamicTracks.defaultDecreasing(),
                customTrack: Presets.customTracks.default()
            )
        )
        .modelContainer(for: Exercise.self, inMemory: true)
        .tint(.primary)
    }
    .preferredColorScheme(.dark)
}
