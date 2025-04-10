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
  @State isPowerSavingEnabled: boolean = false
  @State isPowerAlertEnabled: boolean = false

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
            .width('100%')
            .margin({ top: 16 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('94%')
          .margin({ top: 12 })
          .padding({ top: 12, bottom: 12, left: 12, right: 12 })
          .backgroundColor(Color.White)
          .borderRadius(12)

          // 智能场景控制
          Column() {
            Text('智能场景一键开启')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8, bottom: 16 })
            
            Row() {
              Button() {
                Row() {
                  Image($r('app.media.elec'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isPowerSavingEnabled ? Color.White : '#666666')
                  Text('提前断电')
                    .fontSize(14)
                    .fontColor(this.isPowerSavingEnabled ? Color.White : '#666666')
                }
              }
              .width('45%')
              .height(40)
              .backgroundColor(this.isPowerSavingEnabled ? '#5686E1' : '#E8E8E8')
              .borderRadius(20)
              .onClick(() => {
                this.isPowerSavingEnabled = !this.isPowerSavingEnabled;
                console.info('[Power Page] Power saving mode ' + (this.isPowerSavingEnabled ? 'enabled' : 'disabled'));
              })
              
              Button() {
                Row() {
                  Image($r('app.media.message_ad'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isPowerAlertEnabled ? Color.White : '#666666')
                  Text('用电提醒')
                    .fontSize(14)
                    .fontColor(this.isPowerAlertEnabled ? Color.White : '#666666')
                }
              }
              .width('45%')
              .height(40)
              .backgroundColor(this.isPowerAlertEnabled ? '#5686E1' : '#E8E8E8')
              .borderRadius(20)
              .onClick(() => {
                this.isPowerAlertEnabled = !this.isPowerAlertEnabled;
                console.info('[Power Page] Power alert ' + (this.isPowerAlertEnabled ? 'enabled' : 'disabled'));
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('94%')
          .margin({ top: 12, bottom: 20 })
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
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