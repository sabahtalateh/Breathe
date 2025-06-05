import SwiftUI

extension View {
    func onChangeOfDynamicTrack(
        track: DynamicTrack,
        perform action: @escaping () -> Void
    ) -> some View {
        self
            .onChange(of: track.in) { _, _ in action() }
            .onChange(of: track.inHold) { _, _ in action() }
            .onChange(of: track.out) { _, _ in action() }
            .onChange(of: track.outHold) { _, _ in action() }
            .onChange(of: track.dynamicPhase) { _, _ in action() }
            .onChange(of: track.add) { _, _ in action() }
            .onChange(of: track.limit) { _, _ in action() }
    }
}
