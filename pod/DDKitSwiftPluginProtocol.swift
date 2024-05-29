//
//  DDKitSwiftPluginProtocol.swift
//  DDKitSwift
//
//  Created by Damon on 2021/4/23.
//

import UIKit

public enum DDKitSwiftPluginType {
    case ui
    case data
    case other
}

public protocol DDKitSwiftPluginProtocol {
    var pluginIdentifier: String { get }
    var pluginIcon: UIImage? { get }
    var pluginTitle: String { get }
    var pluginType: DDKitSwiftPluginType { get }
    var isRunning: Bool { get }
    
    func didRegist()
    func willStart()
    func start()
    func willStop()
    func stop()
}

public extension DDKitSwiftPluginProtocol {
    func didRegist() {
        
    }
    
    func willStart() {
        
    }
    
    func willStop() {
        
    }
}


