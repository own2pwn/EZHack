//
//  UIView+Tap.swift
//  rxBalance
//
//  Created by Evgeniy on 14.04.18.
//  Copyright © 2018 Evgeniy. All rights reserved.
//

import UIKit

public typealias BaseTapHandlerBlock = VoidBlock
public typealias ExtendedTapHandlerBlock = (UITapGestureRecognizer) -> Void

public protocol AnyBlockHandler: class {
    func remove(for view: UIView)
}

public extension UIView {
    
    public var tapHandler: BaseTapHandlerBlock? {
        get { return HandlerStorage.shared.getBaseHandler(for: self) }
        set { HandlerStorage.shared.setBaseHandler(newValue, for: self) }
    }
    
    public var extendedTapHandler: ExtendedTapHandlerBlock? {
        get { return HandlerStorage.shared.getExtendedHandler(for: self) }
        set { HandlerStorage.shared.setExtendedHandler(newValue, for: self) }
    }
}

public final class HandlerStorage {
    // MARK: - Members
    
    public var handlers: [UIView: AnyBlockHandler]
    
    public static let shared = HandlerStorage()
    
    // MARK: - Interface
    
    public func setBaseHandler(_ handler: BaseTapHandlerBlock?, for view: UIView) {
        guard let handler = handler else {
            if let blockHandler = handlers[view] {
                blockHandler.remove(for: view)
            }
            return
        }
        
        let newBlockHandler = BaseBlockHandler(handler, for: view)
        handlers[view] = newBlockHandler
    }
    
    public func getBaseHandler(for view: UIView) -> BaseTapHandlerBlock? {
        let blockHandler = handlers[view] as? BaseBlockHandler
        
        return blockHandler?.block
    }
    
    public func setExtendedHandler(_ handler: ExtendedTapHandlerBlock?, for view: UIView) {
        guard let handler = handler else {
            if let blockHandler = handlers[view] {
                blockHandler.remove(for: view)
            }
            return
        }
        
        let newBlockHandler = ExtendedBlockHandler(handler, for: view)
        handlers[view] = newBlockHandler
    }
    
    public func getExtendedHandler(for view: UIView) -> ExtendedTapHandlerBlock? {
        let blockHandler = handlers[view] as? ExtendedBlockHandler
        
        return blockHandler?.block
    }
    
    // MARK: - Init
    
    public init() {
        handlers = [:]
    }
}

public final class BaseBlockHandler: AnyBlockHandler {
    // MARK: - Members
    
    public let block: BaseTapHandlerBlock
    
    private let recognizer: UITapGestureRecognizer
    
    // MARK: - Interface
    
    public func remove(for view: UIView) {
        view.removeGestureRecognizer(recognizer)
    }
    
    // MARK: - Init
    
    public init(_ block: @escaping BaseTapHandlerBlock, for view: UIView) {
        self.block = block
        
        recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(onTap))
        view.addGestureRecognizer(recognizer)
    }
    
    // MARK: - Handling
    
    @objc
    private func onTap() {
        block()
    }
}

public final class ExtendedBlockHandler: AnyBlockHandler {
    // MARK: - Members
    
    public let block: ExtendedTapHandlerBlock
    
    private let recognizer: UITapGestureRecognizer
    
    // MARK: - Interface
    
    public func remove(for view: UIView) {
        view.removeGestureRecognizer(recognizer)
    }
    
    // MARK: - Init
    
    public init(_ block: @escaping ExtendedTapHandlerBlock, for view: UIView) {
        self.block = block
        
        recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(onTap))
        view.addGestureRecognizer(recognizer)
    }
    
    // MARK: - Handling
    
    @objc
    private func onTap(_ sender: UITapGestureRecognizer) {
        block(sender)
    }
}
