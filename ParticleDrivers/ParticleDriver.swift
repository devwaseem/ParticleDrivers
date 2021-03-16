//
//  ParticleDriver.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 15/03/21.
//

import UIKit
import Combine

enum ParticleSpreadMode {
    case fall, scatter
}

class ParticleDriver: ObservableObject {
    
    @Published var particles: [Particle]
    var isDragging = false
    var draggedLocation = CGPoint.zero
    
    var displayLink: CADisplayLink?
    var spreadMode = ParticleSpreadMode.scatter
    
    var targets = [String: [Vector2D]]()
    
    var systemSize: CGSize = .init(width: 1000, height: 1000)
    
    var totalTargets: Int {
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
                particles.append(Particle(position: Vector2D.Random(lower: 0, upper: systemSize.width), target: Vector2D(x: CGFloat.random(in: 0..<systemSize.width), y: systemSize.height)))
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
            if isDragging {
                particle.runAway(from: Vector2D(cgPoint: draggedLocation))
            }
            particle.update()
        }
        self.objectWillChange.send()
    }
    
    func changeTarget(key: String){
        guard let targets = targets[key] else {
            fatalError("Key not found")
        }

        self.particles.forEach { particle in
            if spreadMode == .fall {
                particle.resetTarget()
            }else {            
                particle.scatter(lower: -systemSize.height, upper: systemSize.height)
            }
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
}
