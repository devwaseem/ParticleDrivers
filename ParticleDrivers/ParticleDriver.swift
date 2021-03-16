//
//  ParticleDriver.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 15/03/21.
//

import UIKit
import Combine



class Particle: Identifiable {
    
    let id = UUID()
    public var position: Vector2D
    public var currentTarget: Vector2D
    
    private var originalTarget: Vector2D
    private var velocity: Vector2D
    private var acceleration: Vector2D
    
    var maxSpeed: CGFloat = 20
    var maxForce: CGFloat = 2
    
    init(position: Vector2D, target: Vector2D) {
        self.position = Vector2D(x: position.x, y: position.y)
        self.originalTarget = Vector2D(x: target.x, y: target.y)
        self.currentTarget = Vector2D(x: target.x, y: target.y)
        self.velocity = Vector2D.zero()
        self.acceleration = Vector2D.zero()
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
        if distance < 50 {
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
//        currentTarget = Vector2D(x: CGFloat.random(in: lower ..< upper), y: upper)
    }
    
    func resetTarget(){
        currentTarget = Vector2D(x: originalTarget.x, y: originalTarget.y)
    }
    
    func changeTarget(target: Vector2D) {
        currentTarget = Vector2D(x: target.x, y: target.y)
    }
    
}

class ParticleDriver: ObservableObject {
    
    @Published var particles: [Particle]
    var displayLink: CADisplayLink?
    var isFallen = false
    
    var targets = [String: [Vector2D]]()
    
    var systemSize: CGSize = .init(width: 1000, height: 1000)
    
    var totalTargets: Int {
//        var total = 0
//        for (key, _) in targets {
//            total += targets[key]?.count ?? 0
//        }
//        return total
        var maxTargets = 0
        for (key, _) in targets {
            let targetCount = targets[key]?.count ?? 0
            if(maxTargets < targetCount){
                maxTargets = targetCount
            }
        }
        return maxTargets
    }
    
    init(){
        self.particles = []
        self.displayLink = CADisplayLink(target: self, selector:  #selector(update))
        displayLink?.add(to: .current, forMode: .common)
        displayLink?.preferredFramesPerSecond = 30
        displayLink?.isPaused = true
    }
    
    func addTarget(key: String, image: UIImage){
        let pixels = image.getPixels()
        let offset = systemSize.width / 2 - image.size.width / 2
        var newTargets = [Vector2D]()
        for x in 0 ..< pixels.count {
            for y in 0 ..< pixels[x].count {
                let alpha = pixels[x][y]
                if(alpha > 20) {
                    let target = Vector2D(x: CGFloat(CGFloat(x)+offset), y: CGFloat(y))
                    newTargets.append(target)
                }
            }
        }
        if(newTargets.count > totalTargets) {
            let particlesNeeded = newTargets.count - totalTargets
            for _ in 0 ..< particlesNeeded {
                particles.append(Particle(position: Vector2D.Random(lower: 0, upper: 400), target: Vector2D(x: CGFloat.random(in: 0..<systemSize.width), y: systemSize.height)))
            }
        }
        
        targets[key] = newTargets
    }
    
    func setSystem(size: CGSize){
        systemSize = size
    }
    
    func start() {
        displayLink?.isPaused = false
    }
    
    @objc func update(displayLink: CADisplayLink){
        particles.forEach { (particle) in
            particle.steer()
            particle.update()
        }
        self.objectWillChange.send()
    }
    
    func changeTarget(key: String){
        guard let targets = targets[key] else {
            fatalError("Key not found")
        }

        self.particles.forEach { particle in
            particle.scatter(lower: systemSize.height * -2, upper: systemSize.height * 2)
//            particle.resetTarget()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in 0 ..< targets.count {
                self.particles[i].changeTarget(target: targets[i])
            }
        }
        
    }
    
    func makeParticlesScatter() {
        particles.forEach { particle in
            particle.scatter(lower: 0, upper: systemSize.height)
        }
    }
    
    func disort() {
        
    }
    
    
}
