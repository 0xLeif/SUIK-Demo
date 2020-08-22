import UIKit
import SwiftUI
import SwiftUIKit
import Later

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        let view: UIView = Label("Loading")
            .font(.largeTitle)
            .text(alignment: .center)
            .number(ofLines: 100)
            .configure { label in
                Later.scheduleRepeatedTask(delay: .seconds(1)) { (task) in
                    Later.main {
                        guard let text = label.text,
                            !text.contains(".....") else {
                                label.clear()
                                task.cancel()
                                return
                        }
                        label.text?.append(".")
                    }
                }
        }
        .padding()
        .background(color: .systemBackground)
        
        let vc = UIViewController { view }
        
        Later.main(withDelay: 5) {
            view
                .clear()
                .embed {
                    List(defaultCellHeight: 120) {
                        (0 ... 1000)
                            .map { _ in
                                ContainerView(parent: vc) {
                                    UIHostingController(rootView:
                                        ContentView()
                                            .foregroundColor([Color.blue,
                                                 Color.red,
                                                 Color.green,
                                                 Color.orange,
                                                 Color.purple,
                                                 Color.black].randomElement())
                                    )
                                }
                        }
                    }
            }
        }
        
        window.rootViewController = UINavigationController(rootViewController: vc)
        self.window = window
        window.makeKeyAndVisible()
    }
    
}
