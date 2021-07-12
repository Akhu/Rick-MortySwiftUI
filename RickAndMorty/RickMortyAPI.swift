//
//  RickMortyAPI.swift
//  RickAndMorty
//
//  Created by Anthony Da Cruz on 12/01/2021.
//

import Foundation
import Combine

public class RickMortyAPI : ObservableObject {
    
    public init(){
        print(fetchedCharacterList)
    }
    
    @Published var fetchedCharacterList: [Character] = [Character]()
    @Published var error : Error? = nil
    @Published var isFetching : Bool = true

    
    var cancellable : Set<AnyCancellable> = Set()
    
    public func fetchRickMortyCharacterList() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api/character"
        
        print(urlComponents.url?.absoluteURL)
        guard let url = urlComponents.url else { return }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print("invalid status")
                    throw NSError()
                }
                //print(String(data: data, encoding: .utf8))
                return data
            }
            .decode(type: CharacterListResult.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let catchedError):
                    print(catchedError)
                    self.error = catchedError
                    break
                case .finished:
                    self.error = nil
                    break
                }
            }, receiveValue: { characterListData in
                if let charactersListUnwrapped = characterListData.results{
                    self.fetchedCharacterList = charactersListUnwrapped
                }
                self.isFetching = false
            })
            .store(in: &cancellable)
    }
}



// MARK: - CharacterListResult
struct CharacterListResult: Codable {
    let info: Info?
    let results: [Character]?
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Character: Codable, Identifiable, Hashable {
    static func == (lhs: Character, rhs: Character) -> Bool {
       return lhs.hashValue == rhs.hashValue
    }
    
    let id: Int?
    let name, status, species, type: String?
    let gender: String?
    let origin, location: Location?
    let image: String?
    let url: String?
    let created: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id ?? Int.random(in: 0...1000))
        hasher.combine(name)
    }

}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
}
