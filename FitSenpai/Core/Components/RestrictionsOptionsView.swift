import SwiftUI

struct RestrictionsOptionsView<T>: View where T: SelectableItemProtocol {
    let title: String
    let options: [T]
    let isMultiSelect: Bool
    @Binding var selection: T
    @Binding var selections: Set<T>
    @Binding var showCustomInput: Bool
    let isOtherOption: (T) -> Bool
    let isNoneOption: (T) -> Bool
    
    init(
        title: String,
        options: [T],
        isMultiSelect: Bool,
        selection: Binding<T>,
        selections: Binding<Set<T>>,
        showCustomInput: Binding<Bool>,
        isOtherOption: @escaping (T) -> Bool,
        isNoneOption: @escaping (T) -> Bool
    ) {
        self.title = title
        self.options = options
        self.isMultiSelect = isMultiSelect
        self._selection = selection
        self._selections = selections
        self._showCustomInput = showCustomInput
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
            HStack(spacing: 20) {
                if let icon = option.icon {
                    ZStack {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                    }
                    .padding(8)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(isSelected(option) ? Color.gray246 : Color.white)
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    FSTextView(option.title, typography: isSelected(option) ? .p_ui_bold : .p_ui)
                    
                    if let subtitle = option.subtitle {
                        FSText(
                            text: subtitle,
                            fontStyle: .body12
                        )
                    }
                }
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
        triggerHaptics()
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
