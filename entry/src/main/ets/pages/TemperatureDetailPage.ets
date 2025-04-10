import { router } from '@kit.ArkUI'
import { TemperatureAndHumidity } from '../models/RoomData'
import { LineChart } from '../component/LineChart'
import { getTemperatureHistory, getLatestTemperature } from '../http/temperatureData'

const BASE_URL = 'http://43.155.36.236:5000'

@Entry
@Component
struct TemperatureDetailPage {
  @State currentTemp: number = 0
  @State chartImageUrl: string = `${BASE_URL}/chart/temperature`
  @State chartKey: number = 0  // 添加一个状态来强制刷新图表
  private refreshTimer: number = -1

  aboutToAppear() {
    console.info('[Temperature Page] Page aboutToAppear')
    // 获取初始数据
    this.refreshData()
    
    // 设置定时刷新，每5分钟一次
    this.refreshTimer = setInterval(() => {
      console.info('[Temperature Page] Refresh timer triggered')
      this.refreshData()
    }, 5 * 60 * 1000) // 5分钟
  }

  aboutToDisappear() {
    console.info('[Temperature Page] Page aboutToDisappear, clearing timer')
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
    }
  }

  // 刷新数据
  async refreshData() {
    try {
      console.info('[Temperature Page] Refreshing data')
      const latestData = await getLatestTemperature()
      this.currentTemp = latestData.temperature_indoor
      
      // 更新图表URL并增加key以强制刷新
      this.chartImageUrl = `${BASE_URL}/chart/temperature?t=${Date.now()}`
      this.chartKey += 1  // 增加key值强制重新渲染
      
      console.info('[Temperature Page] Data refreshed, chart key:', this.chartKey)
    } catch (error) {
      console.error('[Temperature Page] Failed to refresh data:', error)
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

      Scroll() {
        Column() {
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
            Text('温度历史数据（近5小时）')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8, bottom: 8 })
            
            if (this.chartKey >= 0) {  // 使用条件渲染强制刷新
              LineChart({ 
                imageUrl: this.chartImageUrl
              })
                .width('100%')
                .height(200)
                .margin({ top: 8 })
            }
          }
          .width('94%')
          .margin({ top: 12 })
          .padding({ top: 12, bottom: 12, left: 12, right: 12 })
          .backgroundColor(Color.White)
          .borderRadius(12)

          // 底部按钮
          Row() {
            Button('刷新数据')
              .width('45%')
              .height(40)
              .backgroundColor('#5686E1')
              .borderRadius(20)
              .onClick(() => {
                console.info('[Temperature Page] Refresh button clicked')
                this.refreshData()
              })
            Button('数据分析')
              .width('45%')
              .height(40)
              .backgroundColor('#5686E1')
              .borderRadius(20)
              .onClick(() => {
                console.info('[Temperature Page] Data analysis button clicked')
              })
          }
          .width('94%')
          .margin({ top: 20, bottom: 20 })
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
} 