import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import web_webview from '@ohos.web.webview'
import http from '@ohos.net.http'

// 定义识别结果结构
class RecognitionResultItem {
  name: string = ''
}
class RecognitionResult {
  faces_detected: number = 0
  results: RecognitionResultItem[] = []
}

@Entry
@Component
struct FaceRecognitionPage {
  @State debugText: string = ''
  @State isLoading: boolean = true
  @State recognitionResult: string = ''
  private context = getContext(this) as common.UIAbilityContext
  private cameraIP: string = '192.168.10.229'
  private serverURL: string = 'http://43.155.36.236:5000/upload_photo'
  private controller: web_webview.WebviewController = new web_webview.WebviewController()
  private isUnloaded: boolean = false

  private failCount: number = 0  // 新增失败计数器

  aboutToAppear(): void {
    this.isUnloaded = false
  }

  aboutToDisappear(): void {
    this.isUnloaded = true
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.back'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })
        Text('人脸识别')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')

      // 视频区域
      Column() {
        Stack() {
          Web({
            src: `http://${this.cameraIP}/stream`,
            controller: this.controller
          })
            .width('100%')
            .height('100%')
            .onPageBegin(() => {
              this.isLoading = false
            })
            .onErrorReceive((event) => {
              this.debugText = '视频加载失败'
              this.isLoading = false
            })

          if (this.isLoading) {
            Column() {
              LoadingProgress()
                .width(64)
                .height(64)
              Text('正在连接摄像头...')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .margin({ top: 8 })
            }
            .width('100%')
            .height('100%')
            .backgroundColor('rgba(0, 0, 0, 0.5)')
            .justifyContent(FlexAlign.Center)
          }

          if (this.debugText) {
            Text(this.debugText)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .backgroundColor('rgba(0, 0, 0, 0.5)')
              .padding(8)
              .borderRadius(4)
              .position({ x: '50%', y: 20 })
              .translate({ x: '-50%' })
          }
        }
        .width('90%')
        .height('100%')
        .backgroundColor('#000000')
        .borderRadius(12)
      }
      .width('100%')
      .height('45%')
      .backgroundColor('#F5F5F5')
      .padding({ top: 20, bottom: 20 })
      .justifyContent(FlexAlign.Center)

      // 识别结果显示
      if (this.recognitionResult) {
        Text(this.recognitionResult)
          .fontSize(16)
          .fontColor('#333333')
          .margin({ top: 20 })
      }

      Blank()
        .layoutWeight(1)
        .backgroundColor('#F5F5F5')

      // 底部识别按钮
      Row() {
        Button('📸 点击识别开门')
          .width('80%')
          .height(50)
          .backgroundColor('#5686E1')
          .fontColor(Color.White)
          .borderRadius(25)
          .onClick(() => {
            this.performFaceRecognition()
          })
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 模拟识别流程
  private async performFaceRecognition(): Promise<void> {
    this.debugText = '📸 拍照中...'

    setTimeout(() => {
      this.failCount += 1

      if (this.failCount <= 3) {
        this.debugText = '❌ 未识别到有效人脸'
        this.recognitionResult = `识别失败 第 ${this.failCount} 次`

        AlertDialog.show({
          title: '识别失败',
          message: `未识别到有效人脸（第 ${this.failCount} 次）`,
          confirm: {
            value: '确定',
            action: () => {}
          }
        })
      } else {
        this.debugText = '🚨 检测到异常识别行为'
        this.recognitionResult = '⚠️ 检测到非法闯入'

        AlertDialog.show({
          title: '报警提示',
          message: '检测到有人试图非法闯入，请检测房屋是否安全 ❗️',
          confirm: {
            value: '我知道了',
            action: () => {}
          }
        })

        this.failCount = 0 // 可选：重置计数器
      }
    }, 3000)
  }
}
