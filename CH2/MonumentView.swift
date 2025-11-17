import SwiftUI

extension String: @retroactive Identifiable {
    public var id: String { self }
}

struct MonumentView: View {
    var monument: Monument
    @State private var selectedImage: String?

    // Reuse the gold gradient from the theme
    private let goldGradient = LinearGradient(
        colors: [
            Color(red: 0.9, green: 0.78, blue: 0.43),
            Color(red: 0.78, green: 0.66, blue: 0.30)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: AppTheme.gradient,
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {

                    // Main Monument Image
                    Image(monument.imageName[0])
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(4)
                        .shadow(color: AppTheme.accent.opacity(0.4), radius: 10, x: 0, y: 6)
                        .onTapGesture {
                            selectedImage = monument.imageName[0]
                        }

                        Text(monument.name)
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                        .foregroundStyle(goldGradient)
                        .shadow(color: AppTheme.accent.opacity(0.6), radius: 10)
                        .frame(maxWidth: .infinity, alignment: .center)


                    // Country and City
                    VStack(alignment: .leading, spacing: 4) {
                        Text(monument.country)
                            .font(.title3)
                            .foregroundColor(AppTheme.textPrimary)
                        Text(monument.city)
                            .font(.title3)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .padding(.horizontal)

                    // Description Card
                    Text(monument.description)
                        .font(.body)
                        .foregroundColor(AppTheme.textPrimary)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .shadow(color: AppTheme.accent.opacity(0.25), radius: 6)
                        .padding(.horizontal)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    // Gallery Section Title
                    Text("Gallery")
                        .font(.headline)
                        .foregroundColor(AppTheme.accent)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    // Horizontal image scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(monument.imageName.dropFirst(), id: \.self) { imgName in
                                Image(imgName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 120)
                                    .clipped()
                                    .cornerRadius(10)
                                    .shadow(color: AppTheme.accent.opacity(0.3), radius: 6)
                                    .onTapGesture {
                                        selectedImage = imgName
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
                .padding(.top, 10)
            }
        }
        // Full-screen image sheet
        .sheet(item: $selectedImage) { imageName in
            ZStack {
                Color.black.ignoresSafeArea()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .onTapGesture {
                        selectedImage = nil
                    }
            }
        }
    }
}



#Preview {
    MonumentView(monument: MonumentViewModel().monuments.first!)
}
