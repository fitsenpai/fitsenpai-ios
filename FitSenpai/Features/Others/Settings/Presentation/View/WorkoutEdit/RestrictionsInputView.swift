import SwiftUI

struct RestrictionsInputView: View {
    let title: String
    let placeholder: String
    let initialValue: String
    let onSave: (String) -> Void
    
    @Binding var showCustomInput: Bool
    @State private var inputText: String
    @Environment(\.dismiss) var dismiss
    
    init(
        title: String,
        placeholder: String,
        initialValue: String = "",
        showCustomInput: Binding<Bool>,
        onSave: @escaping (String) -> Void
    ) {
        self.title = title
        self.placeholder = placeholder
        self.initialValue = initialValue
        self._showCustomInput = showCustomInput
        self.onSave = onSave
        _inputText = State(initialValue: initialValue)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Enter \(title)",
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
                    label: placeholder,
                    cornerRadius: 12
                )
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    RestrictionsInputView(
        title: "dietary preference",
        placeholder: "Enter your dietary preference",
        showCustomInput: .constant(true)
    ) { _ in }
}
