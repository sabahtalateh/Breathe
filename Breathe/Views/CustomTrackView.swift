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
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(steps[index])
                    }
                }
                .onMove { fromOffsets, toOffset in
                    moveSteps(from: fromOffsets, to: toOffset)
                }
            }
        } header: {
            Text("Breathing Cycles")
        }
    }
    
    private func moveSteps(from source: IndexSet, to destination: Int) {
        // Create a temporary array for moving items
//        var stepsArray = steps.map { step in step }
        
        // Perform the move operation in the array
//        stepsArray.move(fromOffsets: source, toOffset: destination)
        
        // Update the order in the database
//        for (index, step) in stepsArray.enumerated() {
//            step.order = index
//        }
        
        // Save changes
//        try? modelContext.save()
        
        // Создаем временный массив, отражающий порядок после перемещения
            var stepsArray = steps.map { step in step }
            stepsArray.move(fromOffsets: source, toOffset: destination)
            
            // Просто обновляем все порядковые номера последовательно
            for (index, step) in stepsArray.enumerated() {
                step.order = index
            }
            
            // Сохраняем изменения
            try? modelContext.save()
    }
    
    private func deleteSteps(at offsets: IndexSet) {
        let stepsToDelete = offsets.map { offset in steps[offset] }
        for step in stepsToDelete {
            modelContext.delete(step)
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
                
//                CustomStepper(
//                    label: phaseTitles[.inHold]!,
//                    icon: phaseIcons[.inHold]!,
//                    in: 0...99,
//                    value: $step.inHold,
//                    dimLowest: true,
//                    replaceValues: [0: Image(systemName: "forward.fill")]
//                )
//                
//                CustomStepper(
//                    label: phaseTitles[.out]!,
//                    icon: phaseIcons[.out]!,
//                    in: 1...99,
//                    value: $step.out
//                )
//                
//                CustomStepper(
//                    label: phaseTitles[.outHold]!,
//                    icon: phaseIcons[.outHold]!,
//                    in: 0...99,
//                    value: $step.outHold,
//                    dimLowest: true,
//                    replaceValues: [0: Image(systemName: "forward.fill")]
//                )
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
