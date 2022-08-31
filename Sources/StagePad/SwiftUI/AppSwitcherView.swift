import SwiftUI

struct AppSwitcherView: View {
    var body: some View {
        VStack {
            AppSwitcherAppListView(apps: [
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
                .init(),
            ])
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
    }
}

struct AppSwitcherApp: Identifiable {
    var id = UUID()
    var previewImage: UIImage = .init(named: "default")!
    var title: String = "Settings"
    var icon: UIImage = .init(named: "icon")!
}

struct AppSwitcherAppListView: View {
    var apps: [AppSwitcherApp]
    
    var body: some View {
        ListWithoutSepatorsAndMargins {
            ForEach(apps) {
                AppSwitcherAppView(app: $0, showTitle: true)
                    .listStyle(SidebarListStyle())
                    .background(.clear)
            }
        }
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