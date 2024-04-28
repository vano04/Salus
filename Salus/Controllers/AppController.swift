//
//  AppController.swift
//  Salus
//
//  Created by Ivan on 4/28/24.
//
import SwiftUI
import AVFoundation

class AppController: NSObject, ObservableObject {
    @Published var camera = CameraModel()
}
