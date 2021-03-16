//
//  Vector2D.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 15/03/21.
//


import UIKit

class Vector2D {
    
    var x: CGFloat
    var y: CGFloat
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    init(cgPoint: CGPoint) {
        self.x = cgPoint.x
        self.y = cgPoint.y
    }
    
    func add(vector: Vector2D){
        x += vector.x
        y += vector.y
    }
    
    func subtract(vector: Vector2D) {
        x -= vector.x
        y -= vector.y
    }
    
    func multiply(scalar: CGFloat) {
        x *= scalar
        y *= scalar
    }
    
    func divide(scalar: CGFloat) {
        x /= scalar
        y /= scalar
    }
    
    func magnitude() -> CGFloat {
        return CGFloat(sqrt(Double(x*x + y*y)))
    }
    
    func limit(max: CGFloat) {
        if(magnitude() > max) {
            setMagnitude(scalar: max)
        }
    }
    
    //make a unit vector. i.e change the magnitude to 1 without changing the direction of the vector
    func normalize() {
        let mag = magnitude()
        if(mag != 0){
            self.divide(scalar: mag)
        }
    }
    
    //Normalize or make a unit vector and multiply to change the magnitude without changing the direction of the vector
    func setMagnitude(scalar: CGFloat) {
        normalize()
        multiply(scalar: scalar)
    }
    
    
    //MARK: - Static functions
    static func zero() -> Vector2D {
        return Vector2D(x: 0, y: 0)
    }
    
    static func Random(lower: CGFloat = 0, upper: CGFloat = 100) -> Vector2D {
        return Vector2D(x: CGFloat.random(in:lower..<upper), y: CGFloat.random(in: lower..<upper))
    }
    
    static func Add(_ vector1: Vector2D, _ vector2: Vector2D) -> Vector2D {
        Vector2D(x: vector1.x + vector2.x, y: vector1.y + vector2.y)
    }
    
    static func Subtract(_ vector1: Vector2D,_ vector2: Vector2D) -> Vector2D {
        Vector2D(x: vector1.x - vector2.x, y: vector1.y - vector2.y)
    }
    
}

func map(_ n: CGFloat, _ start1: CGFloat, _ stop1: CGFloat, _ start2: CGFloat, _ stop2: CGFloat) -> CGFloat {
    return ((n-start1)/(stop1-start1))*(stop2-start2)+start2
}
