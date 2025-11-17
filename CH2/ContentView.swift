import SwiftUI
import CoreML
import Vision
import Photos

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showSourceMenu = false
    @State private var classificationLabel = ""
    @StateObject private var monumentViewModel = MonumentViewModel()
    private let goldGradient = LinearGradient(
        colors: [
            Color(red: 0.9, green: 0.78, blue: 0.43),   // light gold
            Color(red: 0.78, green: 0.66, blue: 0.30)   // deeper gold
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient (black → gold glow)
                LinearGradient(colors: AppTheme.gradient,
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        
                        // App title
                        Text("Monument Classifier")
                            .font(.system(.largeTitle, design: .serif))
                            .bold()
                            .foregroundColor(AppTheme.accent)
                            .shadow(color: AppTheme.accent.opacity(0.3), radius: 10)
                            .padding(.top, 40)
                        
                        if selectedImage == nil {
                            Image("homepic2")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                                .overlay(Color.black.opacity(0))
                        }
                        // Image display area
                        Group {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: AppTheme.accent.opacity(0.5), radius: 10)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(AppTheme.surface)
                                        .frame(height: 280)
                                        .overlay(
                                            VStack {
                                                Image(systemName: "photo.on.rectangle.angled")
                                                    .font(.system(size: 60))
                                                    .foregroundColor(AppTheme.accent.opacity(0.6))
                                                Text("Tap below to select a photo")
                                                    .foregroundColor(AppTheme.textSecondary)
                                                    .font(.subheadline)
                                            }
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Classification Result
                        if !classificationLabel.isEmpty {
                            VStack(spacing: 12) {
                                Text("Result")
                                    .font(.title2.bold())
                                    .foregroundStyle(LinearGradient(colors: [.gray.opacity(0.8), AppTheme.accent],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing))
                                    .padding(.bottom, 4)

                                Text(classificationLabel)
                                    .font(.system(size: 22, weight: .semibold, design: .serif))
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.ultraThinMaterial)
                                                .shadow(color: AppTheme.accent.opacity(0.4), radius: 12, x: 0, y: 6)
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(AppTheme.accent.opacity(0.5), lineWidth: 1)
                                        }
                                    )
                                    .padding(.horizontal)
                                    .transition(.opacity.combined(with: .scale))
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: classificationLabel)
                            }
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black.opacity(0.2))
                                    .shadow(color: AppTheme.accent.opacity(0.3), radius: 8, x: 0, y: 3)
                            )
                            .padding(.horizontal)
                        }


                        // Conditional NavigationLink
                        if let matchedMonument = monumentViewModel.monuments.first(where: {
                            $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                            == classificationLabel.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        }) {
                            NavigationLink(destination: MonumentView(monument: matchedMonument)) {
                                Label("View Details", systemImage: "arrow.right.circle.fill")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textPrimary)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(goldGradient)
                                    .cornerRadius(15)
                                    .shadow(color: AppTheme.accent.opacity(0.6), radius: 8)
                            }
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .slide))
                        }

                        // Choose photo button
                        Button {
                            showSourceMenu = true
                        } label: {
                            Label("Choose Photo", systemImage: "camera.fill")
                                .font(.headline)
                                .foregroundColor(AppTheme.background)
                                .padding()
                                .background(goldGradient)
                                .cornerRadius(15)
                                .shadow(color: AppTheme.accent.opacity(0.5), radius: 6)
                        }
                        .padding(.horizontal)
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

                        Spacer()
                    }
                }
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

    // Classifier stays same
    func classifyImage(_ image: UIImage) {
        classificationLabel = ""  // reset immediately
        guard let ciImage = CIImage(image: image) else { return }
        guard let model = try? VNCoreMLModel(for: MonumentClassifier(configuration: MLModelConfiguration()).model) else {
            print("Failed to load model")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard
                let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
            else {
                DispatchQueue.main.async { classificationLabel = "No Monument detected" }
                return
            }

            let confidencePercent = topResult.confidence * 100
            DispatchQueue.main.async {
                if confidencePercent >= 90 {
                    let cleanName = topResult.identifier.replacingOccurrences(of: "_", with: " ")
                    classificationLabel = cleanName.capitalized
                } else {
                    classificationLabel = "No Monument detected"
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
