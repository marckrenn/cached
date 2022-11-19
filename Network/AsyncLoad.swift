//
//  AsyncLoad.swift
//  cached
//
//  Created by Marc Krenn on 04.10.22.
//

import Foundation
import Endpoints

public enum AsyncLoad<C: Call> {
    
    public static func == (lhs: AsyncLoad<C>, rhs: AsyncLoad<C>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case (.error, .error):
            return true
        case (.loaded, .loaded):
            return true
        case (.cached, .cached):
            return true
        case (.loadingWithCache, .loadingWithCache):
            return true
        default:
            return false
        }
    }
    
    case none
    case loading
    case error(Error)
    case errorWithCache((HTTPResult<C>, Error))
    case loaded(HTTPResult<C>)
    case cached(HTTPResult<C>)
    case loadingWithCache(HTTPResult<C>)
    
    public var isLoading: Bool {
        switch self {
        case .loading, .loadingWithCache, .cached, .none:
            return true
        default:
            return false
        }
    }
    
    public var item: C.Parser.OutputType? {
        get {
            switch self {
            case .loaded(let item), .cached(let item), .loadingWithCache(let item):
                return item.value
            case .errorWithCache(let error):
                return error.0.value
            default:
                return nil
            }
        }
        
        set {
            if let item = newValue {
                self = .loaded(item as! HTTPResult<C>)
            } else {
                self = .none
            }
        }
    }
    
    public var source: HTTPSource {
        switch self {
        case .loaded(let result), .cached(let result), .loadingWithCache(let result):
            return result.source
        case .errorWithCache(let error):
            return error.0.source
        default:
            return .none
        }
    }
    
    public var error: Error? {
        switch self {
        case .error(let error):
            guard !self.isLoading else { return nil }
            return error
        case .errorWithCache(let error):
            guard !self.isLoading else { return nil }
            return error.1
        default:
            return nil
        }
    }
    
    public var response: HTTPURLResponse? {
        switch self {
        case .loaded(let result), .cached(let result), .loadingWithCache(let result):
            guard !self.isLoading else { return nil }
            return result.response
        case .errorWithCache(let error):
            guard !self.isLoading else { return nil }
            return error.0.response
        default:
            return nil
        }
    }
    
}





//public enum AsyncLoadSource {
//    case none
//    case origin
//    case cache
//}
//
//public enum AsyncLoad<T>: Equatable {
//
//    public static func == (lhs: AsyncLoad<T>, rhs: AsyncLoad<T>) -> Bool {
//        switch (lhs, rhs) {
//        case (.none, .none):
//            return true
//        case (.loading, .loading):
//            return true
//        case (.error, .error):
//            return true
//        case (.loaded, .loaded):
//            return true
//        case (.cached, .cached):
//            return true
//        case (.loadingWithCache, .loadingWithCache):
//            return true
//        default:
//            return false
//        }
//    }
//
//    case none
//    case loading
//    case error(Error)
//    case loaded(T)
//    case cached(T)
//    case loadingWithCache(T)
//
//    public var isLoading: Bool {
//        switch self {
//        case .loading, .loadingWithCache, .cached, .none:
//            return true
//        default:
//            return false
//        }
//    }
//
//    public var item: T? {
//        get {
//            switch self {
//            case .loaded(let item), .cached(let item), .loadingWithCache(let item):
//                return item
//            default:
//                return nil
//            }
//        }
//
//        set {
//            if let item = newValue {
//                self = .loaded(item)
//            } else {
//                self = .none
//            }
//        }
//    }
//
//    public var source: AsyncLoadSource {
//        switch self {
//        case .loadingWithCache, .cached:
//            return .cache
//        case .loaded:
//            return error == nil ? .origin : .cache
//        default:
//            return .none
//        }
//    }
//
//    public var error: Error? {
//        switch self {
//        case let .error(error):
//            return error
//        default:
//            return nil
//        }
//    }
//
//}







//public enum AsyncAction<T>: Equatable {
//
//    public static func == (lhs: AsyncAction<T>, rhs: AsyncAction<T>) -> Bool {
//        switch (lhs, rhs) {
//        case (.none, .none):
//            return true
//        case (.loading, .loading):
//            return true
//        case (.error, .error):
//            return true
//        case (.success, .success):
//            return true
//        default:
//            return false
//        }
//    }
//
//    case none
//    case loading
//    case error(Error)
//    case success(T)
//
//    public var isLoading: Bool {
//        if case .loading = self {
//            return true
//        }
//        return false
//    }
//
//    public var item: T? {
//        switch self {
//        case let .success(item):
//            return item
//        default:
//            return nil
//        }
//    }
//}
//
//public enum AsyncLoad<T>: Equatable {
//
//    public static func == (lhs: AsyncLoad<T>, rhs: AsyncLoad<T>) -> Bool {
//        switch (lhs, rhs) {
//        case (.none, .none):
//            return true
//        case (.loading, .loading):
//            return true
//        case (.error, .error):
//            return true
//        case (.loaded, .loaded):
//            return true
//        default:
//            return false
//        }
//    }
//
//    case none
//    case loading
//    case error(Error)
//    case loaded(T)
//
//    public var isLoading: Bool {
//        if case .loading = self {
//            return true
//        }
//        return false
//    }
//
//    public var item: T? {
//        get {
//            switch self {
//            case let .loaded(item):
//                return item
//            default:
//                return nil
//            }
//        }
//
//        set {
//            if let item = newValue {
//                self = .loaded(item)
//            } else {
//                self = .none
//            }
//        }
//    }
//}

