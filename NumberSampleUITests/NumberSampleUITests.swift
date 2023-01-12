//
//  NumberSampleUITests.swift
//  NumberSampleUITests
//
//  Created by Benoit PASQUIER on 28/10/2021.
//

import XCTest

class IntegerTFUITests: XCTestCase {

    func testIntegerTF() throws {
        let app = XCUIApplication()
        app.launch()
        
        let integerTF = app.collectionViews/*@START_MENU_TOKEN@*/.textFields["IntegerTF"]/*[[".cells",".textFields[\"empty\"]",".textFields[\"IntegerTF\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(integerTF.exists)
        integerTF.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        XCTAssertEqual(integerTF.value as? String, "55")
        key.tap()
        key.tap()
        XCTAssertEqual(integerTF.value as? String, "5,555")
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["Delete"]/*[[".keyboards.keys[\"Delete\"]",".keys[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        XCTAssertEqual(integerTF.value as? String, "empty") //empty is placeholder text
    }
}
