import SwiftUI

struct ExerciseDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Bindable var exercise: Exercise
    
    var body: some View {
        ScrollViewReader { scroller in
            Form {
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
                            addCustomTrackStep(scroller: scroller)
                        } label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
    
    private func addCustomTrackStep(scroller: ScrollViewProxy) {
        let track = exercise.customTrack
        
        // Create a new step with the next order number
        let newStep = CustomTrackStep(
            track: track,
            order: track.steps.count,
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
}

#Preview {
    NavigationStack {
        ExerciseDetailView(
            exercise: Exercise(
                order: 1,
                title: "Test Exercise",
                track: .constant,
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
