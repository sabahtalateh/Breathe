import SwiftUI

struct ExercisePlayerView: View {
    
    let exercise: Exercise
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(.white, .black.opacity(0.3))
                    }
                }
                .padding()
                
                Spacer()
                
                Text(exercise.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(trackTexts[exercise.track]?.0 ?? "")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(spacing: 20) {
                    Text("Exercise Player")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Coming Soon...")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                HStack(spacing: 40) {
                    Button {
                        // Play/Pause action
                    } label: {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ExercisePlayerView(
        exercise: Presets.exercises.defaultConstant(order: 0, title: "Test Exercise"),
        isPresented: .constant(true)
    )
}
