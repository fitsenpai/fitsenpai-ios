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
    
    // Dynamically calculate y-axis values based on data range with equal spacing
    private var yAxisValues: [Int] {
        guard !data.isEmpty else { return [0, 50, 100] }
        
        let weights = data.map { Int($0.weight) }
        let minWeight = weights.min() ?? 0
        let maxWeight = weights.max() ?? 100
        
        // Calculate a reasonable range with padding
        let range = maxWeight - minWeight
        let padding = max(5, range / 4) // Dynamic padding based on range
        let paddedMin = max(0, minWeight - padding)
        let paddedMax = maxWeight + padding
        
        // Determine number of values (between 3 and 5)
        let count: Int
        if range <= 30 {
            count = 3 // For small ranges, use 3 values
        } else if range <= 60 {
            count = 4 // For medium ranges, use 4 values
        } else {
            count = 5 // For large ranges, use 5 values
        }
        
        // Generate evenly spaced values (including min and max)
        var values: [Int] = []
        for i in 0..<count {
            let value = paddedMin + (paddedMax - paddedMin) * i / (count - 1)
            values.append(value)
        }
        
        return values
    }
    
    // Create indexed dates for even spacing
    private var indexedData: [(index: Int, point: WeightDataPoint)] {
        data.enumerated().map { (index: $0.offset, point: $0.element) }
    }
    
    // Fixed width per data point
    private var chartWidth: CGFloat {
        max(300, CGFloat(data.count) * 60)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            Chart {
                // Add horizontal dashed lines for main weight values
                ForEach(yAxisValues, id: \.self) { value in
                    RuleMark(
                        y: .value("Weight", value)
                    )
                    .lineStyle(gridItemStyle)
                    .foregroundStyle(Color.gray.opacity(0.5))
                }
                
                // Add data points
                ForEach(indexedData, id: \.index) { dataPoint in
                    // Add vertical lines for each label
                    RuleMark(
                        x: .value("Index", dataPoint.index)
                    )
                    .foregroundStyle(Color.gray.opacity(0.08))
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    
                    LineMark(
                        x: .value("Index", dataPoint.index),
                        y: .value("Weight", dataPoint.point.weight)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Index", dataPoint.index),
                        y: .value("Weight", dataPoint.point.weight)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, values: Array(0..<data.count)) { value in
                    if let index = value.as(Int.self),
                       index < data.count {
                        let date = data[index].date
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
            .chartYScale(domain: yAxisValues.first!...yAxisValues.last!) // Explicitly set the y-scale
            .frame(width: chartWidth, height: 153)
            .padding(.vertical, 4)// Fixed height for the chart itself
        }
    }
}
