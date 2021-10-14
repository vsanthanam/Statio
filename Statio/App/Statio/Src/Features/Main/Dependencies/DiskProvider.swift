//
// Statio
// Varun Santhanam
//

//
//  DiskProvider.swift
//  Statio
//
//  Created by Varun Santhanam on 9/6/21.
//  Copyright © 2021 Varun Santhanam. All rights reserved.
//
import Foundation
import StatioKit

/// @CreateMock
protocol DiskProviding: AnyObject {
    func record() throws -> Disk.Usage
}

final class DiskProvider: DiskProviding {
    func record() throws -> Disk.Usage {
        try Disk.record()
    }
}
