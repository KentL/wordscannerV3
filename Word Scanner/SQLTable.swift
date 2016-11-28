//
//  SQLTable.swift
//  Word Scanner
//
//  Created by Kent Li on 2016-11-08.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import Foundation
protocol SQLTable {
    static var createStatement: String { get }
}