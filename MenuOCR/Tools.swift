//
//  Tools.swift
//  CoreMLTest
//
//  Created by Mohssen Fathi on 6/24/17.
//  Copyright © 2017 Mohssen Fathi. All rights reserved.
//

import UIKit
import Vision

func *(left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}

func *(left: CGRect, right: CGRect) -> CGRect {
    return CGRect(
        x: left.origin.x * right.size.width,
        y: left.origin.y * right.size.height,
        width: left.size.width * right.size.width,
        height: left.size.height * right.size.height
    )
}

func *(left: CGRect, right: CGSize) -> CGRect {
    return CGRect(
        x: left.origin.x * right.width,
        y: left.origin.y * right.height,
        width: left.size.width * right.width,
        height: left.size.height * right.height
    )
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.x)
}

extension simd_float2 {
    
    var point: CGPoint {
        return  CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + width/2.0, y: origin.y + height/2.0)
    }
}

extension UIBezierPath {
    
    static func withPoints(_ points: [CGPoint], closePath: Bool = false) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        for (i, point) in points.enumerated() {
            if i == 0 { path.move(to: point) }
            else { path.addLine(to: point) }
        }
        
        if closePath, let first = points.first {
            path.addLine(to: first)
        }
        
        return path
    }
}

extension VNFaceLandmarkRegion2D {
    
    var points: [vector_float2] {
        return (0 ..< pointCount).map { point(at: $0) }
    }
    
    func path(boundingBox: CGRect, closePath: Bool = true) -> UIBezierPath {
        
        let points = self.points.map({
            (CGPoint(x: 1.0 - $0.point.x, y: 1.0 - $0.point.y) * boundingBox.size)
        })
        
        return UIBezierPath.withPoints(points, closePath: closePath)
    }
}
