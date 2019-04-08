//
//  NSAttributedStringExtension.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/4/8.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit

extension NSAttributedString {

    func applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }


}
