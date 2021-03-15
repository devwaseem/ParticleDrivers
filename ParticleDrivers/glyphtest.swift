//
//  glyphtest.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 14/03/21.
//

import UIKit

func characterPaths(attributedString: NSAttributedString, position: CGPoint) -> [CGPath] {
    let line = CTLineCreateWithAttributedString(attributedString)
    
    guard let gylphRuns = CTLineGetGlyphRuns(line) as? [CTRun] else { return [] }
    var characterPaths = [CGPath]()
    for gylphRun in gylphRuns {
        guard let attributes = CTRunGetAttributes(gylphRun) as? [String: AnyObject] else { continue }
        let font = attributes[kCTFontAttributeName as String] as! CTFont
        
        for index in 0..<CTRunGetGlyphCount(gylphRun) {
            let gylphRange = CFRangeMake(index, 1)
            var gylph = CGGlyph()
            CTRunGetGlyphs(gylphRun, gylphRange, &gylph)
            var characterPosition = CGPoint()
            CTRunGetPositions(gylphRun, gylphRange, &characterPosition)
            characterPosition.x += position.x
            characterPosition.y += position.y
            if let gylphPath = CTFontCreatePathForGlyph(font, gylph, nil) {
                var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: characterPosition.x, ty: characterPosition.y)
                if let charPath = gylphPath.copy(using: &transform) {
                    characterPaths.append(charPath)
                }
            }
        }
    }
    
    return characterPaths
}
