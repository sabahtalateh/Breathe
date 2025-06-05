import SwiftUI



struct TrackPickerView: View {
    
    @Binding var selectedTrack: Track

    var trackTitle: String {
        trackTexts[selectedTrack]?.0 ?? ""
    }
    
    var trackDescription: String {
        trackTexts[selectedTrack]?.1 ?? ""
    }
    
    var body: some View {
        Section {
            Picker("Exercise Track", selection: $selectedTrack) {
                Image(systemName: "circle.circle").tag(Track.constant)
                Image(systemName: "arrow.up.right").tag(Track.increasing)
                Image(systemName: "arrow.down.right").tag(Track.decreasing)
                Image(systemName: "circle.dotted").tag(Track.custom)
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            
            VStack(alignment: .leading) {
                Text(trackTitle)
                Text(trackDescription)
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            .padding(.top, -4)
        } header: {
            Text("Exercise Track")
        }
    }
}

#Preview {
    Form {
        TrackPickerView(selectedTrack: .constant(Track.constant))
        TrackPickerView(selectedTrack: .constant(Track.increasing))
        TrackPickerView(selectedTrack: .constant(Track.decreasing))
        TrackPickerView(selectedTrack: .constant(Track.custom))
    }
    .preferredColorScheme(.dark)
}
