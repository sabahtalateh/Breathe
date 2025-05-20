import SwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercise

    var body: some View {
        Text("Exercise: \(exercise.title)")
            .navigationTitle(exercise.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
