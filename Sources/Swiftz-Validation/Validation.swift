//
//  Validation.swift
//  Swiftz-Validation
//
//  Created by Ricardo Pallás on 09/09/2017.
//  Copyright © 2017 Ricardo Pallas. All rights reserved.
//

import Foundation

public enum Validation<L,R> {
    
    case failure(L)
    case success(R)
    
    /// Returns the value of `Success` if it exists otherwise nil.
    public var success : R? {
        switch self {
        case .success(let r): return r
        default: return nil
        }
    }
    
    /// Returns the value of `Failure` if it exists otherwise nil.
    public var failure : L? {
        switch self {
        case .failure(let l): return l
        default: return nil
        }
    }
    
}

extension Validation /*: Functor*/ {
    public typealias A = R
    public typealias B = Any
    public typealias FB = Validation<L,B>
    
    public func fmap<B>(_ f : @escaping (A) -> B) -> Validation<L,B> {
        switch self {
        case .failure(let a):
            return Validation<L,B>.failure(a)
        case .success(let b):
            return Validation<L,B>.success(f(b))
        }
    }
}

extension Validation /*: Pointed*/ {
    public static func pure(_ x : R) -> Validation<L,R> {
        return Validation.success(x)
    }
}


extension Validation /*: Applicative*/ {
    public typealias FAB = Validation<L, (A) -> B>
    
    public func ap<B>(_ f : Validation<L,(A) -> B>) -> Validation<L,B> {
        switch self {
        case .success(let b):
            return f.fmap{ $0(b) }
        case .failure(let l):
            return Validation<L,B>.failure(l)

        }
    }
}

extension Validation /*: ApplicativeOps*/ {
    public typealias C = Any
    public typealias FC = Validation<L,C>

    
    public static func liftA<B>(_ f : @escaping (A) -> B) -> (Validation<L,A>) -> Validation<L,B> {
        return { (a : Validation<L,A>) -> Validation<L,B> in
            return a.ap(Validation<L, (A) -> B>.pure(f))
        }
    }

    public static func liftA2<B>(_ f : @escaping (A) -> (B) -> C) -> (Validation<L,A>) -> (Validation<L,B>) -> Validation<L,C> {
        return { (a : Validation<L,A>) -> (Validation<L,B>) -> Validation<L,C> in
            { (b:Validation<L,B>) -> Validation<L,C> in
                return b.ap(a.fmap(f))
            }
        }
    }
}

extension Validation where L:Concatable/*: Semigroup*/ {
    
    public typealias FA = Validation<L,A>
    
    public func sconcat(_ other : FA) -> FA {
        switch self {
        case .success( _):
            return other
        case .failure(let error):
            switch other {
            case .success( _):
                return self
            case .failure(let otherError):
                return Validation<L,A>.failure(error.concat(otherError))
            }
        }
    }
}


