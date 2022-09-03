import SwiftUI

struct AppSwitcherView: View {
    @State var apps: [AppSwitcherApp]
    var body: some View {
        VStack {
            AppSwitcherAppListView(apps: apps)
            Spacer()
        }
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
    var previewImage: UIImage!
    var title: String!
    var icon: UIImage!

    init(previewImage: UIImage, title: String, icon: UIImage) {
        self.previewImage = previewImage
        self.title = title
        self.icon = icon
    }
}


struct AppSwitcherAppView: View {
    var app: AppSwitcherApp
    var showTitle: Bool
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            HStack {
                Image(uiImage: app.previewImage)
                    .resizable()
                    .frame(width: 90, height: 130)
                    .rotation3DEffect(Angle(degrees: 10), axis: (x: 0, y: 1, z: 0))
                    .padding()
            }
            Image(uiImage: app.icon)
                .resizable()
                .frame(width: 30, height: 30)
                .cornerRadius(8)
                .offset(x: 10)
            
        }
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