//
//  Promise+Optional.swift
//  YandexTransportWidget
//
//  Created by Evgeniy on 09.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import Foundation
import Promise

public extension Promise {
    public convenience init(optional: Value?) {
        self.init()

        if let value = optional { fulfill(value) }
    }

    public func fulfill(optional: Value?) {
        if let value = optional { fulfill(value) }
    }
}
