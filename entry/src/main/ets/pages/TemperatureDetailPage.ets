import { router } from '@kit.ArkUI'
import { TemperatureAndHumidity } from '../models/RoomData'
import { LineChart } from '../component/LineChart'
import { getTemperatureHistory } from '../http/temperatureData'
import AutomationSceneManager, { AUTO_MODE_TEMP_AC, AUTO_MODE_TEMP_CURTAIN } from '../models/AutomationSceneManager'
import DeviceDataCache from '../models/DeviceDataCache'
import { CloseAndOpenButton } from '../component/CloseAndOpenButton'
import { HeadBackAndTitleComp } from '../component/HeadBackAndTitleComp'
import { airConditionClass, elecAppTypeConst } from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import { CloseAndYesButton } from '../models/CloseAndYesButton'
import { SliderAdjust } from '../component/SliderAdjust'
import { equipControl, postEquipControl } from '../http/basicEquipAdjust'
import promptAction from '@ohos.promptAction'

const BASE_URL = 'http://43.155.36.236:5000'

@Entry
@Component
struct TemperatureDetailPage {
  @State currentTemp: number = 0
  @State chartImageUrl: string = `${BASE_URL}/chart/temperature`
  private refreshTimer: number = -1
  @State isAirConditionControlEnabled: boolean = false
  @State isCurtainControlEnabled: boolean = false
  private chartTimer: number = -1
  private temperatureCheckTimer: number = -1
  private readonly CHART_REFRESH_INTERVAL = 10 * 1000 // 10秒刷新一次
  private readonly TEMP_CHECK_INTERVAL = 20 * 1000 // 20秒检查一次温度

  private sceneManager: AutomationSceneManager = AutomationSceneManager.getInstance()
  private dataCache: DeviceDataCache = DeviceDataCache.getInstance()

  aboutToAppear() {
    console.info('[Temperature Page] Page aboutToAppear starting...')
    
    // 初始化数据缓存
    this.dataCache.initialize().then(() => {
      // 获取缓存数据
      this.refreshData()
      
      // 设置定时刷新
      this.refreshTimer = setInterval(() => {
        console.info('[Temperature Page] Refresh timer triggered')
        this.refreshData()
      }, 30 * 1000) // 30秒刷新一次

      // 设置图表定时刷新
      this.chartTimer = setInterval(() => {
        console.info('[Temperature Page] Chart refresh timer triggered')
        this.chartImageUrl = `${BASE_URL}/chart/temperature?t=${Date.now()}`
      }, this.CHART_REFRESH_INTERVAL)

      // 设置温度检查定时器
      this.startTemperatureCheck()
    }).catch(() => {
      console.error('[Temperature Page] Error in aboutToAppear')
    })
  }

  aboutToDisappear() {
    console.info('[Temperature Page] Page aboutToDisappear, clearing timers')
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
    }
    if (this.chartTimer !== -1) {
      clearInterval(this.chartTimer)
    }
    if (this.temperatureCheckTimer !== -1) {
      clearInterval(this.temperatureCheckTimer)
    }
  }

  // 开始温度检查定时器
  private startTemperatureCheck() {
    if (this.temperatureCheckTimer !== -1) {
      clearInterval(this.temperatureCheckTimer)
    }
    // 立即执行一次检查
    this.checkTemperature()
    // 设置定时检查
    this.temperatureCheckTimer = setInterval(() => {
      this.checkTemperature()
    }, this.TEMP_CHECK_INTERVAL)
  }

  // 检查温度并显示提醒
  private checkTemperature() {
    if (this.isAirConditionControlEnabled && this.currentTemp > 25) {
      promptAction.showToast({
        message: '监测到环境温度大于25度，已自动为您打开制冷空调，风速为2档',
        duration: 3000,
        bottom: 400
      })
    }
  }

  async refreshData() {
    try {
      console.info('[Temperature Page] Starting data refresh...')
      
      // 从缓存获取最新数据
      const cacheData = await this.dataCache.getLatestData()
      if (cacheData) {
        this.currentTemp = cacheData.temperature_indoor
        
        // 更新图表URL时添加时间戳
        this.chartImageUrl = `${BASE_URL}/chart/temperature?t=${Date.now()}`
        console.info('[Temperature Page] Data refreshed from cache successfully')
      }

      // 同时更新场景状态
      console.info('[Temperature Page] Updating scene states after data refresh')
      await this.updateSceneStates()
    } catch (error) {
      console.error('[Temperature Page] Error in refreshData:', error)
    }
  }

  // 更新场景状态
  private async updateSceneStates() {
    try {
      console.info('[Temperature Page] Starting to update scene states...')
      const success = await this.sceneManager.fetchAllScenes()
      console.info('[Temperature Page] fetchAllScenes result:', success)
      
      if (success) {
        const acEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_TEMP_AC)
        const curtainEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_TEMP_CURTAIN)
        
        console.info('[Temperature Page] Previous states - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
        console.info('[Temperature Page] New states - AC:', acEnabled, 'Curtain:', curtainEnabled)
        
        // 只有当状态发生变化时才更新UI
        if (this.isAirConditionControlEnabled !== acEnabled) {
          this.isAirConditionControlEnabled = acEnabled
        }
        if (this.isCurtainControlEnabled !== curtainEnabled) {
          this.isCurtainControlEnabled = curtainEnabled
        }
        
        console.info('[Temperature Page] Scene states updated - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
      } else {
        console.error('[Temperature Page] Failed to fetch scene states')
      }
    } catch (error) {
      console.error('[Temperature Page] Error updating scene states:', error)
    }
  }

  build() {
    Column() {
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

          Column() {
            Text('温度历史数据（近5小时）')
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
                  Text('温控空调')
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
                    // 启用温控空调场景
                    const success = await this.sceneManager.enableScene(AUTO_MODE_TEMP_AC)
                    if (success) {
                      this.isAirConditionControlEnabled = true
                      console.info('[Temperature Page] Air condition control enabled successfully')
                      // 启动温度检查定时器
                      this.startTemperatureCheck()
                    }
                  } else {
                    // 禁用温控空调场景
                    const success = await this.sceneManager.disableScene(AUTO_MODE_TEMP_AC)
                    if (success) {
                      this.isAirConditionControlEnabled = false
                      console.info('[Temperature Page] Air condition control disabled successfully')
                      // 清除温度检查定时器
                      if (this.temperatureCheckTimer !== -1) {
                        clearInterval(this.temperatureCheckTimer)
                        this.temperatureCheckTimer = -1
                      }
                    }
                  }
                } catch (error) {
                  console.error('[Temperature Page] Failed to toggle air condition control:', error)
                }
              })
              
              Button() {
                Row() {
                  Image($r('app.media.curtain'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isCurtainControlEnabled ? Color.White : '#666666')
                  Text('温控窗帘')
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
                    // 启用温控窗帘场景
                    const success = await this.sceneManager.enableScene(AUTO_MODE_TEMP_CURTAIN)
                    if (success) {
                      this.isCurtainControlEnabled = true
                      console.info('[Temperature Page] Curtain control enabled successfully')
                    }
                  } else {
                    // 禁用温控窗帘场景
                    const success = await this.sceneManager.disableScene(AUTO_MODE_TEMP_CURTAIN)
                    if (success) {
                      this.isCurtainControlEnabled = false
                      console.info('[Temperature Page] Curtain control disabled successfully')
                    }
                  }
                } catch (error) {
                  console.error('[Temperature Page] Failed to toggle curtain control:', error)
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