import SwiftUI

struct OthersInputView: View {
    let title: String
    var subtitle: String?
    let placeholder: String
    let initialValue: String
    let onSave: (String) -> Void
    
    @Binding var showCustomInput: Bool
    @State private var inputText: String
    @Environment(\.dismiss) var dismiss
    
    init(
        title: String,
        subtitle: String? = nil,
        placeholder: String,
        initialValue: String = "",
        showCustomInput: Binding<Bool>,
        onSave: @escaping (String) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.placeholder = placeholder
        self.initialValue = initialValue
        self._showCustomInput = showCustomInput
        self.onSave = onSave
        _inputText = State(initialValue: initialValue)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: title,
            subtitle: subtitle,
            onSave: {
                if !inputText.isEmpty {
                    onSave(inputText)
                }
                showCustomInput = false
                dismiss()
            }, onBack: {
                showCustomInput = false
            }
        ) {
            VStack(alignment: .leading, spacing: 24) {
                RoundedBorderTextField(
                    text: $inputText,
                    placeholder: placeholder,
                    cornerRadius: 8
                )
                .padding(.vertical, 12)
            }
        }
    }
}

#Preview {
    OthersInputView(
        title: "dietary preference",
        placeholder: "Enter your dietary preference",
        showCustomInput: .constant(true)
    ) { _ in }
}
