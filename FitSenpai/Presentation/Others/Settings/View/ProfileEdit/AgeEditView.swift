import SwiftUI

struct AgeEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var age: Int
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _age = State(initialValue: Int(viewModel.profile.birthYear ?? "0") ?? 0)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Age",
            onSave: {
                Task { 
                    await viewModel.updateAge(age)
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
