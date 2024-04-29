//
//  Result+hashable.swift
//  PokeapiTests
//
//  Created by eli on 29/04/24.
//

import Foundation

extension Result where Success: Hashable {
    var hashValue: Int {
        switch self {
        case .success(let data):
            return data.hashValue
        case .failure(let error):
            return error.localizedDescription.hashValue
        }
    }
}
