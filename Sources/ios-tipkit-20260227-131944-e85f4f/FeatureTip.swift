import SwiftUI
import TipKit

struct AddTaskTip: Tip {
    @Parameter
    static var taskCount: Int = 0

    var title: Text {
        Text("Seed your board")
    }

    var message: Text? {
        Text("Start by adding a sample task. More contextual tips appear as you progress.")
    }

    var image: Image? {
        Image(systemName: "plus.circle.fill")
    }

    var rules: [Rule] {
        #Rule(Self.$taskCount) { count in
            count == 0
        }
    }
}

struct CompleteTaskTip: Tip {
    @Parameter
    static var taskCount: Int = 0

    @Parameter
    static var completedTaskCount: Int = 0

    var title: Text {
        Text("Complete your first task")
    }

    var message: Text? {
        Text("Select a task and mark it done to unlock focus-session guidance.")
    }

    var image: Image? {
        Image(systemName: "checkmark.seal.fill")
    }

    var rules: [Rule] {
        #Rule(Self.$taskCount) { count in
            count > 0
        }
        #Rule(Self.$completedTaskCount) { count in
            count == 0
        }
    }
}

struct FocusSessionTip: Tip {
    @Parameter
    static var completedTaskCount: Int = 0

    @Parameter
    static var isSessionRunning: Bool = false

    var title: Text {
        Text("Start a focus sprint")
    }

    var message: Text? {
        Text("Use the timer to run a focused sprint on your active task.")
    }

    var image: Image? {
        Image(systemName: "timer")
    }

    var rules: [Rule] {
        #Rule(Self.$completedTaskCount) { count in
            count > 0
        }
        #Rule(Self.$isSessionRunning) { running in
            running == false
        }
    }
}

struct ResetBoardTip: Tip {
    @Parameter
    static var taskCount: Int = 0

    var title: Text {
        Text("Keep your board tidy")
    }

    var message: Text? {
        Text("After a few tasks, reset the board and start a fresh cycle.")
    }

    var image: Image? {
        Image(systemName: "arrow.counterclockwise.circle")
    }

    var rules: [Rule] {
        #Rule(Self.$taskCount) { count in
            count >= 3
        }
    }
}

struct StreakTip: Tip {
    @Parameter
    static var completedTaskCount: Int = 0

    var title: Text {
        Text("Streak unlocked")
    }

    var message: Text? {
        Text("Two tasks complete. Keep momentum with a focus sprint.")
    }

    var image: Image? {
        Image(systemName: "sparkles")
    }

    var rules: [Rule] {
        #Rule(Self.$completedTaskCount) { count in
            count >= 2
        }
    }
}
