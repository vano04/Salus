//
//  TextModel.swift
//  Salus
//
//  Created by Ivan on 4/28/24.
//

import Vision
import AVFoundation
import SwiftUI

class TextModel {
    //    private var recognizedTexts : [String]
    //
    //    init(recognizedTexts : inout [String]) {
    //        self.recognizedTexts = recognizedTexts
    //    }
//    @State var recognizedTexts = [String]()
//    
//    func recognizeText(imageTaken : UIImage) {
//        print("reading text")
//        let requestHandler = VNImageRequestHandler(cgImage: imageTaken.cgImage!)
//        
//        let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
//            // 1. Parse the results
//            guard let observations = request.results as? [VNRecognizedTextObservation] else {
//                return
//            }
//            
//            // 2. Extract the data you want
//            self.recognizedTexts = observations.compactMap { observation in
//                observation.topCandidates(1).first?.string
//            }
//        }
//
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try requestHandler.perform([recognizeTextRequest])
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    
}
//    func rec(imageTaken : UIImage) -> [String] {
//        recognizeText(imageTaken: imageTaken)
//        return recognizedTexts
//    }

