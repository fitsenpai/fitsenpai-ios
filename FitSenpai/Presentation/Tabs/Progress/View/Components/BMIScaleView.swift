import SwiftUI

struct BMIScaleView: View {
    let bmiValue: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // BMI Scale Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .green, .orange, .red]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: 8)
                    .cornerRadius(4)
                    
                    // BMI Indicator
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 2, height: 16)
                        .offset(x: CGFloat(bmiValue) * geometry.size.width / 40 - 1)
                }
            }
            .frame(height: 16)
        }
    }
}
