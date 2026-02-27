import SwiftUI
import TipKit

struct CompleteFirstTaskTip: Tip {
    @Parameter
    static var completedFirstTask: Bool = false

    var title: Text {
        Text("Try the demo action")
    }

    var message: Text? {
        Text("Tap Complete Demo Task once. TipKit will hide this tip after your first completion.")
    }

    var image: Image? {
        Image(systemName: "lightbulb.max")
    }

    var rules: [Rule] {
        #Rule(Self.$completedFirstTask) {
            $0 == false
        }
    }
}
