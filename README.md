# ios-tipkit-20260227-131944-e85f4f

A richer SwiftUI iOS demo for **TipKit** that uses a productivity board + focus timer and surfaces multiple tips as the user progresses.

## What This Demonstrates
- Multiple **popover tips** attached to different buttons:
  - Add sample task
  - Complete active task
  - Start focus session
  - Reset board
- One **inline tip** (`TipView`) for streak/momentum feedback.
- Rule-driven visibility using TipKit `@Parameter` values (task count, completed count, session state).
- Reconfiguring and resetting TipKit datastore to replay the full tip journey.

## Tip Flow
1. Empty board shows the **AddTaskTip**.
2. After tasks exist, **CompleteTaskTip** guides first completion.
3. Once a task is completed, **FocusSessionTip** appears for timer guidance.
4. With 3+ tasks, **ResetBoardTip** appears.
5. With 2+ completed tasks, the inline **StreakTip** appears.

## Apple Documentation Used
- https://developer.apple.com/documentation/tipkit
- https://developer.apple.com/documentation/tipkit/tip
- https://developer.apple.com/documentation/tipkit/tipview
- https://developer.apple.com/documentation/swiftui/view/popovertip(_:arrowedge:)
- https://developer.apple.com/documentation/tipkit/tips/configure(_:)

## Run
1. Open `ios-tipkit-20260227-131944-e85f4f.xcodeproj` in Xcode.
2. Choose an iOS 17+ simulator or device.
3. Build and run.
4. Follow the guided actions to trigger each TipKit surface.
