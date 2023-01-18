import SwiftUI

//TESTING
public struct PopUpView: View {
    
    @State var showPopup: Bool = false
    
    public var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea(.all)
                .notificationPopup(show: $showPopup, location: .bottom, animation: .linear(duration: 0.5)) {
                    ZStack{
                        Color.white
                            .ignoresSafeArea(.all)
                            .frame(maxHeight: 50)
                        Text("Test")
                    }
                }
            Text("TEST")
                .onTapGesture {
                    showPopup.toggle()
                }
        }
    }
}

struct View_Preview: PreviewProvider {

    static var previews: some View {
        PopUpView()
    }
}
//END TESTING

public struct NotificationPopup: View {
    public var body: some View {
        Text("")
    }
}
//Actual Modifier
private struct NotificationModifier<PopUp: View>: ViewModifier {
    @Binding var show: Bool
    let location: PopupLocation
    let animation: Animation
    let Popup: () -> PopUp
    
    //Internal
    @State var height: CGFloat = 0
    @State var multiplier: CGFloat = -1
    @State var hideOffset: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var initialLoad: Bool = true
    
    func body(content: Content) -> some View {
        GeometryReader {reader in
            ZStack {
                content
                if (!initialLoad){
                    Popup()
                        .getHeight(height: $height)
                        .offset(y: offset)
                        .animation(animation, value: offset)
                        .onChange(of: show) { _ in
                            offset = show ? ( multiplier * reader.size.height / 2) - ( multiplier * height / 2) : hideOffset
                        }
                        .onChange(of: height) { _ in
                            offset = show ? ( multiplier * reader.size.height / 2) - ( multiplier * height / 2) : hideOffset
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if (location == .top) {
                                        if (gesture.translation.height < -15) {
                                            show = false
                                        }
                                    } else if (location == .bottom) {
                                        if (gesture.translation.height > 15) {
                                            show = false
                                        }
                                    }
                                }
                                .onEnded { _ in
                                }
                        )
                }
            }
            .onAppear() {
                switch location {
                case .top:
                    multiplier = -1
                    hideOffset = -1 * reader.size.height
                case .bottom:
                    multiplier = 1
                    hideOffset = reader.size.height
                }
                offset = hideOffset
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(10)) {
                    initialLoad = false
                }
            }
        }
    }
}


//Actual Modifier
private struct PopupModifier<PopUp: View>: ViewModifier {
    @Binding var show: Bool
    let Popup: () -> PopUp
    let animate: PopupAnimation
    
    //Internal
    @State var xOffset: CGFloat = 0
    @State var yOffset: CGFloat = 0
    @State var initialLoad: Bool = true
    @State var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        GeometryReader {reader in
            ZStack {
                content
                if (!initialLoad) {
                    if (show || animate.type != .none) {
                        Popup()
                            .offset(x: xOffset, y: yOffset)
                            .opacity(opacity)
                            .animation(animate.animation, value: xOffset)
                            .animation(animate.animation, value: yOffset)
                            .animation(animate.animation, value: opacity)
                            .onChange(of: show) {_ in
                                xOffset = getXOffset(reader.size.width)
                                yOffset = getYOffset(reader.size.height)
                                opacity = getOpacity()
                            }
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
                    initialLoad = false
                }
                xOffset = getXOffset(reader.size.width)
                yOffset = getYOffset(reader.size.height)
                opacity = getOpacity()
            }
        }
    }
    
    //Calculates the correct horizontal offset
    func getXOffset(_ screenWidth: CGFloat) -> CGFloat {
        if (show) { return 0 }
        if (animate.type == .fromLeft) {
            return (-1 * screenWidth)
        }
        else if (animate.type == .fromRight) {
            return screenWidth
        }
        
        return 0
    }
    
    //Calculates the correct vertical offset
    func getYOffset(_ screenHeight: CGFloat) -> CGFloat {
        if (show) { return 0 }
        if (animate.type == .fromTop) {
            return (-1 * screenHeight)
        }
        else if (animate.type == .fromBottom) {
            return screenHeight
        }
        
        return 0
    }
    
    //Calculates the correct opacity
    func getOpacity() -> Double {
        if (animate.type == .fade) {
            return show ? 1.0 : 0
        }
        return 1.0
    }
}

//Internal Modifier for getting Height of view
internal struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

//Adds Modifier to Views
extension View {
    ///Displays a popup over the current view
    public func popup<PopUp: View>(show: Binding<Bool>, animate: PopupAnimation = PopupAnimation(.none, .linear), popup: @escaping () -> PopUp) -> some View {
        self.modifier(PopupModifier(show: show, Popup: popup, animate: animate))
    }
    
    ///Displays a Notification like popup from top or bottom
    public func notificationPopup<PopUp: View>(show: Binding<Bool>, location: PopupLocation = .top, animation: Animation = .linear, popup: @escaping () -> PopUp) -> some View {
        self.modifier(NotificationModifier(show: show, location: location, animation: animation, Popup: popup))
    }
    
    //Internal Modifier
    internal func getHeight(height: Binding<CGFloat>) -> some View {
        self.modifier(GetHeightModifier(height: height))
    }
}

///Used to pass animation specifications
public struct PopupAnimation {
    let type: AnimationType
    let animation: Animation
    
    public init(_ type: AnimationType, _ animation: Animation) {
        self.type = type
        self.animation = animation
    }
}

///Direction of Popup Animation
public enum AnimationType {
    case fromBottom
    case fromTop
    case fromLeft
    case fromRight
    case fade
    case none
}

///Spot of Notification Popup
public enum PopupLocation {
    case top
    case bottom
}
