import {router} from '@kit.ArkUI'
import {CloseAndOpenButton} from '../component/CloseAndOpenButton'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {lightClass, elecAppTypeConst} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {CloseAndYesButton} from '../models/CloseAndYesButton'
import {SliderAdjust} from '../component/SliderAdjust'
import {equipControl, color_RGBParas, postEquipControl} from '../http/basicEquipAdjust'
import AutomationSceneManager, { AUTO_MODE_MOTION_LIGHT, AUTO_MODE_LIGHT_LIGHTNESS } from '../models/AutomationSceneManager'

@Entry
@Component
struct LightSpecPage {
  @State message: string = 'Hello World'
  @State currentValue: number = 0
  @State sliderBrightness: number = 0
  @State sliderColorTemp: number = 0
  @State brightnessBody: equipControl = new equipControl("attribute", "led_setLightness_color", new color_RGBParas(0))
  @State colorTempBody: equipControl = new equipControl("attribute", "led_setLightness_color", new color_RGBParas(0))
  @State isLightIntensityEnabled: boolean = false
  @State isMotionSensorEnabled: boolean = false

  //灯光参数
  @State lightData: lightClass = new lightClass(0, '', new roomClass(0, ''), elecAppTypeConst.light)
  @State currentBrightness: number = 100
  @State currentColorTemp: number = 50

  private sceneManager: AutomationSceneManager = AutomationSceneManager.getInstance()

  aboutToAppear(): void {
    console.info('[Light Page] Page aboutToAppear starting...')
    
    const params = router.getParams()
    if (params) {
      this.lightData = params as lightClass
      this.currentBrightness = 100  // 初始亮度
      this.currentColorTemp = 50    // 初始色温
      
      // 获取并更新场景状态
      this.updateSceneStates().catch(() => {
        console.error('[Light Page] Error updating initial scene states')
      })
    }
  }

