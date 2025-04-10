import { router } from '@kit.ArkUI'
import { LineChart } from '../component/LineChart'
import { getLatestElectricityData } from '../http/electricityData'
import { ElectricityData } from '../models/ElectricityData'

const BASE_URL = 'http://43.155.36.236:5000'

@Entry
@Component
struct PowerDetailPage {
  @State currentPower: number = 0  // 当前功率（mW）
  @State chartImageUrl: string = `${BASE_URL}/chart/power`
  private refreshTimer: number = -1

  aboutToAppear() {
    console.info('[Power Page] Page aboutToAppear, initiating initial data load')
    // 立即加载数据
    this.refreshData()
    
    // 设置定时刷新
    this.refreshTimer = setInterval(() => {
      console.info('[Power Page] Refresh timer triggered')
      this.refreshData()
    }, 5 * 60 * 1000)
  }

  aboutToDisappear() {
    console.info('[Power Page] Page aboutToDisappear, clearing timer')
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
    }
  }

  async refreshData() {
    try {
      console.info('[Power Page] Refreshing data')
      const response = await getLatestElectricityData()
      if (response.status === 'success' && response.latest) {
        // 将微瓦转换为毫瓦
        this.currentPower = response.latest.power / 1000
        
        // 更新图表URL时添加时间戳
        this.chartImageUrl = `${BASE_URL}/chart/power?t=${Date.now()}`
        console.info('[Power Page] Data refreshed successfully, new URL:', this.chartImageUrl)
      }
    } catch (error) {
      console.error('[Power Page] Failed to refresh data:', error.toString())
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
        Text('用电详情')
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
          Column() {
            Row() {
              Image($r('app.media.elec'))
                .width(32)
                .height(32)
              Column() {
                Text('当前功率')
                  .fontSize(14)
                  .fontColor(Color.Gray)
                Row() {
                  Text(this.currentPower.toFixed(2))
                    .fontSize(36)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#5686E1')
                  Text('mW')
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

          Column() {
            Text('用电历史数据（近5小时）')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8, bottom: 8 })
            
            LineChart({ 
              imageUrl: this.chartImageUrl
            })
              .width('100%')
              .height(300)
              .margin({ top: 8 })
          }
          .width('94%')
          .margin({ top: 12 })
          .padding({ top: 12, bottom: 12, left: 12, right: 12 })
          .backgroundColor(Color.White)
          .borderRadius(12)

          Row() {
            Button('刷新数据')
              .width('45%')
              .height(40)
              .backgroundColor('#5686E1')
              .borderRadius(20)
              .onClick(() => {
                console.info('[Power Page] Refresh button clicked')
                this.refreshData()
              })
            Button('数据分析')
              .width('45%')
              .height(40)
              .backgroundColor('#5686E1')
              .borderRadius(20)
              .onClick(() => {
                console.info('[Power Page] Data analysis button clicked')
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