import SwiftUI

struct AppSwitcherView: View {
    @EnvironmentObject var appsData: AppsData

    var body: some View {
        HStack {
            AppSwitcherAppListView()
            VStack {
                if appsData.apps.count > 0, let image = appsData.apps[0].previewImage {
                    Image(uiImage: image)
                }
                // if appsData.apps.count > 1, let image = appsData.apps[1].previewImage {
                //     Image(uiImage: image)
                // }
            }
        }
    }
}

struct AppSwitcherAppListView: View {
    @EnvironmentObject var appsData: AppsData
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if appsData.apps.count > 1 {
                LazyVStack {
                    ForEach(Array(appsData.apps[1...])) {
                        AppSwitcherAppView(app: $0, showTitle: true)
                            .listStyle(SidebarListStyle())
                            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.008)))
                    }
                }
            }
        }
    }
}

class AppsData: ObservableObject {
    @Published var apps: [AppSwitcherApp] = []
}

class AppSwitcherApp : NSObject, Identifiable {
    var id = UUID()
    var previewImage: UIImage?
    var title: String!
    var icon: UIImage!
    var bundleID: String

    init(previewImage: UIImage, title: String, icon: UIImage, bundleID: String) {
        self.previewImage = previewImage
        self.title = title
        self.icon = icon
        self.bundleID = bundleID
    }
}


struct AppSwitcherAppView: View {
    var app: AppSwitcherApp
    var showTitle: Bool

    func effectAmplification(_ y: CGFloat) -> CGFloat {
        let k = y / UIScreen.main.bounds.height
        let res = pow((k - 0.5), 2)
        return res
    }

    func rotationAngle(_ y: CGFloat) -> CGFloat {
        let strength: CGFloat = 70.0
        return effectAmplification(y) * strength + 10
    }

    func alpha(_ y: CGFloat) -> CGFloat {
        return 1 - effectAmplification(y) * 2.5
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottomLeading) {
                if app.previewImage != nil {
                    Image(uiImage: app.previewImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 130)
                        .clipped()
                        .cornerRadius(6)
                        .rotation3DEffect(Angle(degrees: rotationAngle(reader.frame(in: .global).midY)), axis: (x: 0, y: 1, z: 0))
                        .shadow(radius: 5)
                }
                Image(uiImage: app.icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(8)
                    .offset(x: 10)
                    
            }
            .opacity(alpha(reader.frame(in: .global).midY))
            .padding(20)
        }
        .frame(width: 90, height: 130)
    }
}

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct ListWithoutSepatorsAndMargins<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                self.content()
            }
            .buttonStyle(NoButtonStyle())
        }
    }
}