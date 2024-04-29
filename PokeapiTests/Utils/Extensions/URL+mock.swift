//
//  URL+mock.swift
//  PokeapiTests
//
//  Created by eli on 29/04/24.
//

import Foundation

extension URL {
    
    static func compareURLs(leftURLString: String, rightURLString: String) -> Bool {
        guard let leftURL = URL.init(string: leftURLString),
              let rightURL = URL.init(string: rightURLString) else {
            return true
        }
        
        return leftURL.compareComponents(rightURL)
    }
    
    /// Compares components, which doesn't require query parameters to be in any particular order
    public func compareComponents(_ url: URL) -> Bool {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return false }
        
        return components.scheme == urlComponents.scheme &&
        components.host == urlComponents.host &&
        components.path == urlComponents.path &&
        components.queryItems?.enumerated().compactMap { $0.element.name }.sorted() == urlComponents.queryItems?.enumerated().compactMap { $0.element.name }.sorted() &&
        components.queryItems?.enumerated().compactMap { $0.element.value }.sorted() == urlComponents.queryItems?.enumerated().compactMap { $0.element.value }.sorted()
    }
}
