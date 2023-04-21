//
//  PexelsTests.swift
//  MyPexelsTests
//
//  Created by Artem Pavlov on 05.12.2022.
//

import XCTest
@testable import MyPexels

class PexelsTests: XCTestCase {
    
    var sut: Pexels!
    
    override func setUpWithError() throws {
        sut = Pexels(
            page: 1,
            perPage: 20,
            totalResults: 1,
            prevPage: nil,
            nextPage: nil,
            photos: [Photo(
                id: 1,
                width: 1,
                height: 1,
                url: "Foo",
                photographer: "Bar",
                src: Src(
                    original: "aaa",
                    large: "bbb",
                    medium: "ccc",
                    small: "ddd"
                ),
                alt: nil
            )]
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testInitPexelsPhoto() {
        XCTAssertNotNil(sut)
        
        XCTAssertNotNil(sut.page)
        XCTAssertNotNil(sut.perPage)
        XCTAssertNotNil(sut.totalResults)
        XCTAssertNil(sut.prevPage)
        XCTAssertNil(sut.nextPage)
        
        XCTAssertNotNil(sut.photos?.first?.id)
        XCTAssertNotNil(sut.photos?.first?.width)
        XCTAssertNotNil(sut.photos?.first?.height)
        XCTAssertNotNil(sut.photos?.first?.url)
        XCTAssertNotNil(sut.photos?.first?.photographer)
        XCTAssertNil(sut.photos?.first?.alt)
        
        XCTAssertNotNil(sut.photos?.first?.src?.small)
        XCTAssertNotNil(sut.photos?.first?.src?.medium)
        XCTAssertNotNil(sut.photos?.first?.src?.large)
        XCTAssertNotNil(sut.photos?.first?.src?.original)
    }
    
    func testWhenGivenInfoToPexelsPhoto() {
        XCTAssertEqual(sut.page, 1)
        XCTAssertEqual(sut.perPage, 20)
        XCTAssertEqual(sut.totalResults, 1)
        XCTAssertTrue(sut.prevPage == nil)
        XCTAssertTrue(sut.nextPage == nil)
        
        XCTAssertEqual(sut.photos?.count, 1)
        XCTAssertEqual(sut.photos?.first?.id, 1)
        XCTAssertEqual(sut.photos?.first?.width, 1)
        XCTAssertEqual(sut.photos?.first?.height, 1)
        XCTAssertEqual(sut.photos?.first?.url, "Foo")
        XCTAssertEqual(sut.photos?.first?.photographer, "Bar")
        XCTAssertTrue(sut.photos?.first?.alt == nil)
        
        XCTAssertEqual(sut.photos?.first?.src?.original, "aaa")
        XCTAssertEqual(sut.photos?.first?.src?.large, "bbb")
        XCTAssertEqual(sut.photos?.first?.src?.medium, "ccc")
        XCTAssertEqual(sut.photos?.first?.src?.small, "ddd")
    }
}
