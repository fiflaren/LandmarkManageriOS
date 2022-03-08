//
//  BoyerMoore.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 08/03/2022.
//

import Foundation

struct BoyerMoore {
    
    enum BoyerMooreError: Error {
        case NotFound
    }
    
    private let data:[Int]
    
    init(data: [Int]) {
        self.data = data
    }
    
    /// If char does not occur in pat, then patlen;
    /// else patlen - j, where j is the maximum integer
    /// such that pat(j) = char
    func delta1(pat: [Int], char: Int) -> Int {
        var i = 0
        // skip the last one, doesn't matter.
        i = pat.count - 1
        while i > 0 && pat[i - 1] != char {
            i-=1
        }
        return pat.count - i
    }
    
    func search(pat: String) throws -> Range<Int> {
        return try search(pat: pat.unicodeScalars.map { Int($0.value) })
    }
    
    func search(pat:[Int]) throws -> Range<Int> {
        guard pat.count > 0 else {
            //return Range(start:0, end:pat.count)
            return 0..<pat.count
        }
        
        var i = pat.count - 1
        var j = 0
        while (i < data.count) {
            j = pat.count - 1
            while j >= 0 && data[i] == pat[j] {
                i -= 1
                j -= 1
            }

            if j < 0 {
                //return Range(start:i + 1, end:i + 1 + pat.count)
                return i+1 ..< i + 1 + pat.count
            }
            
            i = i + delta1(pat: pat, char: data[i])
        }
        
        throw BoyerMooreError.NotFound
    }
}

extension BoyerMoore: ExpressibleByStringLiteral {
    //MARK: StringLiteralConvertible
    
    init(stringLiteral value: String) {
        self.data = value.unicodeScalars.map { Int($0.value) }
    }
    
    typealias UnicodeScalarLiteralType = StringLiteralType
    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(stringLiteral: value)
    }
    
    typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(stringLiteral: value)
    }
}
