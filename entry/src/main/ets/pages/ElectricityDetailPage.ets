import { router } from '@kit.ArkUI'
import AutomationSceneManager, { AUTO_MODE_ELECTRICITY_AC, AUTO_MODE_ELECTRICITY_CURTAIN } from '../models/AutomationSceneManager'
import promptAction from '@ohos.promptAction'

const BASE_URL = 'http://43.155.36.236:5000'

@Entry
@Component
struct ElectricityDetailPage {
  @State currentVoltage: number = 0
  @State currentCurrent: number = 0
  @State currentPower: number = 0
  @State chartImageUrl: string = `${BASE_URL}/chart/electricity`
  private refreshTimer: number = -1
  @State isAirConditionControlEnabled: boolean = false
  @State isCurtainControlEnabled: boolean = false
  private sceneManager: AutomationSceneManager = AutomationSceneManager.getInstance()

  aboutToAppear() {
    console.info('[Electricity Page] Page aboutToAppear starting...')
    
    // 先获取场景状态
    this.updateSceneStates().then(() => {
      console.info('[Electricity Page] Initial scene states updated, proceeding with data refresh')
      // 获取场景状态后再加载数据
      this.refreshData()
      
      // 设置定时刷新
      this.refreshTimer = setInterval(() => {
        console.info('[Electricity Page] Refresh timer triggered')
        this.refreshData()
      }, 30 * 1000) // 30秒刷新一次
    }).catch(() => {
      console.error('[Electricity Page] Error in aboutToAppear')
    })
  }

  aboutToDisappear() {
    if (this.refreshTimer !== -1) {
      clearInterval(this.refreshTimer)
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
      }
      .width('100%')
      .height(50)
      .backgroundColor(Color.White)

      // 顶部主要数据显示区域
      Column() {
        Row() {
          Image($r('app.media.electricity'))
            .width(24)
            .height(24)
            .margin({ right: 8 })
          Column() {
            Text('当前数据')
              .fontSize(14)
              .fontColor(Color.Gray)
            Row() {
              Text(this.currentVoltage.toFixed(2))
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5686E1')
              Text(' mV')
                .fontSize(16)
                .fontColor('#5686E1')
            }
            Row() {
              Text(this.currentCurrent.toFixed(2))
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5686E1')
              Text(' mA')
                .fontSize(16)
                .fontColor('#5686E1')
            }
            Row() {
              Text(this.currentPower.toFixed(2))
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
                .fontColor('#5686E1')
              Text(' mW')
                .fontSize(16)
                .fontColor('#5686E1')
            }
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(12)
      }
      .width('94%')
      .margin({ top: 12 })

      // 智能场景控制
      Column() {
        Text('智能场景一键开启')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .margin({ top: 8, bottom: 16 })
        
        Row() {
          Button() {
            Row() {
              Image($r('app.media.electricity'))
                .width(24)
                .height(24)
                .margin({ right: 8 })
                .fillColor(this.isAirConditionControlEnabled ? Color.White : '#666666')
              Text('提前断电')
                .fontSize(14)
                .fontColor(this.isAirConditionControlEnabled ? Color.White : '#666666')
            }
          }
          .width('45%')
          .height(40)
          .backgroundColor(this.isAirConditionControlEnabled ? '#5686E1' : '#E8E8E8')
          .borderRadius(20)
          .onClick(() => {
            // 显示提醒
            promptAction.showToast({
              message: '监测到电流超过12mA，自动关闭大电流家居',
              duration: 3000,
              bottom: 150
            })
            
            // 更新场景状态
            try {
              if (!this.isAirConditionControlEnabled) {
                // 启用提前断电场景
                this.sceneManager.enableScene(AUTO_MODE_ELECTRICITY_AC).then(success => {
                  if (success) {
                    this.isAirConditionControlEnabled = true
                    console.info('[Electricity Page] Early power off enabled successfully')
                  }
                })
              } else {
                // 禁用提前断电场景
                this.sceneManager.disableScene(AUTO_MODE_ELECTRICITY_AC).then(success => {
                  if (success) {
                    this.isAirConditionControlEnabled = false
                    console.info('[Electricity Page] Early power off disabled successfully')
                  }
                })
              }
            } catch (error) {
              console.error('[Electricity Page] Failed to toggle early power off:', error)
            }
          })
        }
      }
    }
  }

  async refreshData() {
    try {
      console.info('[Electricity Page] Starting data refresh...')
      const latestData = await getLatestElectricityData()
      if (latestData.status === 'success' && latestData.latest) {
        this.currentVoltage = latestData.latest.voltage || 0
        this.currentCurrent = latestData.latest.current || 0
        this.currentPower = latestData.latest.power || 0
        
        // 更新图表URL时添加时间戳
        this.chartImageUrl = `${BASE_URL}/chart/electricity?t=${Date.now()}`
        console.info('[Electricity Page] Data refreshed successfully')
      }

      // 同时更新场景状态
      console.info('[Electricity Page] Updating scene states after data refresh')
      await this.updateSceneStates()
    } catch {
      console.error('[Electricity Page] Error in refreshData')
    }
  }

  // 更新场景状态
  private async updateSceneStates() {
    try {
      console.info('[Electricity Page] Starting to update scene states...')
      const success = await this.sceneManager.fetchAllScenes()
      console.info('[Electricity Page] fetchAllScenes result:', success)
      
      if (success) {
        const acEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_ELECTRICITY_AC)
        const curtainEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_ELECTRICITY_CURTAIN)
        
        console.info('[Electricity Page] Previous states - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
        console.info('[Electricity Page] New states - AC:', acEnabled, 'Curtain:', curtainEnabled)
        
        this.isAirConditionControlEnabled = acEnabled
        this.isCurtainControlEnabled = curtainEnabled
        
        console.info('[Electricity Page] Scene states updated - AC:', this.isAirConditionControlEnabled, 'Curtain:', this.isCurtainControlEnabled)
      } else {
        console.error('[Electricity Page] Failed to fetch scene states')
      }
    } catch {
      console.error('[Electricity Page] Error updating scene states')
    }
  }
} 