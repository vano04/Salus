//
//  ContentView.swift
//  Salus
//
//  Created by Ivan on 4/26/24.
//

import SwiftUI
import Vision
import AVFoundation

struct ContentView: View {
//    @State private var imageTaken: UIImage?
//    @State private var recognizedTexts = [String]()
//    @State private var isLoading = false
//    
//    func recognizeText() {
//        print("reading text")
//        let requestHandler = VNImageRequestHandler(cgImage: self.imageTaken!.cgImage!)
//        
//        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
//            guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
//            
//            for observation in observations {
//                let recognizedText = observation.topCandidates(1).first!.string
//                self.recognizedTexts.append(recognizedText)
//            }
//        }
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try requestHandler.perform([recognizeTextRequest])
//                
//                self.isLoading = false
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
//    
//    var pictureTakenView: some View {
//        VStack {
//            Image(uiImage: self.imageTaken!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 200, height: 200)
//            Button(action: {
//                self.imageTaken = nil
//                self.recognizedTexts = [String]()
//            }, label: {
//                HStack {
//                    Image(systemName: "camera")
//                    Text("Re-take picture")
//                }
//            })
//        
//            List {
//                ForEach(self.recognizedTexts, id: \.self) {
//                    Text("\($0)")
//                }
//            }
//        }
//    }
    
    var body: some View {
        VStack {
//            if (self.imageTaken == nil) {
//                CameraView(image: self.$imageTaken)
//            } else {
//                if (!self.isLoading) {
//                    self.pictureTakenView
//                        .onAppear {
//                            self.recognizedCardText()
//                        }
//                }
//                else {
//                    ProgressView()
//                }
//            }
            CameraView()
        }
    }
}

struct CameraView: View {
    @StateObject var camera = CameraModel()
    var body: some View {
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            VStack{
                if camera.isTaken{
                    HStack {
                        Spacer()
                        Button(action: camera.reTake, label: {
                            Image(systemName: "trash")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing,10)
                    }
                }
                
                Spacer()
                HStack {
                    if camera.isTaken{
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                    } else {
                        Button(action: camera.takePic, label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65,height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    
    @Published var picData = Data(count: 0)
    
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
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake(){
        print("RETAKE TRIGGERED")
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.isSaved = false
            }
        }
    }
    
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
    
    func savePic(){
        let image = UIImage(data: self.picData)!
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        
        print("Saved successfully")
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UIView(frame:UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Set preview camera properties.
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        DispatchQueue.global(qos: .background).async {
            camera.session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview {
    ContentView()
}
