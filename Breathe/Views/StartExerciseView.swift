import SwiftUI

struct StartExerciseView: View {
    
    var exerciseDuration: Text {
        //            switch detailStore.exercise.duration {
        //            case .infinity:
        //                Text("\(Image(systemName: "infinity"))")
        //            case .seconds(let val):
        //                Text("\(formatSeconds(val))")
        //            }
        Text("10:20")
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
        StartExerciseView()
            .preferredColorScheme(.dark)
    }
    .tint(.primary)
    
}
