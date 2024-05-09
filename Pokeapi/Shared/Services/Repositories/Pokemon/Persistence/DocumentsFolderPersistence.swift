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
    func saveData<Object: Encodable>(for object: Object, to path: String, completion: @escaping (Error?) -> Void)
    func loadData<Object: Decodable>(from path: String, completion: @escaping (Result<Object, Error>) -> Void)
}

class DocumentsFolderPersistence: FilePersistenceServices {
    
    func saveData<Object: Encodable>(for object: Object, to path: String, completion: @escaping (Error?) -> Void) {
        Task(priority: .background) {
            do {
                guard let documentURL = makeDocumentDirectoryURL(path: path) else {
                    throw FilePersistenceError.invalidPath
                }
                
                print("\n\nItem url: \(documentURL.absoluteString)\n\n")
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
    
    func loadData<Object: Decodable>(from path: String, completion: @escaping (Result<Object, Error>) -> Void) {
        Task(priority: .background) {
            do {
                guard let documentURL = makeDocumentDirectoryURL(path: path) else {
                    throw FilePersistenceError.invalidPath
                }
                
                print("\n\nItem url: \(documentURL.absoluteString)\n\n")
                let data = try Data(contentsOf: documentURL)
                let decoder = JSONDecoder()
                let result = try decoder.decode(Object.self, from: data)
                
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func makeDocumentDirectoryURL(path: String) -> URL? {
        guard let directoryURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first else {
            return nil
        }
        
        return directoryURL.appendingPathComponent(path)
    }
    
}
