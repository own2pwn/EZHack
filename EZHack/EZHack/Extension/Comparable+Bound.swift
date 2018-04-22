//
//  Comparable+Bound.swift
//  EZHack
//
//  Created by Evgeniy on 22.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation

public extension Comparable {
    public func bounded(min: Self, max: Self) -> Self {
        return self < min ? min : self > max ? max : self
    }
}
