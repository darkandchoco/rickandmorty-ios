import XCTest
import Combine
@testable import CommonUI
@testable import CommonCore

class CharactersMainViewModelTests: XCTestCase {
    var viewModel: CharactersMainViewModelImplementation!
    var mockCharactersService: MockCharactersService!
    var mockDelegate: MockCharactersMainViewModelDelegate!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockCharactersService = MockCharactersService()
        mockDelegate = MockCharactersMainViewModelDelegate()
        cancellables = []
        viewModel = CharactersMainViewModelImplementation(charactersService: mockCharactersService)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockCharactersService = nil
        mockDelegate = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_initialState_isLoadingTrue() {
        XCTAssertTrue(viewModel.isLoading, "isLoading should be true initially")
    }
    
    func test_charactersLoadSuccessfully() {
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Main", gender: "Male", origin: "Earth", location: "Earth", image: "url")
        ]
        mockCharactersService.mockCharacters = expectedCharacters
        let expectation = XCTestExpectation(description: "Characters are loaded successfully")
        viewModel.$characters
            .sink { characters in
                if !characters.isEmpty {
                    XCTAssertEqual(characters.count, expectedCharacters.count, "The number of characters should match")
                    XCTAssertEqual(characters.first?.name, "Rick", "The first character's name should be Rick")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.getCharacters()
        wait(for: [expectation], timeout: 5)
    }
    
    func test_charactersLoadFailure() {
        mockCharactersService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        let expectation = XCTestExpectation(description: "Loading state updates after error")
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    XCTAssertFalse(isLoading, "isLoading should be false after error")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.getCharacters()
        wait(for: [expectation], timeout: 5)
    }
    
    func test_didTapRow_callsDelegate() {
        let character = Character(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Main", gender: "Male", origin: "Earth", location: "Earth", image: "url")
        viewModel.didTapRow(character: character)
        XCTAssertTrue(mockDelegate.didTapRowCalled, "The delegate method should be called when a row is tapped")
        XCTAssertEqual(mockDelegate.receivedCharacter?.name, "Morty", "The correct character should be passed to the delegate")
    }
    
    func test_charactersUpdateAfterFetch() {
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Main", gender: "Male", origin: "Earth", location: "Earth", image: "url")
        ]
        mockCharactersService.mockCharacters = expectedCharacters
        let expectation = XCTestExpectation(description: "Characters update after fetch")
        viewModel.$characters
            .sink { characters in
                if !characters.isEmpty {
                    XCTAssertEqual(characters.count, expectedCharacters.count, "The number of characters should match after fetch")
                    XCTAssertEqual(characters.first?.name, "Rick", "The first character's name should match the mock data")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.getCharacters()
        wait(for: [expectation], timeout: 5)
    }
}

class MockCharactersService: CharactersService {
    var mockCharacters: [Character] = []
    var mockError: Error?
    
    func getCharacters() -> AnyPublisher<[Character], Error> {
        if let error = mockError {
            return Fail(outputType: [Character].self, failure: error)
                .eraseToAnyPublisher()
        }
        return Just(mockCharacters)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchCharacters() {
        _ = getCharacters()
    }
}

class MockCharactersMainViewModelDelegate: CharactersMainViewModelDelegate {
    var didTapRowCalled = false
    var receivedCharacter: Character?
    
    func charactersMainViewDidTapRow(character: Character) {
        didTapRowCalled = true
        receivedCharacter = character
    }
}
