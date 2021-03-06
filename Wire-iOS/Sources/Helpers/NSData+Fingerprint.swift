// 
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


import Foundation

extension NSData {
    public func attributedFingerprint(attributes: [String : AnyObject], boldAttributes: [String : AnyObject], uppercase: Bool = false) -> NSAttributedString? {
        
        let strings: [String] = self.mapBytes { (char: UInt8) -> (String) in
            return String(UnicodeScalar(char))
        }
        
        var fingerprintString = ""
        var even = true
        strings.forEach { (string: String) -> () in
            if even {
                if fingerprintString.characters.count > 0 {
                    fingerprintString = fingerprintString + " "
                }
                even = false
            }
            else {
                
                even = true
            }
            fingerprintString = fingerprintString + string
        }
        
        if uppercase {
           fingerprintString = fingerprintString.uppercaseString
        }
        
        let attributedRemoteIdentifier = fingerprintString.fingerprintStringWithAttributes(attributes, boldAttributes: boldAttributes)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        return attributedRemoteIdentifier && [NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    public func mapBytes<T: Any, E: Any>(callback: (E) -> (T)) -> [T] {
        assert(self.length % sizeof(E) == 0, "Data size is uneven to enumerated element size")
        var result: [T] = []
        let stepCount = self.length / sizeof(E)
        let buffer = UnsafeBufferPointer<E>(start:UnsafePointer<E>(self.bytes), count: stepCount)
        for i in 0..<stepCount {
            result.append(callback(buffer[i]))
        }
        return result
    }
}
