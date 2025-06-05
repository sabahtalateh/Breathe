import SwiftUI

struct CustomStepper: View {
    
    let label: String
    let icon: Image
    let `in`: ClosedRange<Int>
    
    @Binding var value: Int
    
    var dimLowest: Bool = false
    var replaceValues: [Int: Image] = [:]
    
    var foregroundStyle: HierarchicalShapeStyle {
        dimLowest && value == `in`.lowerBound
        ? .secondary
        : .primary
    }
    
    var valueFontWeight: Font.Weight {
        dimLowest && value == `in`.lowerBound
        ? .regular
        : .bold
    }
    
    var valueText: Text {
        if let repl = replaceValues[value] {
            Text(repl)
        } else {
            Text("\(value)")
        }
    }
    
    var body: some View {
        Stepper(
            value: $value,
            in: `in`,
            label: {
                Label {
                    HStack {
                        Text(label)
                            .foregroundStyle(foregroundStyle)
                        
                        Spacer()
                        
                        // if #available(iOS 17, *) {
                            valueText
                                .fontWeight(valueFontWeight)
                                .foregroundStyle(foregroundStyle)
                                .monospacedDigit()
                                // contentTransition laggy on iOS 16 emulator. check on device
                                // .contentTransition(.numericText())
                        // } else {
                        //     valueText
                        //         .fontWeight(valueFontWeight)
                        //         .foregroundStyle(foregroundStyle)
                        // }
                    }
                } icon: {
                    icon
                        .foregroundStyle(foregroundStyle)
                }
            }
        )
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var value = 1
        
        var body: some View {
            Form {
                CustomStepper(
                    label: "Label",
                    icon: Image(systemName: "circle"),
                    in: 1...10,
                    value: $value,
                    dimLowest: true,
                    replaceValues: [10: Image(systemName: "10.circle.fill")]
                )
            }
            .tint(.primary)
        }
    }
    
    return PreviewContainer()
        .preferredColorScheme(.dark)
}
