//
//  CameraModel.swift
//  Salus
//
//  Created by Ivan on 4/28/24.
//

import AVFoundation
import SwiftUI

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var isSaved = false
    @Published var alert = false
    
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var picData = Data(count: 0)
    
    
    ///Setup camera config
    func setUp(){
        do{
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
              
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    ///Check permissions
    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
        default:
            return
        }
    }

    ///Take a picture
    func takePic(){
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
//                    self.view = .photoPreview
//                    print(self.view)
                }
            }
        }
    }
    
    ///Retake picture
    func reTake(){
        print("RETAKE TRIGGERED")
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                    self.isSaved = false
                }
                
            }
        }
    }
    
    ///On photo taken
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("OUTPUT TRIGGERED")
        if error != nil {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("NO IMAGE?")
            return
        }
        
        self.picData = imageData
    }
    func getImg() -> UIImage {
        return UIImage(data: self.picData)!
    }
}
