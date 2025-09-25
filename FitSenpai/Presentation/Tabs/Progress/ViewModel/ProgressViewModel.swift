import SwiftUI
import Combine
import CoreKit

@MainActor
class ProgressViewModel: ObservableObject {
    @Published var viewState: ViewState = .idle
    @Published var profile: UserProfile?
    @Published var selectedTimeframe: ProgressTimeframe = .ninety
    @Published var weightData: [WeightDataPoint] = []
    @Published var bmiValue: Double = 0
    @Published var bmiCategory: BMICategory = .normal
    @Published var showBMIDetail = false
    @Published var showUpdateWeight = false
    @Published var weight: Double = 72.0   // Default 159lb in kg
    @Published var isMetric: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject private var getBMIUseCase: GetBMIUseCaseProtocol
    @Inject private var getWeigthsUseCase: GetWeightsUseCaseProtocol
    @Inject private var createWeightsUseCase: CreateWeightsUseCaseProtocol
    @Inject private var getUserProfileUseCase: GetUserProfileUseCaseProtocol
    @Inject private var saveUserProfileUseCase: SaveUserProfileUseCaseProtocol
    
    // MARK: - Use Cases

    @AppState(\.userID) private var id: String?

    init() {
        setupBindings()
        loadAllData()
    }
    
    func loadAllData() {
        self.loadProfile()
        self.loadData()
        self.loadBMI()
    }
    
    func updateWeight() {
        triggerHaptics()
        showUpdateWeight.toggle()
    }
    
    func getBMI() async throws -> BMIData {
        return try await getBMIUseCase.execute(id: id ?? "")
    }
    
    func getWeigths() async throws -> [WeightDataPoint] {
        return try await getWeigthsUseCase.execute()
    }
    
    func createWeigths(weight: Double) async {
        guard var profile else { return }
        viewState = .loading
        defer { viewState = .idle }
        try? await Task.sleep(for: .seconds(2))
        profile.weight = Int(weight)
        do {
            self.profile = try await saveUserProfileUseCase.execute(profile)
            self.weight = weight
            self.viewState = .idle
            self.loadData()
        } catch {
            self.viewState = .idle
            ToastManager.shared.showError(error.localizedDescription)
        }
    }
    
    
    private func setupBindings() {
        $selectedTimeframe
            .sink { [weak self] timeframe in
                self?.loadData(for: timeframe)
            }
            .store(in: &cancellables)
    }
    
    
    
    private func loadProfile() {
        Task { @MainActor in
            self.profile = try? await self.getUserProfileUseCase.execute()
            self.weight = Double(profile?.weight ?? 0)
        }
    }
    
    private func loadBMI() {
        Task {
            do {
                let bmiData = try await getBMI()
                self.bmiValue = bmiData.bmi
                self.bmiCategory = BMICategory(rawValue: bmiData.status.capitalized) ?? .normal
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadData(for timeframe: ProgressTimeframe = .ninety) {
        Task {
            viewState = .loading
            defer { viewState = .idle }
            do {
                let response = try await getWeigths()
                // Filter weight data based on selected timeframe
                switch timeframe {
                case .allTime:
                    weightData = response
                case .ninety:
                    weightData = response.filter { $0.date >= Calendar.current.date(byAdding: .day, value: -90, to: Date())! }
                case .sixMonths:
                    weightData = response.filter { $0.date >= Calendar.current.date(byAdding: .month, value: -6, to: Date())! }
                case .oneYear:
                    weightData = response.filter { $0.date >= Calendar.current.date(byAdding: .year, value: -1, to: Date())! }
                }
                self.weight = response.last?.weight ?? 0
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
