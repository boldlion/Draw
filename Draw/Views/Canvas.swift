//
//  File.swift
//  Draw
//
//  Created by Bold Lion on 29.08.19.
//  Copyright © 2019 Bold Lion. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    fileprivate var lines = [LineModel]()
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: CGFloat = 3
    
    // MARK:- Change Color
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func setStrokeWidth(width: CGFloat) {
        self.strokeWidth = width
    }
    
    // MARK:- Undo Action
    func undoAction() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    // MARK:- Clear canvas
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(line.strokeWidth)
            context.setLineCap(.round)

            for (index, point) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                }
                else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(LineModel.init(color: strokeColor, points: [], strokeWidth: strokeWidth))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let startPoint = touches.first?.location(in: nil) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(startPoint)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}
