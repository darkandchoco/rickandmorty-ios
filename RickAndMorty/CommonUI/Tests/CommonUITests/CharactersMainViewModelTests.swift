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
        // Given
        XCTAssertTrue(viewModel.isLoading, "isLoading should be true initially")
    }
    
    func test_charactersLoadSuccessfully() {
        // Given
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Main", gender: "Male", origin: "Earth", location: "Earth", image: "url")
        ]
        mockCharactersService.mockCharacters = expectedCharacters
        
        // Expectation to wait for async call completion
        let expectation = XCTestExpectation(description: "Characters are loaded successfully")
        
        // Observe the viewModel's characters
        viewModel.$characters
            .sink { characters in
                if !characters.isEmpty {
                    // Assert when characters are loaded
                    XCTAssertEqual(characters.count, expectedCharacters.count, "The number of characters should match")
                    XCTAssertEqual(characters.first?.name, "Rick", "The first character's name should be Rick")
                    expectation.fulfill() // Fulfill the expectation
                }
            }
            .store(in: &cancellables)
        
        // Trigger the viewModel's getCharacters method to initiate the network call
        viewModel.getCharacters()
        
        // Wait for the expectation to be fulfilled or timeout
        wait(for: [expectation], timeout: 5)
    }
    
    func test_charactersLoadFailure() {
        // Given
        mockCharactersService.mockError = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        // Expectation to wait for the loading state to change after failure
        let expectation = XCTestExpectation(description: "Loading state updates after error")
        
        // Observe the viewModel's loading state
        viewModel.$isLoading
            .dropFirst() // Ignore the initial value
            .sink { isLoading in
                if !isLoading {
                    // Assert when loading state becomes false
                    XCTAssertFalse(isLoading, "isLoading should be false after error")
                    expectation.fulfill() // Fulfill the expectation
                }
            }
            .store(in: &cancellables)
        
        // Trigger the viewModel's getCharacters method to initiate the failure
        viewModel.getCharacters()
        
        // Wait for the expectation to be fulfilled or timeout
        wait(for: [expectation], timeout: 5)
    }
    
    func test_didTapRow_callsDelegate() {
        // Given
        let character = Character(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Main", gender: "Male", origin: "Earth", location: "Earth", image: "url")
        
        // When
        viewModel.didTapRow(character: character)
        
        // Then
        XCTAssertTrue(mockDelegate.didTapRowCalled, "The delegate method should be called when a row is tapped")
        XCTAssertEqual(mockDelegate.receivedCharacter?.name, "Morty", "The correct character should be passed to the delegate")
    }
    
    func test_charactersUpdateAfterFetch() {
        // Given
        let expectedCharacters = [
            Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Main", gender: "Male", origin: "Earth", location: "Earth", image: "url")
        ]
        mockCharactersService.mockCharacters = expectedCharacters
        
        // Expectation to wait for async updates
        let expectation = XCTestExpectation(description: "Characters update after fetch")
        
        // Observe the viewModel's characters
        viewModel.$characters
            .sink { characters in
                if !characters.isEmpty {
                    // Assert after characters are loaded
                    XCTAssertEqual(characters.count, expectedCharacters.count, "The number of characters should match after fetch")
                    XCTAssertEqual(characters.first?.name, "Rick", "The first character's name should match the mock data")
                    expectation.fulfill() // Fulfill the expectation
                }
            }
            .store(in: &cancellables)
        
        // Trigger the viewModel's getCharacters method to initiate the fetch
        viewModel.getCharacters()
        
        // Wait for the expectation to be fulfilled or timeout
        wait(for: [expectation], timeout: 5)
    }
}

// MARK: - Mocks

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
    
    // Simulate the fetch operation by calling getCharacters
    func fetchCharacters() {
        _ = getCharacters() // This triggers the flow in viewModel
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
