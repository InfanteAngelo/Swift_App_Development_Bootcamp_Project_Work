//
//  ImageClassifier.swift
//  DoggoFinder
//
//  Created by Studente on 08/07/24.
//

import SwiftUI


class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: String {
        var res = ""
        if let _ = classifier.confidence {
                res = classifier.results!
        }
        return res
    }
    
    var imageConfidence: Float {
        var ret: Float = 0
        if let conf = classifier.confidence {
                ret = conf
        }
        return ret
    }
        
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
    }
        
}
