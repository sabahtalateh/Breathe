import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var exercise: Exercise
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        ScrollViewReader { scroller in
            Form {
                StartExerciseView(exercise: exercise)
                
                ExerciseTitleView(title: $exercise.title)
                
                TrackPickerView(selectedTrack: $exercise.track)
                
                switch exercise.track {
                case .constant:
                    ConstantTrackView(constantTrack: exercise.constantTrack)
                case .increasing:
                    IncreasingTrackView(increasingTrack: exercise.increasingTrack)
                case .decreasing:
                    DecreasingTrackView(decreasingTrack: exercise.decreasingTrack)
                case .custom:
                    CustomTrackView(
                        customTrack: exercise.customTrack,
                        scroller: scroller
                    )
                }
            }
            .navigationTitle(exercise.title)
            .navigationBarTitleDisplayMode(.inline)
            .tint(.primary)
            .toolbar {
                if exercise.track == .custom {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation { isEditing.toggle() }
                        } label: {
                            Image(systemName: isEditing ? "checkmark" : "pencil")
                                .contentTransition(.symbolEffect(.replace))
                        }
                        .accessibilityIdentifier("Edit Custom Track Steps")
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            addCustomTrackStep(scroller: scroller)
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                        .accessibilityIdentifier("Add Custom Track Step")
                    }
                }
            }
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        }
    }
    
    private func addCustomTrackStep(scroller: ScrollViewProxy) {
        let track = exercise.customTrack
        
        // Create a new step with the next order number
        let newStep = CustomTrackStep(
            track: track,
            order: getCustomTrackStepsCount(),
            in: 1, inHold: 0, out: 1, outHold: 0
        )
        
        withAnimation {
            modelContext.insert(newStep)
            try? modelContext.save()
        }
        
        // Scroll to the new step after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                scroller.scrollTo(newStep.id, anchor: .bottom)
            }
        }
    }
    
    func getCustomTrackStepsCount() -> Int {
        do {
            // !! It is required to put id to local variable so #Predicate to work
            let trackID = exercise.customTrack.id
            let predicate = #Predicate<CustomTrackStep> { step in step.track.id == trackID }
            let descriptor = FetchDescriptor<CustomTrackStep>(predicate: predicate)
            
            return try modelContext.fetchCount(descriptor)
        } catch {
            // TODO: Do Something with Error
            print("Error fetching steps count: \(error)")
            return 0
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: Presets.exercises.defaultConstant(order: 0, title: "Test Exercise")
        )
        .modelContainer(for: Exercise.self, inMemory: true)
        .tint(.primary)
    }
    .preferredColorScheme(.dark)
}
