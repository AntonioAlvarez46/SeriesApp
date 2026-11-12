import SwiftUI

@main struct MyApp: App {
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: container.makeSearchViewModel(), makeDetailViewModel: { [container] show in
                container.makeShowDetailViewModel(show: show)
            })
        }
    }
}
