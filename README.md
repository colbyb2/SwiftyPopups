# SwiftyPopups

SwiftyPopups adds an extremely intuitive SwiftUI API for popups.

Easily add a centered modal, alert, or notfication to any view.
Customize the entrance and exit animations in one simple line.


## Docs

### Installation

1. Open XCode
2. File -> Add Packages...
3. Enter url `https://github.com/colbyb2/SwiftyPopups.git`

### Getting Started

Start by importing the library with `import SwiftyPopups`

This module contains all the modifiers and template popups.

For a simple popup, add the `.popup()` modifier to the view that you want to be the base.
This modifier takes a few parameters:
- **show**: This paramter binds to a boolean state value that will control whether the popup is shown
- **animate**: (Optional) Takes a [PopupAnimation](#PopupAnimation) struct that tells the popup how to enter the screen and what animation style to use.
- **popup**: This view will be displayed as the actual popup

Example:

```
public struct MyView: View {
    @State var show: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button("Toggle Popup") {
                show.toggle()
            }
        }
        .popup(show: $show) {
            VStack {
                Text("Popup!")
                Button("Dismiss") { show.toggle() }
            }
            .padding()
            .background(Color.white)
        }
    }
}
```

This code will create a simple popup with default animation styles (linear slide from the bottom).

To customize the animation, create a [PopupAnimation](#PopupAnimation) object and pass it into the animate parameter.

Example:
`let animation: PopupAnimation = PopupAnimation(type: .fromTop, animation: .easeIn(duration: 1.0))`

This will make the popup slide down from the top by easing in over 1 second.



### PopupAnimation

This object takes two values, a type and an animation. The type uses the AnimationType enum.
This enum contains 6 values: fromTop, fromBottom, fromLeft, fromRight, fade, and none.

The animation type simply takes any of SwiftUI's native animation styles, i.e. linear, easeInOut, etc.
