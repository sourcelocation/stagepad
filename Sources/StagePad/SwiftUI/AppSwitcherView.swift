import SwiftUI

struct AppSwitcherView: View {
    @State var apps: [AppSwitcherApp]
    
    var body: some View {
        HStack {
            // Text("Hi")
            AppSwitcherAppListView(apps: apps)
                .onChange(of: apps, perform: { _ in
                    remLog("apps!!!", apps)
                })
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

struct AppSwitcherAppListView: View {
    @State var apps: [AppSwitcherApp]
    
    var body: some View {
        ListWithoutSepatorsAndMargins {
            ForEach(apps) {
                AppSwitcherAppView(app: $0, showTitle: true)
                    .listStyle(SidebarListStyle())
                    .background(Color.clear)
            }
        }
    }
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

                Text("aaa")
                if app.previewImage != nil {
                    Image(uiImage: app.previewImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 130)
                    .clipped()
                    .cornerRadius(6)
                    .rotation3DEffect(Angle(degrees: rotationAngle(reader.frame(in: .global).midY)), axis: (x: 0, y: 1, z: 0))
                    .shadow(radius: 5)
                    .padding()
                }
                Image(uiImage: app.icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(8)
                    .offset(x: 10)
                    
            }
            .opacity(alpha(reader.frame(in: .global).midY))
        }
        .frame(width: 90, height: 130)
        .padding()
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