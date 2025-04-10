import { router } from '@kit.ArkUI'
import { TemperatureAndHumidity } from '../models/RoomData'
import { LineChart, ChartData } from '../component/LineChart'
import { getTemperatureHistory } from '../http/temperatureData'

interface TemperatureData {
  temperature_indoor: number;
  created_at: string;
}

@Entry
@Component
struct TemperatureDetailPage {
  @State currentTemp: number = 0
  @State chartData: ChartData = new ChartData()
  private refreshTimer: number = -1

  aboutToAppear() {
    // 获取初始数据
    this.getTempHistory()
    
    // 设置定时刷新
    this.refreshTimer = setInterval(() => {
      this.getTempHistory()
    }, 10000)
  }

  aboutToDisappear() {
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
    }
  }

  // 获取历史温度数据
  async getTempHistory() {
    try {
      const data = await getTemperatureHistory()
      this.chartData.data = data.slice(0, 20).reverse() // 只取最新的20条数据并反转顺序
      if (data.length > 0) {
        this.currentTemp = data[0].temperature_indoor
      }
    } catch (error) {
      console.error('获取温度数据失败:', error)
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.back'))
          .width(24)
          .height(24)
          .margin({ left: 15 })
          .onClick(() => {
            router.back()
          })
        Text('温度详情')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 15 })
        Blank()
      }
      .width('100%')
      .height(50)
      .backgroundColor(Color.White)

      // 当前温度显示
      Column() {
        Row() {
          Image($r('app.media.temperature_set'))
            .width(32)
            .height(32)
          Column() {
            Text('当前温度')
              .fontSize(14)
              .fontColor(Color.Gray)
            Row() {
              Text(this.currentTemp.toFixed(1))
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5686E1')
              Text('°C')
                .fontSize(16)
                .fontColor('#5686E1')
                .margin({ left: 4 })
            }
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding(20)
      }
      .width('94%')
      .margin({ top: 12 })
      .backgroundColor(Color.White)
      .borderRadius(12)

      // 历史数据图表
      Column() {
        Text('温度历史数据')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 8, bottom: 16 })
        
        if (this.chartData.data.length > 0) {
          LineChart({ chartData: this.chartData })
            .width('100%')
            .height(200)
        } else {
          Text('暂无历史数据')
            .fontSize(14)
            .fontColor(Color.Gray)
        }
      }
      .width('94%')
      .margin({ top: 12 })
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(12)

      // 底部按钮
      Row() {
        Button('导出数据')
          .width('45%')
          .height(40)
          .backgroundColor('#5686E1')
          .borderRadius(20)
          .onClick(() => {
            // TODO: 处理数据导出
          })
        Button('数据分析')
          .width('45%')
          .height(40)
          .backgroundColor('#5686E1')
          .borderRadius(20)
          .onClick(() => {
            // TODO: 处理数据分析
          })
      }
      .width('94%')
      .margin({ top: 20 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
} 