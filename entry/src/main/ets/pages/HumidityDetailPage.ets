import { router } from '@kit.ArkUI'
import { TemperatureAndHumidity } from '../models/RoomData'
import { LineChart } from '../component/LineChart'
import { getLatestTemperatureHumidity } from '../http/temperatureAndHumidity'

const BASE_URL = 'http://43.155.36.236:5000'

@Entry
@Component
struct HumidityDetailPage {
  @State currentHumidity: number = 0
  @State chartImageUrl: string = `${BASE_URL}/chart/humidity`
  private refreshTimer: number = -1
  @State isAirConditionControlEnabled: boolean = false
  @State isCurtainControlEnabled: boolean = false

  aboutToAppear() {
    console.info('[Humidity Page] Page aboutToAppear, initiating initial data load')
    // 立即加载数据
    this.refreshData()
    
    // 设置定时刷新
    this.refreshTimer = setInterval(() => {
      console.info('[Humidity Page] Refresh timer triggered')
      this.refreshData()
    }, 5 * 60 * 1000)
  }

  aboutToDisappear() {
    console.info('[Humidity Page] Page aboutToDisappear, clearing timer')
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
    }
  }

  async refreshData() {
    try {
      console.info('[Humidity Page] Refreshing data')
      const latestData = await getLatestTemperatureHumidity()
      if (latestData.status === 'success' && latestData.latest) {
        this.currentHumidity = latestData.latest.humidity_indoor
        
        // 更新图表URL时添加时间戳
        this.chartImageUrl = `${BASE_URL}/chart/humidity?t=${Date.now()}`
        console.info('[Humidity Page] Data refreshed successfully, new URL:', this.chartImageUrl)
      }
    } catch (error) {
      console.error('[Humidity Page] Failed to refresh data:', error.toString())
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
        Text('湿度详情')
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
              Image($r('app.media.humidity2'))
                .width(32)
                .height(32)
              Column() {
                Text('当前湿度')
                  .fontSize(14)
                  .fontColor(Color.Gray)
                Row() {
                  Text(this.currentHumidity.toFixed(1))
                    .fontSize(36)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#5686E1')
                  Text('%')
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
            Text('湿度历史数据（近5小时）')
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
                  console.info('[Humidity Page] Refresh button clicked')
                  this.refreshData()
                })
              Button('数据分析')
                .width('45%')
                .height(40)
                .backgroundColor('#5686E1')
                .borderRadius(20)
                .onClick(() => {
                  console.info('[Humidity Page] Data analysis button clicked')
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
                  Image($r('app.media.airCondition'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isAirConditionControlEnabled ? Color.White : '#666666')
                  Text('湿控空调')
                    .fontSize(14)
                    .fontColor(this.isAirConditionControlEnabled ? Color.White : '#666666')
                }
              }
              .width('45%')
              .height(40)
              .backgroundColor(this.isAirConditionControlEnabled ? '#5686E1' : '#E8E8E8')
              .borderRadius(20)
              .onClick(() => {
                this.isAirConditionControlEnabled = !this.isAirConditionControlEnabled;
                console.info('[Humidity Page] Air condition control ' + (this.isAirConditionControlEnabled ? 'enabled' : 'disabled'));
              })
              
              Button() {
                Row() {
                  Image($r('app.media.curtain'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isCurtainControlEnabled ? Color.White : '#666666')
                  Text('湿控窗帘')
                    .fontSize(14)
                    .fontColor(this.isCurtainControlEnabled ? Color.White : '#666666')
                }
              }
              .width('45%')
              .height(40)
              .backgroundColor(this.isCurtainControlEnabled ? '#5686E1' : '#E8E8E8')
              .borderRadius(20)
              .onClick(() => {
                this.isCurtainControlEnabled = !this.isCurtainControlEnabled;
                console.info('[Humidity Page] Curtain control ' + (this.isCurtainControlEnabled ? 'enabled' : 'disabled'));
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