import { McLineChart, Options } from '@mcui/mccharts'

interface TemperatureData {
  temperature_indoor: number;
  created_at: string;
}

@Observed
export class ChartData {
  data: Array<TemperatureData> = []
}

@Component
export struct LineChart {
  @ObjectLink chartData: ChartData

  private getChartOptions(): Options {
    if (this.chartData.data.length === 0) {
      return new Options({
        xAxis: {
          data: []
        },
        yAxis: {
          name: '温度(°C)',
          min: 0,
          max: 50
        },
        series: []
      })
    }

    // 获取数据范围
    const values = this.chartData.data.map(item => item.temperature_indoor)
    const min = Math.floor(Math.min(...values))
    const max = Math.ceil(Math.max(...values))

    // 格式化时间
    const timeLabels = this.chartData.data.map(item => {
      const date = new Date(item.created_at)
      return date.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit'
      })
    })

    return new Options({
      grid: {
        top: '10%',
        right: '5%',
        bottom: '15%',
        left: '10%'
      },
      xAxis: {
        type: 'category',
        data: timeLabels,
        axisLabel: {
          interval: Math.ceil(this.chartData.data.length / 5),
          rotate: 45
        }
      },
      yAxis: {
        type: 'value',
        name: '温度(°C)',
        min: min,
        max: max,
        splitNumber: 5,
        axisLabel: {
          formatter: '{value}°C'
        }
      },
      series: [{
        name: '室内温度',
        type: 'line',
        data: values,
        symbol: 'circle',
        symbolSize: 6,
        lineStyle: {
          width: 2,
          color: '#5686E1'
        },
        itemStyle: {
          color: '#FFFFFF',
          borderColor: '#5686E1',
          borderWidth: 2
        }
      }]
    })
  }

  build() {
    Column() {
      McLineChart({ options: this.getChartOptions() })
        .width('100%')
        .height(300)
    }
    .width('100%')
    .padding(16)
  }
} 