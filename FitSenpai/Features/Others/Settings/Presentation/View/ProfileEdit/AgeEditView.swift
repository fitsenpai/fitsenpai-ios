import SwiftUI

struct AgeEditView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: SettingsViewModel
    @State private var age: Int
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _age = State(initialValue: viewModel.profile.age)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Age",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateAge(age, modelContext: modelContext)
                }
            }
        ) {
            VStack(spacing: 24) {
                Picker("", selection: $age) {
                    ForEach(14...100, id: \.self) { age in
                        FSText(text: "\(age)", fontStyle: .bodyBold20)
                            .tag(age)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 200, height: 200)
                .padding(.top, 32)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    AgeEditView(viewModel: SettingsViewModel())
}
