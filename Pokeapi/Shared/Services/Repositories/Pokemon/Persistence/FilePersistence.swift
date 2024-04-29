//
//  FilePersistence.swift
//  Pokeapi
//
//  Created by eli on 28/04/24.
//

import Foundation

enum FilePersistenceError: Error {
    case invalidPath
}

class FilePersistence {
    
    func saveData<Object: Encodable>(for object: Object, to path: String) throws {
        guard let documentURL = makeDocumentDirectoryURL(path: path) else {
            throw FilePersistenceError.invalidPath
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .withoutEscapingSlashes
        let data = try jsonEncoder.encode(object)
        
        try data.write(to: documentURL, options: .completeFileProtection)
    }
    
    func loadData<T: Decodable>(from path: String) throws -> T? {
        guard let documentURL = makeDocumentDirectoryURL(path: path) else {
            throw FilePersistenceError.invalidPath
        }
        
        let data = try Data(contentsOf: documentURL)
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
    }
    
    private func makeDocumentDirectoryURL(path: String) -> URL? {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return directoryURL.appendingPathComponent(path)
    }
    
}
