import SwiftUI

protocol SelectableItemProtocol: CaseIterable, Identifiable & Hashable, RawRepresentable where RawValue == String {
    var id: String { get }
    var title: String { get }
    var subtitle: String? { get }
    var icon: ImageResource? { get }
    
    func toOption() -> OptionItem
}

extension SelectableItemProtocol {
    var subtitle: String? { nil }
    var icon: ImageResource? { nil }
    
    func toOption() -> OptionItem {
        .init(id: self.id, name: self.title, description: self.subtitle)
    }
    
    static func from(rawValue: String?) -> Self? {
        guard let rawValue, let value = Self(rawValue: rawValue) else {
            return nil
        }
        return value
    }
}

struct MultiSelectableOptionsView<T: SelectableItemProtocol>: View {
    let options: [T]
    @Binding var selections: [T]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                SelectableOptionCell(
                    option: option,
                    isSelected: selections.contains(option),
                    iconName: option.icon,
                    title: option.title,
                    subtitle: option.subtitle
                ) {
                    if selections.contains(option) {
                        selections = selections.filter { $0.id != option.id }
                    } else {
                        selections.append(option)
                    }
                }
            }
        }
    }
}

// MARK: - Reusable Selection View
struct SelectableOptionsView<T: SelectableItemProtocol>: View {
    let options: [T]
    @Binding var selection: T?
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(options) { option in
                SelectableOptionCell(
                    option: option,
                    isSelected: option.id == selection?.id,
                    iconName: option.icon,
                    title: option.title,
                    subtitle: option.subtitle
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
    let iconName: ImageResource?
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    private let iconSize: CGFloat = 16
    private let iconContainerSize: CGFloat = 36
    
    var body: some View {
        Button(action: onTapGesture) {
            HStack {
                HStack(spacing: 20) {
                    if let iconName {
                        IconContainer(
                            iconName: iconName,
                            isSelected: isSelected
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        FSTextView(title, typography: isSelected ? .p_ui_bold : .p_ui)
                        
                        if let subtitle {
                            FSText(
                                text: subtitle,
                                fontStyle: .body12
                            )
                        }
                    }
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
    
    func onTapGesture() {
        triggerHaptics()
        action()
    }
}

// MARK: - Icon Container
private struct IconContainer: View {
    let iconName: ImageResource
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            
        }
        .padding(8)
        .frame(width: 40, height: 40)
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
