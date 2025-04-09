import SwiftUI

struct BaseProfileEditView<Content: View>: View {
    let title: String
    let subtitle: String?
    let onSave: () -> Void
    let onBack: (() -> Void)?
    @ViewBuilder let content: () -> Content
    @Environment(\.dismiss) var dismiss
    
    init(
        title: String,
        subtitle: String? = nil,
        onSave: @escaping () -> Void = {},
        onBack: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onSave = onSave
        self.content = content
        self.onBack = onBack
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                FSText(text: title, fontStyle: .bodyBold28)
                
                if let subtitle {
                    FSText(text: subtitle, fontStyle: .body14, color: .secondary)
                }
            }
            
            content()
            
            Spacer()
            
            FSButton(title: "Save changes", fontStyle: .bodyBold16, cornerRadius: 32) {
                onSave()
                dismiss()
            }
            
        }
        .padding(24)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    onBack?() ?? dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Circle().fill(Color.gray246))
                }
            }
        }
    }
}
