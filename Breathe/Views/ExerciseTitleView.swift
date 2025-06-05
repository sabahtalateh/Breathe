import SwiftUI

struct ExerciseTitleView: View {
    
    @Binding var title: String
    
    var body: some View {
        Section {
            TextField("Exercise Title", text: $title)
        } header: {
            Text("Exercise Title")
        }
    }
}

#Preview {
    Form {
        ExerciseTitleView(title: .constant("Exercise 911"))
    }
    .preferredColorScheme(.dark)
}
