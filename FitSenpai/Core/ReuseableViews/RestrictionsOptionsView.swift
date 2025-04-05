import SwiftUI

struct RestrictionsOptionsView<T>: View where T: Identifiable & Hashable {
    let title: String
    let options: [T]
    let isMultiSelect: Bool
    @Binding var selection: T
    @Binding var selections: Set<T>
    @Binding var showCustomInput: Bool
    let iconProvider: (T) -> String
    let titleProvider: (T) -> String
    let isOtherOption: (T) -> Bool
    let isNoneOption: (T) -> Bool
    
    init(
        title: String,
        options: [T],
        isMultiSelect: Bool,
        selection: Binding<T>,
        selections: Binding<Set<T>>,
        showCustomInput: Binding<Bool>,
        iconProvider: @escaping (T) -> String,
        titleProvider: @escaping (T) -> String,
        isOtherOption: @escaping (T) -> Bool,
        isNoneOption: @escaping (T) -> Bool
    ) {
        self.title = title
        self.options = options
        self.isMultiSelect = isMultiSelect
        self._selection = selection
        self._selections = selections
        self._showCustomInput = showCustomInput
        self.iconProvider = iconProvider
        self.titleProvider = titleProvider
        self.isOtherOption = isOtherOption
        self.isNoneOption = isNoneOption
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                optionRow(for: option)
            }
        }
    }
    
    @ViewBuilder
    private func optionRow(for option: T) -> some View {
        Button {
            handleSelection(option)
        } label: {
            HStack(spacing: 16) {
                
                ZStack {
                    Image(iconProvider(option))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                }
                .padding(8)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected(option) ? Color.gray246 : Color.white)
                )
                
                FSText(
                    text: titleProvider(option),
                    fontStyle: isSelected(option) ? .bodyBold16 : .body16
                )
                Spacer()
            }
            .foregroundColor(.black)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected(option) ? Color.white : Color.gray246)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected(option) ? Color.fsPrimary : Color.clear,
                           lineWidth: isSelected(option) ? 2 : 0)
            )
            .contentShape(Rectangle())
        }
    }
    
    private func handleSelection(_ option: T) {
        if isOtherOption(option) {
            showCustomInput = true
            return
        }
        
        if isMultiSelect {
            if isNoneOption(option) {
                selections = [option]
            } else {
                // Remove "None" option if it exists
                let noneOption = options.first(where: isNoneOption)
                if let noneOption = noneOption {
                    selections.remove(noneOption)
                }
                
                if selections.contains(option) {
                    selections.remove(option)
                } else {
                    selections.insert(option)
                }
            }
        } else {
            selection = option
        }
    }
    
    private func isSelected(_ option: T) -> Bool {
        if isMultiSelect {
            return selections.contains(option)
        } else {
            return selection == option
        }
    }
}
