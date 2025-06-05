import SwiftUI

let trackTexts: [Track: (String, String)] = [
    .constant: (
        "Constant",
        "Each phase of the breathing cycle has same duration throughout the exercise"
    ),
    .increasing: (
        "Increasing",
        "Duration of one of phases of breathing cycle gradually increases over time"
    ),
    .decreasing: (
        "Decreasing",
        "Duration of one of phases of breathing cycle gradually decreases over time"
    ),
    .custom: (
        "Custom",
        "Manually composed exercise"
    )
]

let phaseTitles: [Phase: String] = [
    .in: "Breathe In",
    .inHold: "Breathe In Hold",
    .out: "Breathe Out",
    .outHold: "Breathe Out Hold",
]

let phaseIcons: [Phase: Image] = [
    .in: Image(systemName: "smallcircle.filled.circle"),
    .inHold: Image(systemName: "circle.fill"),
    .out: Image(systemName: "smallcircle.filled.circle.fill"),
    .outHold: Image(systemName: "circle"),
]

func formatSeconds(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}
