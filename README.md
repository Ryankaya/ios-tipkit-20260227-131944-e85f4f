# ios-tipkit-20260227-131944-e85f4f

A minimal SwiftUI iOS app that demonstrates TipKit by showing a contextual tip for a primary action and hiding it after the user completes that action once.

## Feature Focus
- Configures TipKit at app launch with immediate display frequency for demo visibility.
- Defines a custom tip (CompleteFirstTaskTip) with a rule tied to a parameter.
- Uses popoverTip in SwiftUI to present guidance on the main call-to-action.
- Includes a reset path that clears TipKit datastore so behavior can be tested repeatedly.

## Apple Documentation Used
- https://developer.apple.com/documentation/tipkit
- https://developer.apple.com/documentation/tipkit/tip
- https://developer.apple.com/documentation/tipkit/tips/configure(_:)

## Run
1. Open ios-tipkit-20260227-131944-e85f4f.xcodeproj in Xcode.
2. Choose an iOS 17+ simulator or device.
3. Build and run, then tap Complete Demo Task to see tip behavior update.
