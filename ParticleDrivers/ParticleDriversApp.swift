//
//  ParticleDriversApp.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 14/03/21.
//

import SwiftUI

@main
struct ParticleDriversApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(templates: ["apple", "onemorething", "wwdc2021", "swiftui","waseem"], particleDriver: ParticleDriver())
        }
    }
}


