//
//  AlamofireClient+GetCharacters.swift
//  RestNetworking
//
//  Created by Richmond and Loren on 2024-11-17.
//
import CommonCore
import Combine
import Foundation

extension AlamofireClient: CharactersClient {
    public func getCharacters(page: Int?) -> AnyPublisher<[CommonCore.Character], any Error> {
        Deferred {
            Future<[CommonCore.Character], Error> { [weak self] promise in
                guard let self = self else {
                    promise(.failure(RequestManager.RequestError.selfDeallocated))
                    return
                }
                self.requestManager.request(RickAndMortyRouter.getCharacters(page: page)) { (result: Result<CharactersResponse, Error>) in
                    switch result {
                    case .success(let response):
                        promise(.success(response.toDomainModel()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
