import SwiftUI

struct MyMonumentView: View {
    @StateObject private var monumentviewmodel = MonumentViewModel()

    private let goldGradient = LinearGradient(
        colors: [
            Color(red: 0.9, green: 0.78, blue: 0.43),
            Color(red: 0.78, green: 0.66, blue: 0.30)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(colors: AppTheme.gradient,
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Title
                    Text("My Monuments")
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                        .foregroundStyle(goldGradient)
                        .shadow(color: AppTheme.accent.opacity(0.5), radius: 10)
                        .padding(.top, 30)

                    // Monuments list
                    List {
                        ForEach(monumentviewmodel.monuments) { monument in
                            NavigationLink(destination: MonumentView(monument: monument)) {
                                HStack(spacing: 15) {
                                    Image(monument.imageName[0])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .cornerRadius(10)
                                        .shadow(color: AppTheme.accent.opacity(0.4), radius: 4)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(monument.name)
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)

                                        Text("\(monument.city), \(monument.country)")
                                            .font(.subheadline)
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(AppTheme.accent)
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.black.opacity(0.6))
                            .listRowSeparatorTint(AppTheme.accent.opacity(0.4))
                        }
                    }
                    .scrollContentBackground(.hidden) // hides system list background
                    .background(Color.clear)
                    .listStyle(.insetGrouped)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MyMonumentView()
}