  // 更新场景状态
  private async updateSceneStates(): Promise<void> {
    try {
      const success = await this.sceneManager.fetchAllScenes();
      if (success) {
        this.isLightIntensityEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_LIGHT_LIGHTNESS);
        this.isMotionSensorEnabled = this.sceneManager.isSceneEnabled(AUTO_MODE_MOTION_LIGHT);
        console.info('[Light Page] Scene states updated:', {
          lightIntensity: this.isLightIntensityEnabled,
          motionSensor: this.isMotionSensorEnabled
        });
      }
    } catch (error) {
      console.error('[Light Page] Error updating scene states:', error);
    }
  }

  // 处理亮度变化
  private handleBrightnessChange(value: number): void {
    this.sliderBrightness = value
    this.updateControlBodies()
  }

  // 处理色温变化
  private handleColorTempChange(value: number): void {
    this.sliderColorTemp = value
    this.updateControlBodies()
  }

  min: number = 0
  max: number = 100
  step: number = 10

  // 更新控制命令
  private updateControlBodies(): void {
    // 避免不必要的更新
    if (this.sliderBrightness === undefined || this.sliderColorTemp === undefined) {
      return
    }

    const rgbValues = color_RGBParas.colorTempToRGB(this.sliderColorTemp)
    
    // 添加色温转换日志
    console.info(`[Light Control] Color temperature conversion:
      Color temp: ${this.sliderColorTemp}
      Converted RGB: R=${rgbValues.r}, G=${rgbValues.g}, B=${rgbValues.b}
    `);
    
    // 更新亮度和色温控制命令
    const controlParams = new color_RGBParas(
      this.sliderBrightness,
      rgbValues.r,
      rgbValues.g,
      rgbValues.b
    )
    
    this.brightnessBody = new equipControl(
      "attribute",
      "led_setLightness_color",
      controlParams
    )

    this.colorTempBody = this.brightnessBody

    // 更新设备状态
    this.lightData.brightness = this.sliderBrightness
    this.lightData.colTemperatue = this.sliderColorTemp

    // 发送控制命令
    this.sendControlCommand(this.brightnessBody)
  }

  // 发送控制命令
  private async sendControlCommand(body: equipControl): Promise<void> {
    try {
      await postEquipControl(body)
    } catch (error) {
      console.error('Error sending control command:', error)
    }
  }

  // 更新灯光状态的方法
  private updateLightState(brightness: number, colorTemp: number) {
    // 只有在开启状态下才发送命令
    if (this.lightData.state === 1) {
      const rgbColor = color_RGBParas.colorTempToRGB(colorTemp)
      const body = new equipControl(
        "attribute",
        "led_setLightness_color",
        new color_RGBParas(brightness, rgbColor.r, rgbColor.g, rgbColor.b)
      )
      postEquipControl(body)
    }
  }

  build() {
    Column() {
      HeadBackAndTitleComp({
        item: new CloseAndYesButton(this.lightData.title, $r('app.media.close'), 'pages/LightPage')
      })
      Blank().height(30)
      List({ space: 20 }) {
        ListItem() {
          SliderAdjust({
            title: '亮度调节',
            value: this.currentBrightness,
            onValueChange: (value: number) => {
              this.currentBrightness = value
              this.updateLightState(value, this.currentColorTemp)
            }
          })
        }
        .shadow(ShadowStyle.OUTER_DEFAULT_SM)
        .width('100%')
        .height(100)
        .padding({ left: 10, right: 10 })
        .backgroundColor(Color.White)
        .borderRadius(10)

        ListItem() {
          SliderAdjust({
            title: '色温调节',
            value: this.currentColorTemp,
            onValueChange: (value: number) => {
              this.currentColorTemp = value
              this.updateLightState(this.currentBrightness, value)
            }
          })
        }
        .shadow(ShadowStyle.OUTER_DEFAULT_SM)
        .width('100%')
        .height(100)
        .padding({ left: 10, right: 10 })
        .backgroundColor(Color.White)
        .borderRadius(10)

        // 智能场景控制
        ListItem() {
          Column() {
            Text('智能场景一键开启')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 8, bottom: 16 })
            
            Row() {
              Button() {
                Row() {
                  Image($r('app.media.light_blue'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isLightIntensityEnabled ? Color.White : '#666666')
                  Text('光强调节')
                    .fontSize(14)
                    .fontColor(this.isLightIntensityEnabled ? Color.White : '#666666')
                }
              }
              .width('45%')
              .height(40)
              .backgroundColor(this.isLightIntensityEnabled ? '#5686E1' : '#E8E8E8')
              .borderRadius(20)
              .onClick(async () => {
                try {
                  if (!this.isLightIntensityEnabled) {
                    // 启用光强调节场景
                    const success = await this.sceneManager.enableScene(AUTO_MODE_LIGHT_LIGHTNESS)
                    if (success) {
                      this.isLightIntensityEnabled = true
                      console.info('[Light Page] Light intensity control enabled successfully')
                    }
                  } else {
                    // 禁用光强调节场景
                    const success = await this.sceneManager.disableScene(AUTO_MODE_LIGHT_LIGHTNESS)
                    if (success) {
                      this.isLightIntensityEnabled = false
                      console.info('[Light Page] Light intensity control disabled successfully')
                    }
                  }
                } catch (error) {
                  console.error('[Light Page] Failed to toggle light intensity control:', error)
                }
              })
              
              Button() {
                Row() {
                  Image($r('app.media.person'))
                    .width(24)
                    .height(24)
                    .margin({ right: 8 })
                    .fillColor(this.isMotionSensorEnabled ? Color.White : '#666666')
                  Text('人体感应')
                    .fontSize(14)
                    .fontColor(this.isMotionSensorEnabled ? Color.White : '#666666')
                }
              }
              .width('45%')
              .height(40)
              .backgroundColor(this.isMotionSensorEnabled ? '#5686E1' : '#E8E8E8')
              .borderRadius(20)
              .onClick(async () => {
                try {
                  if (!this.isMotionSensorEnabled) {
                    // 启用人体感应场景
                    const success = await this.sceneManager.enableScene(AUTO_MODE_MOTION_LIGHT)
                    if (success) {
                      this.isMotionSensorEnabled = true
                      console.info('[Light Page] Motion sensor enabled successfully')
                    }
                  } else {
                    // 禁用人体感应场景
                    const success = await this.sceneManager.disableScene(AUTO_MODE_MOTION_LIGHT)
                    if (success) {
                      this.isMotionSensorEnabled = false
                      console.info('[Light Page] Motion sensor disabled successfully')
                    }
                  }
                } catch (error) {
                  console.error('[Light Page] Failed to toggle motion sensor:', error)
                }
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
        }
        .shadow(ShadowStyle.OUTER_DEFAULT_SM)
        .width('100%')
        .padding({ left: 10, right: 10 })
      }
      .width('100%')
      .height('650')

      CloseAndOpenButton({
        stateFromParent: this.lightData.state,
        updateState: {
          run: (newState: number) => {
            this.lightData.state = newState
            if (newState === 1) {
              // 开灯时，使用当前的亮度和色温值
              this.updateLightState(this.currentBrightness, this.currentColorTemp)
            }
          }
        },
        deviceType: 'light'
      })
      .position({ top: '75%', left: '36%' })
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }

  onPageShow(): void {
    // 页面显示时更新一次
    this.updateControlBodies()
  }
}