//
//  StudioGhibiliTutAppTests.swift
//  StudioGhibiliTutAppTests
//
//  Created by Terrance Griffith on 1/5/26.
//

import Foundation
import Testing
@testable import StudioGhibiliTutApp


struct StudioGhibiliTutAppTests {
    
    actor MockGhibliService: GhibliService {
                
        let mockFilms: [Film]
        let shouldThrowError: Bool
        let fetchDelay: Duration
        
        var fetchCallCount = 0
        var lastSearchQuery: String? = nil
        
        init(mockFilms: [Film],
             shouldThrowError: Bool = false,
             fetchDelay: Duration = .zero) {
            self.mockFilms = mockFilms
            self.shouldThrowError = shouldThrowError
            self.fetchDelay = fetchDelay
        }
        
        func fetchFilms() async throws -> [Film] {
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            return mockFilms
        }
        
        func searchFilm(for searchTerm: String) async throws -> [Film] {
            
            self.fetchCallCount += 1
            self.lastSearchQuery = searchTerm
            
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            try Task.checkCancellation()
            
            if searchTerm.isEmpty {
                return mockFilms
            }
            
            return mockFilms.filter { film in
                film.title.localizedStandardContains(searchTerm)
            }
        }
        
        func fetchPerson(from URLString: String) async throws -> Person {
                    
            return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", films: [], species: "", url: "")
        }
        
    }
    
    let mockFilms = [
        Film(
            id: "1",
            title: "My Neighbor Totoro",
            description: "Two sisters discover Totoro",
            director: "Hayao Miyazaki",
            producer: "Isao Takahata",
            image: "",
            bannerImage: "",
            people: [],
            releaseYear: "1988",
            duration: "",
            score: "93"
        ),
        Film(
            id: "2",
            title: "Spirited Away",
            description: "A girl enters a spirit world",
            director: "Hayao Miyazaki",
            producer: "Toshio Suzuki",
            image: "",
            bannerImage: "",
            people: [],
            releaseYear: "2001",
            duration: "",
            score: "97"
        ),
        Film(
            id: "3",
            title: "Princess Mononoke",
            description: "A prince fights to save the forest",
            director: "Hayao Miyazaki",
            producer: "Toshio Suzuki",
            image: "",
            bannerImage: "",
            people: [],
            releaseYear: "1997",
            duration: "",
            score: "99"
        )
    ]

    @MainActor
    @Test func testInitialState() async throws {
        let service = MockGhibliService(mockFilms: mockFilms)
        let viewModel = SearchViewModel(ghibliService: service)
        
        #expect(viewModel.state.data == nil)
        
        if viewModel.state == .idle {
            
        } else {
            Issue.record("Expected idle state")
        }
    }
    
    @MainActor
    @Test("Search with query parameters")
    func testSearchWithQuery() async throws {
        
        let service = MockGhibliService(mockFilms: mockFilms)
        let searchViewModel = SearchViewModel(ghibliService: service)
        
        await searchViewModel.fetch(for: "Totoro")
        
        #expect(searchViewModel.state.data?.count == 1)
        #expect(searchViewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
    
    @MainActor
    @Test("Search gives error")
    func testSearchWithError() async throws {
        
        let service = MockGhibliService(mockFilms: mockFilms, shouldThrowError: true)
        let searchViewModel = SearchViewModel(ghibliService: service)
        
        await searchViewModel.fetch(for: "Totoro")
        
        #expect(searchViewModel.state.error != nil)
    }

    @MainActor
    @Test("Cancellation after API call prevents state update")
    func testCancellationAfterAPICall() async {
        
        let service = MockGhibliService(mockFilms: mockFilms,
                                                fetchDelay: .milliseconds(100))
        let viewModel = SearchViewModel(ghibliService: service)
        
        let task = Task {
            print("started task")
            await viewModel.fetch(for: "tot")
        }
 
        try? await Task.sleep(for: .milliseconds(550))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "tot")
        #expect(viewModel.state.error != nil)
    }

    @MainActor
    @Test("Test task is not called too frequently")
    func testDebounceTiming() async {
        
        let service = MockGhibliService(mockFilms: mockFilms, fetchDelay: .milliseconds(100))
        let viewModel = SearchViewModel(ghibliService: service)
        
        let searchQueries = ["t","to","tot","toto","totor","totoro"]
        var tasks = [Task<Void, Never>]()
        
        for query in searchQueries {
            // Cancel the previous task
            tasks.last?.cancel()
            
            let task = Task {
                await viewModel.fetch(for: query)
            }
            
            tasks.append(task)
            try? await Task.sleep(for: .milliseconds(50))
        }
        
                
        // In order to get the info we need to wait for `task.value`
        await tasks.last?.value
    
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1, "Only the final call should execute")
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "totoro", "Should only have the final query")
        
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
    
    @MainActor
    @Test("Test task is called slowly")
    func testDebounceWithSlowMultipleSearches() async {
        
        let service = MockGhibliService(mockFilms: mockFilms, fetchDelay: .milliseconds(100))
        let viewModel = SearchViewModel(ghibliService: service)
        
        let searchQueries = ["t","toto","totoro"]
        var tasks = [Task<Void, Never>]()
        
        for query in searchQueries {
            // Cancel the previous task
            tasks.last?.cancel()
            
            let task = Task {
                await viewModel.fetch(for: query)
            }
            
            tasks.append(task)
            try? await Task.sleep(for: .milliseconds(550))
        }
        
                
        // In order to get the info we need to wait for `task.value`
        await tasks.last?.value
    
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 3, "All searches should execute")
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "totoro", "Should only have the final query")
        
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
}
