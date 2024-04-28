//
//  CameraView.swift
//  Salus
//
//  Created by Ivan on 4/28/24.
//

import SwiftUI
import AVFoundation
import Vision

enum Views {
    case cameraPreview
    case photoPreview
    case confirmationView
    case chat
}

struct CameraView: View {
    @StateObject var controller = AppController()
    @State var view = Views.cameraPreview
    @State private var imageTaken : UIImage?
    @State private var recognizedTexts = [String]()
    @State private var txt: String = ""
//    @State private var text = ""
    
    var body: some View {
        ZStack{
            CameraPreview(camera: controller.camera)
                .ignoresSafeArea(.all, edges: .all)
//            Text(controller.desc)
            switch view {
            case .cameraPreview:
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            controller.camera.takePic()
                            DispatchQueue.main.async {
                                withAnimation{
                                    view = .photoPreview
                                }
                            }
                        }, label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65,height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }.frame(height: 75)
                }
            case .photoPreview:
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            controller.camera.reTake()
                            DispatchQueue.main.async {
                                withAnimation{
                                    view = .cameraPreview
                                }
                            }
                        }, label: {
                            Image(systemName: "trash")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
//                        .padding(.trailing,10)
                    }.padding(.trailing,10)
                    Spacer()
                    HStack{
                        Button(action: {
                            if !controller.camera.isSaved{
                                imageTaken = controller.camera.getImg()
//                                recognizedTexts = controller.txtModel.recognizedTexts
                                controller.camera.isSaved = true
//                                controller.savePic(imageTaken: imageTaken!)
                                DispatchQueue.main.async {
//                                    controller.txtModel.recognizeText(imageTaken: imageTaken!)
//                                    recognizedTexts = controller.txtModel.recognizedTexts
                                    withAnimation{
                                        view = .confirmationView
                                    }
                                }
                            }
                        }, label: {
                            Text(controller.camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        Spacer()
                    }
                    .frame(height: 75)
                }
            case .confirmationView:
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Image(uiImage: controller.camera.getImg())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                            Button(action: {
                                DispatchQueue.main.async {
                                    withAnimation{
                                        view = .photoPreview
                                        controller.camera.isSaved = false
                                        imageTaken = nil
                                        recognizedTexts = [String]()
//                                        text = ""
                                    }
                                }
                            }, label: {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Re-take picture")
                                }
                            })
                            List {
                                ForEach(recognizedTexts, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            Button(action: {
                                DispatchQueue.main.async {
                                    withAnimation{
                                        view = .chat
                                    }
                                }
                            }, label: {
                                Image(systemName: "text.book.closed")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            })
//                            Text(text)
                        }.onAppear(perform: recognizeText)
                    )
            case .chat:
                ZStack{
                    Color.black.ignoresSafeArea()
                    VStack{
                        ChatView()
                        TextField(
                                "Message",
                                text: $txt
                        ).onSubmit {
                            print("ping")
                        }
                    }
                }
            }
        }.onAppear(perform: {
            controller.camera.Check()
        })
    }
    
    func recognizeText() {
            guard let image = imageTaken else { return }
            let request = VNRecognizeTextRequest { (request, error) in
//                guard let results = request.results as? [VNRecognizedTextObservation] else {return}
                guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
//                self.text = results.map { $0.topCandidates(1).first?.string ?? "" }.joined(separator: " ")
                self.recognizedTexts = observations.compactMap { observation in observation.topCandidates(1).first?.string }
            }
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            try? handler.perform([request])
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
    CameraView()
}
