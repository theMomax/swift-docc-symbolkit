/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See https://swift.org/LICENSE.txt for license information
 See https://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import Foundation

extension SymbolGraph.Symbol.Swift {
    /**
     If the Symbol is from Swift, this mixin describes the extension context in which it was defined.
     */
    public struct Extension: Mixin {
        public static let mixinKey = "swiftExtension"

        /**
         The module whose type was extended.

         > Note: This module maybe different than where the symbol was actually defined. For example, one can create a public extension on the Swift Standard Library's `String` type in a different module, so `extendedModule` would be `Swift`.
         */
        public var extendedModule: String

        /**
         The generic constraints on the extension, if any.
         */
        public var constraints: [GenericConstraint]

        enum CodingKeys: String, CodingKey {
            case extendedModule
            case constraints
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            extendedModule = try container.decode(String.self, forKey: .extendedModule)
            constraints = try container.decodeIfPresent([GenericConstraint].self, forKey: .constraints) ?? []
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(extendedModule, forKey: .extendedModule)
            if !constraints.isEmpty {
                try container.encode(constraints, forKey: .constraints)
            }
        }
    }
}
