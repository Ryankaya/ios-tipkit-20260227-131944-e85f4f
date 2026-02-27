import SwiftUI
import TipKit

struct ContentView: View {
    @State private var completedCount = 0
    private let firstTaskTip = CompleteFirstTaskTip()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Completed Demo Tasks: \(completedCount)")
                    .font(.title3)
                    .fontWeight(.semibold)

                Button("Complete Demo Task") {
                    completeTask()
                }
                .buttonStyle(.borderedProminent)

                Button("Reset Tip Demo") {
                    resetDemo()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .navigationTitle("TipKit Demo")
        }
        .popoverTip(firstTaskTip, arrowEdge: .top)
    }

    private func completeTask() {
        completedCount += 1
        CompleteFirstTaskTip.completedFirstTask = true
    }

    private func resetDemo() {
        completedCount = 0
        CompleteFirstTaskTip.completedFirstTask = false

        do {
            try Tips.resetDatastore()
            try Tips.configure([
                .displayFrequency(.immediate)
            ])
        } catch {
            print("Unable to reset TipKit demo: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
