import { router } from '@kit.ArkUI'
import { TemperatureAndHumidity } from '../models/RoomData'
import { LineChart } from '../component/LineChart'
import AutomationSceneManager, { AUTO_MODE_HUMI_AC, AUTO_MODE_HUMI_CURTAIN } from '../models/AutomationSceneManager'
import DeviceDataCache from '../models/DeviceDataCache'
import { CloseAndOpenButton } from '../component/CloseAndOpenButton'
import { HeadBackAndTitleComp } from '../component/HeadBackAndTitleComp'
import { airConditionClass, elecAppTypeConst } from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import { CloseAndYesButton } from '../models/CloseAndYesButton'
import { SliderAdjust } from '../component/SliderAdjust'
import { equipControl, postEquipControl } from '../http/basicEquipAdjust'

const BASE_URL = 'http://43.155.36.236:5000'

@Entry
@Component
struct HumidityDetailPage {
  @State currentHumidity: number = 0
  @State chartImageUrl: string = `${BASE_URL}/chart/humidity`
  private refreshTimer: number = -1
  @State isAirConditionControlEnabled: boolean = false
  @State isCurtainControlEnabled: boolean = false
  private chartTimer: number = -1
  private readonly CHART_REFRESH_INTERVAL = 10 * 1000 // 10秒刷新一次

  private sceneManager: AutomationSceneManager = AutomationSceneManager.getInstance()
  private dataCache: DeviceDataCache = DeviceDataCache.getInstance()

  aboutToAppear() {
    console.info('[Humidity Page] Page aboutToAppear starting...')
    
    // 初始化数据缓存
    this.dataCache.initialize().then(() => {
      // 获取缓存数据
      this.refreshData()
      
      // 设置定时刷新
      this.refreshTimer = setInterval(() => {
        console.info('[Humidity Page] Refresh timer triggered')
        this.refreshData()
      }, 30 * 1000) // 30秒刷新一次

      // 设置图表定时刷新
      this.chartTimer = setInterval(() => {
        console.info('[Humidity Page] Chart refresh timer triggered')
        this.chartImageUrl = `${BASE_URL}/chart/humidity?t=${Date.now()}`
      }, this.CHART_REFRESH_INTERVAL)
    }).catch(() => {
      console.error('[Humidity Page] Error in aboutToAppear')
    })
  }

  aboutToDisappear() {
    console.info('[Humidity Page] Page aboutToDisappear, clearing timers')
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
    }
    if (this.chartTimer !== -1) {
      clearInterval(this.chartTimer)
    }
  }

  async refreshData() {
    try {
      console.info('[Humidity Page] Starting data refresh...')
      
      // 从缓存获取最新数据
      const cacheData = await this.dataCache.getLatestData()
      if (cacheData) {
        this.currentHumidity = cacheData.humidity_indoor
        
        // 更新图表URL时添加时间戳
        this.chartImageUrl = `${BASE_URL}/chart/humidity?t=${Date.now()}`
        console.info('[Humidity Page] Data refreshed from cache successfully')
      }

      // 同时更新场景状态
      console.info('[Humidity Page] Updating scene states after data refresh')
      await this.updateSceneStates()
    } catch (error) {
      console.error('[Humidity Page] Error in refreshData:', error)
    }
  }

  // 更新场景状态
  private async updateSceneStates() {
    try {
      console.info('[Humidity Page] Starting to update scene states...')
      const success = await this.sceneManager.fetchAllScenes()
      console.info('[Humidity Page] fetchAllScenes result:', success)
      
      if (success) {
        const acEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_HUMI_AC)
        const curtainEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_HUMI_CURTAIN)
        
        console.info('[Humidity Page] Previous states - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
        console.info('[Humidity Page] New states - AC:', acEnabled, 'Curtain:', curtainEnabled)
        
        // 只有当状态发生变化时才更新UI
        if (this.isAirConditionControlEnabled !== acEnabled) {
          this.isAirConditionControlEnabled = acEnabled
        }
        if (this.isCurtainControlEnabled !== curtainEnabled) {
          this.isCurtainControlEnabled = curtainEnabled
        }
        
        console.info('[Humidity Page] Scene states updated - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
      } else {
        console.error('[Humidity Page] Failed to fetch scene states')
      }
    } catch (error) {
      console.error('[Humidity Page] Error updating scene states:', error)
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
              .onClick(async () => {
                try {
                  if (!this.isAirConditionControlEnabled) {
                    // 启用湿控空调场景
                    const success = await this.sceneManager.enableScene(AUTO_MODE_HUMI_AC)
                    if (success) {
                      this.isAirConditionControlEnabled = true
                      console.info('[Humidity Page] Air condition control enabled successfully')
                    }
                  } else {
                    // 禁用湿控空调场景
                    const success = await this.sceneManager.disableScene(AUTO_MODE_HUMI_AC)
                    if (success) {
                      this.isAirConditionControlEnabled = false
                      console.info('[Humidity Page] Air condition control disabled successfully')
                    }
                  }
                } catch (error) {
                  console.error('[Humidity Page] Failed to toggle air condition control:', error)
                }
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
              .onClick(async () => {
                try {
                  if (!this.isCurtainControlEnabled) {
                    // 启用湿控窗帘场景
                    const success = await this.sceneManager.enableScene(AUTO_MODE_HUMI_CURTAIN)
                    if (success) {
                      this.isCurtainControlEnabled = true
                      console.info('[Humidity Page] Curtain control enabled successfully')
                    }
                  } else {
                    // 禁用湿控窗帘场景
                    const success = await this.sceneManager.disableScene(AUTO_MODE_HUMI_CURTAIN)
                    if (success) {
                      this.isCurtainControlEnabled = false
                      console.info('[Humidity Page] Curtain control disabled successfully')
                    }
                  }
                } catch (error) {
                  console.error('[Humidity Page] Failed to toggle curtain control:', error)
                }
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