//
//  DocumentsFolderPersistence.swift
//  Pokeapi
//
//  Created by eli on 28/04/24.
//

import Foundation

enum FilePersistenceError: Error {
    case invalidPath
}

protocol FilePersistenceServices: AnyObject {
    func saveData<Object: Encodable>(for object: Object, to path: String) async throws
    func loadData<Object: Decodable>(from path: String) async throws -> Object
}

class DocumentsFolderPersistence: FilePersistenceServices {
    
    func saveData<Object: Encodable>(for object: Object, to path: String) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) -> Void in
            Self.saveData(for: object, to: path) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func loadData<Object: Decodable>(from path: String) async throws -> Object {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Object, Error>) -> Void in
            Self.loadData(from: path) {
                (result: Result<Object, Error>) in
                switch result {
                case .success(let object):
                    continuation.resume(returning: object)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private static func makeDocumentDirectoryURL(path: String) -> URL? {
        guard let directoryURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first else {
            return nil
        }
        
        return directoryURL.appendingPathComponent(path)
    }
        
    private static func saveData<Object: Encodable>(
        for object: Object,
        to path: String,
        completion: @escaping (Error?) -> Void
    ) {
        Task(priority: .background) {
            do {
                guard let documentURL = Self.makeDocumentDirectoryURL(path: path) else {
                    throw FilePersistenceError.invalidPath
                }
                
                print("\n\nFile url: \(documentURL.absoluteString)\n\n")
                let jsonEncoder = JSONEncoder()
                jsonEncoder.outputFormatting = .withoutEscapingSlashes
                let data = try jsonEncoder.encode(object)
                
                try data.write(to: documentURL, options: .completeFileProtection)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    private static func loadData<Object: Decodable>(
        from path: String,
        completion: @escaping (Result<Object, Error>) -> Void
    ) {
        Task(priority: .background) {
            do {
                guard let documentURL = Self.makeDocumentDirectoryURL(path: path) else {
                    throw FilePersistenceError.invalidPath
                }
                
                print("\n\nFile \(path) location: \(documentURL.absoluteString)\n\n")
                let data = try Data(contentsOf: documentURL)
                let decoder = JSONDecoder()
                let result = try decoder.decode(Object.self, from: data)
                
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
