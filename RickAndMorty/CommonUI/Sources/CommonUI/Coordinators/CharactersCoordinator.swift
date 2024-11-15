import Foundation
import Combine
import UIKit
import SwiftUI

public final class CharactersCoordinator {
    private let navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var state: State = .idle
    
    enum State {
        case idle
        case mainView
        case detailView
    }
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.setupBindings()
    }
    
    public func start() {
        state = .mainView
    }
    
    private func setupBindings() {
        $state
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.handleState()
            })
            .store(in: &cancellables)
    }
    
    private func handleState() {
        switch self.state {
        case .idle: break
        case .mainView:
            pushMainView()
        case .detailView:
            pushDetailView()
        }
    }
    
    private func pushMainView() {
        let vm = CharactersMainViewModelMock()
        let vc = UIHostingController(rootView: CharactersMainView(viewModel: vm))
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func pushDetailView() {
        
    }
}
