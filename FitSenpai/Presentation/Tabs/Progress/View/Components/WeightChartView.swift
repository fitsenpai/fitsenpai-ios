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
    

    private let yAxisValues = [0, 50, 100, 150, 200]
    
    private var xAxisDates: [Date] {
        data.map { $0.date }.sorted()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Chart {
                // Add vertical lines for each label
                ForEach(xAxisDates, id: \.self) { date in
                    RuleMark(
                        x: .value("Date", date)
                    )
                    .foregroundStyle(Color.gray.opacity(0.08))
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
        }
    }
}

#Preview {
    WeightChartView(data: [])
    .frame(height: 153)
    .padding()
    .background(Color(.white))
}
