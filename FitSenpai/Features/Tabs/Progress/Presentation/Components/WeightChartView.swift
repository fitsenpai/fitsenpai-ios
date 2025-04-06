import SwiftUI
import Charts

struct WeightChartView: View {
    let data: [WeightDataPoint]
    
    private var gridItemStyle: StrokeStyle {
        StrokeStyle(
            lineWidth: 1,
            dash: [5, 3]
        )
    }
    
    private let yAxisValues = [45, 50, 55]
    
    private var xAxisDates: [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2024, month: 2, day: 2))!
        
        return [
            startDate,
            calendar.date(byAdding: .day, value: 14, to: startDate)!,
            calendar.date(byAdding: .day, value: 28, to: startDate)!,
            calendar.date(byAdding: .day, value: 42, to: startDate)!
        ]
    }
    
    var body: some View {
        ZStack {
            Chart {
                // Add vertical lines for each label
                ForEach(xAxisDates, id: \.self) { date in
                    RuleMark(
                        x: .value("Date", date)
                    )
                    .foregroundStyle(Color.gray.opacity(0.1))
                    .lineStyle(StrokeStyle(lineWidth: 1))
                }
                
                // Add horizontal dashed lines for main weight values
                ForEach(yAxisValues, id: \.self) { value in
                    RuleMark(
                        y: .value("Weight", value)
                    )
                    .lineStyle(gridItemStyle)
                    .foregroundStyle(Color.gray.opacity(0.5))
                }
                
                // Data points and line
                ForEach(data) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Weight", point.weight)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", point.date),
                        y: .value("Weight", point.weight)
                    )
                    .foregroundStyle(.blue)
                }
                .opacity(0) // Hide the line and points for now
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, values: xAxisDates) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(anchor: .center, multiLabelAlignment: .leading, verticalSpacing: 20) {
                            FSText(
                                text: date.formatted(.dateTime.month(.abbreviated).day()),
                                fontStyle: .body10,
                                color: .gray
                            )
                        }
                        
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: yAxisValues) { value in
                    AxisValueLabel {
                        if let weight = value.as(Int.self) {
                            FSText(text: "\(weight)", fontStyle: .body10)
                                .padding(.trailing, 4)
                        }
                    }
                }
            }
            .chartYScale(domain: 45...55)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(Color.white)
            }
        }
    }
}

#Preview {
    WeightChartView(data: [
        WeightDataPoint(date: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 16))!, weight: 55),
        WeightDataPoint(date: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2))!, weight: 52),
        WeightDataPoint(date: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 16))!, weight: 51),
        WeightDataPoint(date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 2))!, weight: 49),
        WeightDataPoint(date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 16))!, weight: 48),
        WeightDataPoint(date: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 2))!, weight: 48)
    ])
    .frame(height: 120)
    .padding()
    .background(Color(.systemGray6))
}
