import SwiftUI

struct StartExerciseView: View {
    
    let exercise: Exercise
    
    var exerciseDuration: Text {
        switch exercise.track {
        case .constant:
            if exercise.constantTrack.isInfinite {
                Text("\(Image(systemName: "infinity"))")
            } else {
                Text("\(formatSeconds(exercise.constantTrack.duration))")
            }
        case .increasing:
            Text("\(formatSeconds(exercise.increasingTrack.duration))")
        case .decreasing:
            Text("\(formatSeconds(exercise.decreasingTrack.duration))")
        case .custom:
            Text("\(formatSeconds(exercise.customTrack.duration))")
        }
    }
    
    var body: some View {
        
        Section {
            HStack {
                Spacer()
                
                
                Button {
                    // playStore.showPlayView(e)
                } label: {
                    ZStack {
                        Circle()
                            .stroke(.white, lineWidth: 3)
                        
                        Image(systemName: "play.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.primary)
                            .backgroundStyle(.thickMaterial)
                    }
                }
                
                .frame(width: 100, height: 100)
                
                Spacer()
            }
            
            HStack {
                Label {
                    Text("Exercise Duration")
                } icon: {
                    Image(systemName: "recordingtape")
                }
                
                Spacer()
                
                exerciseDuration
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
            
        } header: {
            Text("Start Exercise")
        }
    }
}

#Preview {
    Form {
        StartExerciseView(exercise: Presets.exercises.defaultConstant(order: 0, title: "Test Exercise"))
        .preferredColorScheme(.dark)
    }
    .tint(.primary)
    
}
