import SwiftUI
import TipKit

struct DemoTask: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct ContentView: View {
    @State private var tasks: [DemoTask] = []
    @State private var activeTaskID: UUID?
    @State private var isSessionRunning = false
    @State private var secondsRemaining = 15 * 60

    private let sessionLength = 15 * 60
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let addTaskTip = AddTaskTip()
    private let completeTaskTip = CompleteTaskTip()
    private let focusSessionTip = FocusSessionTip()
    private let resetBoardTip = ResetBoardTip()
    private let streakTip = StreakTip()

    private var completedCount: Int {
        tasks.filter(\.isCompleted).count
    }

    private var completionRate: Double {
        guard !tasks.isEmpty else {
            return 0
        }
        return Double(completedCount) / Double(tasks.count)
    }

    private var activeTaskTitle: String {
        guard let id = activeTaskID,
              let task = tasks.first(where: { $0.id == id }) else {
            return "No active task"
        }
        return task.title
    }

    private var sessionTimeText: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.cyan.opacity(0.20), .indigo.opacity(0.18), .mint.opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        summaryCard
                        actionsCard
                        taskBoardCard
                        focusCard
                        streakTipCard
                    }
                    .padding()
                }
            }
            .navigationTitle("TipKit Studio")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            syncTipState()
        }
        .onReceive(ticker) { _ in
            guard isSessionRunning else {
                return
            }
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                endSession()
            }
        }
        .onChange(of: tasks.count) { _, _ in
            syncTipState()
        }
        .onChange(of: completedCount) { _, _ in
            syncTipState()
        }
        .onChange(of: isSessionRunning) { _, _ in
            syncTipState()
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Workflow Snapshot")
                .font(.headline)
                .fontWeight(.bold)

            HStack {
                metric(title: "Tasks", value: "\(tasks.count)")
                Spacer()
                metric(title: "Completed", value: "\(completedCount)")
                Spacer()
                metric(title: "Progress", value: "\(Int(completionRate * 100))%")
            }

            ProgressView(value: completionRate)
                .tint(.green)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white.opacity(0.35), lineWidth: 1)
        )
    }

    private var actionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Guided Actions")
                .font(.headline)

            HStack(spacing: 10) {
                Button {
                    addSampleTask()
                } label: {
                    Label("Add Sample", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .popoverTip(addTaskTip, arrowEdge: .top)

                Button {
                    completeActiveTask()
                } label: {
                    Label("Complete Active", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .popoverTip(completeTaskTip, arrowEdge: .top)
            }

            HStack(spacing: 10) {
                Button {
                    toggleSession()
                } label: {
                    Label(isSessionRunning ? "Pause Session" : "Start Session", systemImage: isSessionRunning ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .popoverTip(focusSessionTip, arrowEdge: .top)

                Button(role: .destructive) {
                    resetBoard()
                } label: {
                    Label("Reset Board", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .popoverTip(resetBoardTip, arrowEdge: .top)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var taskBoardCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Task Board")
                .font(.headline)

            if tasks.isEmpty {
                Text("No tasks yet. Add a sample task to begin the guided flow.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(tasks) { task in
                    HStack(spacing: 10) {
                        Button {
                            activeTaskID = task.id
                        } label: {
                            Image(systemName: activeTaskID == task.id ? "scope" : "circle.dotted")
                                .foregroundStyle(activeTaskID == task.id ? .blue : .secondary)
                        }
                        .buttonStyle(.plain)

                        Text(task.title)
                            .fontWeight(activeTaskID == task.id ? .semibold : .regular)
                            .strikethrough(task.isCompleted, color: .secondary)
                            .foregroundStyle(task.isCompleted ? .secondary : .primary)

                        Spacer()

                        Button {
                            toggleTask(id: task.id)
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(task.isCompleted ? .green : .secondary)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(activeTaskID == task.id ? Color.blue.opacity(0.12) : Color.white.opacity(0.001))
                    )
                }
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var focusCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Focus Session")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active Task")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(activeTaskTitle)
                        .fontWeight(.semibold)
                }

                Spacer()

                Text(sessionTimeText)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(isSessionRunning ? .purple : .primary)
            }

            ProgressView(value: Double(sessionLength - secondsRemaining), total: Double(sessionLength))
                .tint(.purple)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var streakTipCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Inline Tip Surface")
                .font(.headline)
            TipView(streakTip)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func metric(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
    }
    private func addSampleTask() {
        let templates = [
            "Write release notes",
            "Refine animation timing",
            "Localize settings screen",
            "Clean feature flags"
        ]
        let task = DemoTask(title: templates[tasks.count % templates.count])
        tasks.append(task)
        if activeTaskID == nil {
            activeTaskID = task.id
        }
    }

    private func completeActiveTask() {
        guard let id = activeTaskID else {
            return
        }
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }
        tasks[index].isCompleted = true
    }

    private func toggleTask(id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }
        tasks[index].isCompleted.toggle()
    }

    private func toggleSession() {
        if activeTaskID == nil {
            activeTaskID = tasks.first?.id
        }
        isSessionRunning.toggle()
    }

    private func endSession() {
        isSessionRunning = false
        secondsRemaining = sessionLength
        completeActiveTask()
    }

    private func resetBoard() {
        isSessionRunning = false
        secondsRemaining = sessionLength
        tasks.removeAll()
        activeTaskID = nil

        do {
            try Tips.resetDatastore()
            try Tips.configure([
                .displayFrequency(.immediate)
            ])
        } catch {
            print("Unable to reset TipKit datastore: \(error)")
        }
    }

    private func syncTipState() {
        AddTaskTip.taskCount = tasks.count
        CompleteTaskTip.taskCount = tasks.count
        CompleteTaskTip.completedTaskCount = completedCount
        FocusSessionTip.completedTaskCount = completedCount
        FocusSessionTip.isSessionRunning = isSessionRunning
        ResetBoardTip.taskCount = tasks.count
        StreakTip.completedTaskCount = completedCount
    }
}

#Preview {
    ContentView()
}
