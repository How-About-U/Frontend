
import UIKit
import Charts



class MainViewController: UIViewController {
    
    var topic: Topic = Topic(title: "탕수육은 부먹? 찍먹?", red: "부먹", blue: "찍먹")
    lazy var data: [String] = [topic.red,topic.blue]
    var value: [Int] = [1,0]
    var ratioValue: [Double] = [0,0]
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    var user:User? = nil
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        barChartView.delegate = self
        
        subjectLabel.text = topic.title
        
        barChartView.animate(yAxisDuration: 1.0)
        
        barChartView.doubleTapToZoomEnabled = false
        
        barChartView.xAxis.drawGridLinesEnabled = false // 그리드 삭제
        //barChartView.xAxis.drawLabelsEnabled = false // 라벨 삭제
        barChartView.xAxis.drawAxisLineEnabled = false // 선 삭제
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data)
        
        barChartView.xAxis.setLabelCount(value.count, force: false)
        barChartView.xAxis.labelPosition = .bottom
        
        
        //barChartView.leftAxis.enabled = false // 왼쪽 레이블 삭제
        
        barChartView.rightAxis.enabled = false // 오른쪽 레이블 삭제
        barChartView.legend.enabled = false // 범례 삭제
        
        //barChartView.backgroundColor = .red
        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 20)
        
        barChartView.leftAxis.axisMaximum = 100
        barChartView.leftAxis.axisMinimum = 0
        barChartView.minOffset = 30
        
        setChart(dataPoints: data, values: value.map { Double($0) })
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 30)
        barChartView.noDataTextColor = .red
        
        ratioValue[0] = values[0] / ( values[0] + values[1] ) * 100
        ratioValue[1] = values[1] / ( values[0] + values[1] ) * 100
        
        print("values : " ,values)
        print("ratioValue : ", ratioValue)
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: ratioValue[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
        chartDataSet.colors = [.red, .blue]
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 20)
        chartDataSet.valueColors = [.red, .blue]
        chartDataSet.highlightAlpha = 0
        
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }

}

extension MainViewController: ChartViewDelegate{
    
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.data)
        
        let shakingKeyframe = CAKeyframeAnimation(keyPath: "position.x")
        shakingKeyframe.values = [0, 5, -5, 5, 2, 2, -2, 0]
        shakingKeyframe.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        shakingKeyframe.duration = 0.4
        shakingKeyframe.isAdditive = true // true이면 values가 현재 위치 기준, false이면 values가 Screen좌표 기준
        //self.animationTargetView.layer.add(shakingKeyframe, forKey: "shaking")
        
        
//        var set1 = BarChartDataSet()
//        set1 = (chartView.data?.dataSets[0] as? BarChartDataSet)!
//        let values = set1.values
//        let index = values.index(where: {$0.x == highlight.x})  // search index
//
//        set1.circleColors = circleColors
//        set1.circleColors[index!] = NSUIColor.cyan
    
        
        
        if(entry.x == 0.0){
            value[0] += 1
        }
        else if(entry.x == 1.0){
            value[1] += 1
        }
        barChartView.animate(yAxisDuration: 1, easingOption: .easeOutBounce)
        setChart(dataPoints: data, values: value.map { Double($0) })
        return
    }
}
