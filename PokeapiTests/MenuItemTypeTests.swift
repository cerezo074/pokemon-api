//
//  MenuItemTypeTests.swift
//  PokeapiTests
//
//  Created by eli on 23/04/24.
//

import XCTest
@testable import Pokeapi

final class MenuItemTypeTests: XCTestCase {

    func test_initName_whenRawValueIsUnknown_thenReturnsNil() throws {
        XCTAssertNil(MenuItemType.init(name: "Unknown"))
    }
    
    func test_initName_whenRawValueIsHOME_thenReturnsHomeType() throws {
        XCTAssertEqual(MenuItemType.init(name: "HOME"), .home)
    }

}
