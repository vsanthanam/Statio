//
// Statio
// Varun Santhanam
//

import Charts
import Foundation
import UIKit

final class MemoryPressureChartListCell: UICollectionViewListCell, ChartViewDelegate {

    // MARK: - API

    func apply(_ data: [(String, UInt64)]) {
        let entries = data.map { entry -> PieChartDataEntry in
            let (label, value) = entry
            return PieChartDataEntry(value: (Double)(value), label: label)
        }
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = [.red,
                          .orange,
                          .blue,
                          .green,
                          .yellow]
        chart.data = PieChartData(dataSet: dataSet)
    }

    // MARK: - UICollectionViewCell

    override func prepareForReuse() {
        super.prepareForReuse()
        chart.removeFromSuperview()
        addSubview(chart)
        chart.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
                .inset(8.0)
            make
                .height
                .equalTo(200)
        }
        chart.delegate = self
    }

    // MARK: - Private

    private let chart = PieChartView()

}
