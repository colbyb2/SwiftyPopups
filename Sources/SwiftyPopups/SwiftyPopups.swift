import SwiftUI

//TESTING
public struct PopUpView: View {
    
    @State var showPopup: Bool = false
    
    public var body: some View {
        VStack {
            Button("Toggle") { showPopup.toggle() }
            Color.blue
                .ignoresSafeArea(.all)
                .popup(show: $showPopup, animate: PopupAnimation(.fromBottom, .linear)) {
                    AlertBox()
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

//Adds Modifier to Views
extension View {
    ///Displays a popup over the current view
    public func popup<PopUp: View>(show: Binding<Bool>, animate: PopupAnimation = PopupAnimation(.none, .linear), popup: @escaping () -> PopUp) -> some View {
        self.modifier(PopupModifier(show: show, Popup: popup, animate: animate))
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
