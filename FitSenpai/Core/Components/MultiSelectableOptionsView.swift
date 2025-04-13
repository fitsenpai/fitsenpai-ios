import SwiftUI

struct MultiSelectableOptionsView<T: Identifiable & Hashable>: View {
    let options: [T]
    @Binding var selections: Set<T>
    var iconProvider: ((T) -> String)? = nil
    var titleProvider: ((T) -> String)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                SelectableOptionCell(
                    option: option,
                    isSelected: selections.contains(option),
                    iconName: iconProvider?(option),
                    title: titleProvider?(option)
                ) {
                    if selections.contains(option) {
                        selections.remove(option)
                    } else {
                        selections.insert(option)
                    }
                }
            }
        }
    }
}

// MARK: - Reusable Selection View
struct SelectableOptionsView<T: Identifiable>: View {
    let options: [T]
    @Binding var selection: T
    var iconProvider: ((T) -> String)? = nil
    var titleProvider: ((T) -> String)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                SelectableOptionCell(
                    option: option,
                    isSelected: option.id == selection.id,
                    iconName: iconProvider?(option),
                    title: titleProvider?(option)
                ) {
                    selection = option
                }
            }
        }
    }
}

// MARK: - Selection Cell
struct SelectableOptionCell<T>: View {
    let option: T
    let isSelected: Bool
    let iconName: String?
    let title: String?
    let action: () -> Void
    
    private let iconSize: CGFloat = 16
    private let iconContainerSize: CGFloat = 36
    
    var body: some View {
        Button(action: action) {
            HStack {
                HStack(spacing: 12) {
                    if let iconName {
                        IconContainer(
                            iconName: iconName,
                            isSelected: isSelected
                        )
                    }
                    
                    FSText(
                        text: title ?? "",
                        fontStyle: isSelected ? .bodyBold16 : .body16
                    )
                }
                
                Spacer()
            }
            .foregroundColor(.black)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white : Color.gray246)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.fsPrimary : Color.clear,
                           lineWidth: isSelected ? 2 : 0)
            )
            .contentShape(Rectangle())
        }
    }
}

// MARK: - Icon Container
private struct IconContainer: View {
    let iconName: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            
        }
        .padding(8)
        .frame(width: 36, height: 36)
        .background(
            Circle()
                .fill(isSelected ? Color.gray246 : Color.white)
        )
    }
}

// MARK: - Preview Provider
struct GenderEditView_Previews: PreviewProvider {
    static var previews: some View {
        GenderEditView(viewModel: SettingsViewModel())
    }
}
