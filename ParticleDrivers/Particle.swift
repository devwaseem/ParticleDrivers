//
//  Particle.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 16/03/21.
//

import Foundation
import UIKit

class Particle: Identifiable {
    
    let id = UUID()
    public var position: Vector2D
    public var currentTarget: Vector2D
    
    private var originalTarget: Vector2D
    private var velocity: Vector2D
    private var acceleration: Vector2D
    
    var maxSpeed: CGFloat = 20
    var maxForce: CGFloat = 3
    
    init(position: Vector2D, target: Vector2D) {
        self.position = position.copy()
        self.originalTarget = target.copy()
        self.currentTarget = target.copy()
        self.velocity = .zero()
        self.acceleration = .zero()
    }
    
    func apply(force: Vector2D) {
        self.acceleration.add(vector: force)
    }
    
    func steer() {
        let desired = Vector2D.Subtract(currentTarget, position)
        let distance = desired.magnitude()
        var speed = maxSpeed;
        if distance < 100 {
            speed = map(distance, 0, 100, 0, maxSpeed)
        }
        desired.setMagnitude(scalar: speed)
        let steer = Vector2D.Subtract(desired, velocity)
        steer.limit(max: maxForce)
        apply(force: steer)
    }
    
    
    func runAway(from point: Vector2D) {
        let desired = Vector2D.Subtract(point, position)
        let distance = desired.magnitude()
        if distance < 40 {
            desired.setMagnitude(scalar: self.maxSpeed)
            desired.multiply(scalar: -1)
            let steer = Vector2D.Subtract(desired, velocity)
            steer.limit(max: maxForce)
            apply(force: steer)
        }
    }
    
    func update(){
        self.position.add(vector: self.velocity)
        self.velocity.add(vector: self.acceleration)
        self.acceleration.multiply(scalar: 0)
    }
    
    func scatter(lower: CGFloat, upper: CGFloat){
        currentTarget = Vector2D.Random(lower: lower, upper: upper)
    }
    
    func resetTarget(){
        currentTarget = originalTarget.copy()
    }
    
    func changeTarget(target: Vector2D) {
        currentTarget = target.copy()
    }
    
}
