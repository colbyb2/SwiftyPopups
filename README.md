# SwiftyPopups

SwiftyPopups adds an extremely intuitive SwiftUI API for popups.

Easily add a centered modal, alert, or notfication to any view.
Customize the entrance and exit animations in one simple line.

At its simplest, an animated, custom popup can be added with just:
```
.popup(show: $showPopup) {
    MyPopupView()
}
```
Thats it! Check out the documentation for more in depth explanations and examples.

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


### Notification Popup

Another type of popup creates a notification-like display that can either come in from the top or bottom. Using it is similar to a normal popup but uses slightly different syntax.
**Note the `.notificationPopup()` instead of the `.popup()` modifier**

This modifier takes 4 parameters.
- **show**: This is the same as for `.popup()`
- **location**: (Optional) This uses the `PopupLocation` enum and has 2 options, .top and .bottom. This shows the popup on the top or bottom of the screen respectively.
- **animation**: (Optional) This is the same as for `.popup()`, it uses the native Animation types to modify animations of the popup.
- **popup**: Notification Popup View. **Note: For notification popups, I recommend adding the .ignoresSafeArea() modifier to your popup view. This ensures that the notification can flood the corners of the screen and look its best.**

The default location is the top and the default animation is linear.

Example:

```
public struct MyView: View {
    @State var show: Bool = false
    
    var body: some View {
        ZStack {
            Color.white
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button("Toggle Popup") {
                show.toggle()
            }
        }
        .notificationPopup(show: $show) {
            ZStack {
                Color.black
                Text("Notification!")
                    .foregroundColor(.white)
            }
            .ignoresSafeArea(.all)
            .frame(maxHeight: 100)
        }
    }
}
```
