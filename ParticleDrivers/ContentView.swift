//
//  ContentView.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 14/03/21.
//

import SwiftUI

struct ParticleView: View {
    
    let x: CGFloat
    let y: CGFloat
    
    var body: some View {
        Color.primary
            .frame(width: 2, height: 2)
//            .clipShape(Circle())
            .position(x: x, y: y)
        
    }
    
}

struct ContentView: View {
    
    @ObservedObject var particleDriver: ParticleDriver
    @State var k = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    ForEach(particleDriver.particles){ particle in
                        ParticleView(x: particle.position.x, y: particle.position.y)
                    }
                }
                .drawingGroup()
//                .background(Color.red)
                
                Button(action: {
                    if k % 5 == 0 {
                        particleDriver.changeTarget(key: "apple")
                    }else if k % 5 == 1 {
                        particleDriver.changeTarget(key: "create")
                    }else if k % 5 == 2 {
                        particleDriver.changeTarget(key: "design")
                    }else if k % 5 == 3 {
                        particleDriver.changeTarget(key: "swiftui")
                    }else if k % 5 == 4 {
                        particleDriver.changeTarget(key: "waseem")
                    }
                    k += 1
                }, label: {
                    Text("Change")
                })
                Spacer()
            }.onAppear {
                particleDriver.setSystem(size: geometry.size)
                particleDriver.addTarget(key: "waseem", image: UIImage(named: "waseem")!)
                particleDriver.addTarget(key: "apple", image: UIImage(named: "apple")!)
                particleDriver.addTarget(key: "create", image: UIImage(named: "create")!)
                particleDriver.addTarget(key: "design", image: UIImage(named: "design")!)
                particleDriver.addTarget(key: "swiftui", image: UIImage(named: "swiftui")!)
                particleDriver.makeParticlesScatter()
//                particleDriver.targetAddDidComplete()
                particleDriver.start()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(particleDriver: ParticleDriver())
    }
}
