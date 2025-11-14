import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showSourceMenu = false
    @State private var classificationLabel = ""

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("No Image Selected").foregroundColor(.gray))
                    .cornerRadius(10)
                    .padding()
            }

            if !classificationLabel.isEmpty {
                Text("Prediction: \(classificationLabel)")
                    .font(.headline)
                    .padding()
            }

            Button("Choose Photo") {
                showSourceMenu = true
            }
            .padding()
            .confirmationDialog("Select Source", isPresented: $showSourceMenu) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("Camera") {
                        sourceType = .camera
                        showImagePicker = true
                    }
                }
                Button("Photo Library") {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if let image = selectedImage {
                classifyImage(image)
            }
        }) {
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
        }
    }

    func classifyImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        guard let model = try? VNCoreMLModel(for: MonumentClassifier(configuration: MLModelConfiguration()).model) else {
            print("Failed to load model")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                DispatchQueue.main.async {
                    classificationLabel = "\(topResult.identifier) – \(String(format: "%.1f", topResult.confidence * 100))%"
                }
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        try? handler.perform([request])
    }
}

#Preview {
    ContentView()
}
