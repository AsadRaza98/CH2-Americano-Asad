//
//  CameraView.swift
//  CH2
//
//  Created by Asad Raza on 07/11/25.
//

import SwiftUI
import AVFoundation

class CameraView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    /// Convenience wrapper to get layer as its statically known type.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

#Preview {
    ///Adding a comment to check GIT
    CameraView()
}
