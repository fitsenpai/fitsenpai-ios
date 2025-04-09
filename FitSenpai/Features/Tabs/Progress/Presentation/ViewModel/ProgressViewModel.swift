import SwiftUI
import Combine

class ProgressViewModel: ObservableObject {
    @Published var selectedTimeframe: ProgressTimeframe = .ninety
    @Published var weightData: [WeightDataPoint] = []
    @Published var bmiValue: Double = 17.1
    @Published var bmiCategory: BMICategory = .normal
    @Published var showBMIDetail = false
    @Published var showUpdateWeight = false
    @Published var weight: Double = 72.0   // Default 159lb in kg
    @Published var isMetric: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadData()
    }
    
    func updateWeight() {
        showUpdateWeight.toggle()
    }
    
    private func setupBindings() {
        $selectedTimeframe
            .sink { [weak self] timeframe in
                self?.loadData(for: timeframe)
            }
            .store(in: &cancellables)
    }
    
    private func loadData(for timeframe: ProgressTimeframe = .ninety) {
        let calendar = Calendar.current
        
        // For demonstration, generate data points matching the design's date range
        let dates = [
            calendar.date(from: DateComponents(year: 2024, month: 1, day: 17))!,
            calendar.date(from: DateComponents(year: 2024, month: 2, day: 2))!,
            calendar.date(from: DateComponents(year: 2024, month: 2, day: 16))!,
            calendar.date(from: DateComponents(year: 2024, month: 3, day: 2))!,
            calendar.date(from: DateComponents(year: 2024, month: 3, day: 16))!,
            calendar.date(from: DateComponents(year: 2024, month: 4, day: 2))!
        ]
        
        // Generate weight data points with values between 45-55
        weightData = dates.map { date in
            let randomWeight = Double.random(in: 45...55)
            return WeightDataPoint(date: date, weight: randomWeight)
        }
    }
}
