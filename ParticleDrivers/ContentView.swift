//
//  ContentView.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 14/03/21.
//

import SwiftUI
import Combine

struct ParticleView: View {
    
    let x: CGFloat
    let y: CGFloat
    
    var body: some View {
        Color.primary
            .frame(width: 2, height: 2)
            .position(x: x, y: y)
        
    }
    
}

struct ContentView: View {
    
    var templates: [String]
    @State var index = -1
    @State var isGravityEnabled = false
    @ObservedObject var particleDriver: ParticleDriver
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    ForEach(particleDriver.particles){ particle in
                        ParticleView(x: particle.position.x, y: particle.position.y)
                    }
                }
                .drawingGroup()
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Views count:")
                        Spacer()
                        Text("\(particleDriver.particles.count)")
                    }
                    .padding()
                    Toggle("Fall down", isOn: $isGravityEnabled)
                        .onReceive(Just(isGravityEnabled), perform: { _ in
                            particleDriver.spreadMode = isGravityEnabled ? .fall : .scatter
                        })
                        .padding()
                    Button(action: {
                        index += 1
                        let target = templates[(index) % templates.count]
                        particleDriver.changeTarget(key: target)
                    }, label: {
                        VStack{
                            Text("Next")
                                .foregroundColor(Color.white)
                        }
                        .padding(24)
                        .background(Color.blue)
                        .cornerRadius(16)
                    })
                }
                Spacer()
            }
            .gesture(DragGesture().onChanged({ value in
                particleDriver.isDragging = true
                particleDriver.draggedLocation = value.location
            }).onEnded({ value in
                particleDriver.isDragging = false
            }))
            .onAppear {
                particleDriver.setSystem(size: geometry.size)
                for template in templates {
                    particleDriver.addTarget(key: template, image: UIImage(named: template)!)
                }
                particleDriver.spreadMode = isGravityEnabled ? .fall : .scatter
                particleDriver.makeParticlesScatter()
                particleDriver.start()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(templates: [], particleDriver: ParticleDriver())
    }
}
