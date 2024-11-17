import Foundation
import Combine
import UIKit
import SwiftUI
import CommonCore

public typealias NetworkingClient = CharactersClient
public typealias CacheClient = CharactersCacheService

public final class CharactersCoordinator {
    private let navigationController: UINavigationController
    private let networkingClient: NetworkingClient
    private let cacheClient: CacheClient
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var state: State = .idle
    
    enum State {
        case idle
        case mainView
        case detailView(character: Character)
    }
    
    public init(navigationController: UINavigationController,
                networkingClient: NetworkingClient,
                cacheClient: CacheClient) {
        self.navigationController = navigationController
        self.networkingClient = networkingClient
        self.cacheClient = cacheClient
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
        case .detailView(let character):
            pushDetailView(character: character)
        }
    }
    
    private func pushMainView() {
        let charactersService = RemoteCharactersService(client: networkingClient,
                                                        cacheService: cacheClient)
        let vm = CharactersMainViewModelImplementation(charactersService: charactersService)
        vm.delegate = self
        let vc = UIHostingController(rootView: CharactersMainView(viewModel: vm))
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func pushDetailView(character: Character) {
        let vm = CharacterDetailViewModelImplementation(character: character)
        let vc = UIHostingController(rootView: CharacterDetailView(viewModel: vm))
        navigationController.pushViewController(vc, animated: true)
    }
}

extension CharactersCoordinator: CharactersMainViewModelDelegate {
    func charactersMainViewDidTapRow(character: Character) {
        state = .detailView(character: character)
    }
}
