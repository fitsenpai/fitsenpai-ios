import SwiftUI

struct NameEditView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var firstName: String
    @State private var lastName: String
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        _firstName = State(initialValue: viewModel.firstName)
        _lastName = State(initialValue: viewModel.lastName)
    }
    
    var body: some View {
        BaseProfileEditView(
            title: "Name",
            onSave: {
                Task { @MainActor in
                    await viewModel.updateName(firstName: firstName, lastName: lastName)
                }
            }
        ) {
            VStack(alignment: .leading, spacing: 24) {
                HStack(alignment: .center, spacing: 8) {
                    Text("First name")
                        .foregroundColor(.gray)
                        .padding(.top, 15)
                    RoundedBorderTextField(text: $firstName, placeholder: "", cornerRadius: 12)
                }
                
                HStack(alignment: .center, spacing: 8) {
                    Text("Last Name")
                        .foregroundColor(.gray) 
                        .padding(.top, 15)
                    RoundedBorderTextField(text: $lastName, placeholder: "", cornerRadius: 12)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 16)
    }
}

#Preview {
    NameEditView(viewModel: SettingsViewModel())
}
