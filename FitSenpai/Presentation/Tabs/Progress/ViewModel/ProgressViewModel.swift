import SwiftUI
import Combine
import CoreKit

@MainActor
class ProgressViewModel: ObservableObject {
    @Published var viewState: ViewState = .idle
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

    @AppState(\.userID) private var id: String?

    init() {
        setupBindings()
        initializeData()
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
        
        let date = Date()
        viewState = .loading
        defer { viewState = .idle }
        try? await Task.sleep(for: .seconds(2))
        let newWeights = WeightDataPoint(date: date, weight: weight)

        do {
            let _ = try await createWeightsUseCase.execute(.init(weight: weight, date: date.toString(WithFormat: "yyyy-MM-dd")))
            self.weightData.append(newWeights)
            self.viewState = .idle
        } catch {
            self.viewState = .idle
        }
    }
    
    
    private func setupBindings() {
        $selectedTimeframe
            .sink { [weak self] timeframe in
                self?.loadData(for: timeframe)
            }
            .store(in: &cancellables)
    }
    
    private func initializeData() {
        self.loadData()
        self.loadBMI()
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
