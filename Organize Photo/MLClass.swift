//
//  MLClass.swift
//  Organize Photo
//
//  Created by Sereyvitu Lim on 5/2/19.
//  Copyright © 2019 com.SereyvituLim. All rights reserved.
//

import UIKit
import Vision

class MLClass {
    
    static func performObjectRecognition(data: Data) -> String {
        var imageDesc = "";
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return "" }
        
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let Observation = results.first else { return }

            imageDesc = Observation.identifier
        }
        
        do {
            try VNImageRequestHandler(data: data, options: [:]).perform([request])
        } catch {
            NSLog("*** Cannot Perform ML on the Image ***")
        }
        
        return imageDesc
    }
    
}
