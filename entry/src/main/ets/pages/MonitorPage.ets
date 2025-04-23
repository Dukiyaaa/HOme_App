import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import web_webview from '@ohos.web.webview'

@Entry
@Component
struct MonitorPage {
  @State debugText: string = ''
  @State isLoading: boolean = true
  @State showAlert: boolean = false         // 老人摔倒弹窗控制
  @State showGasAlert: boolean = false      // 可燃气体弹窗控制

  private context = getContext(this) as common.UIAbilityContext
  private cameraIP: string = '192.168.10.229'
  private controller: web_webview.WebviewController = new web_webview.WebviewController()

  // 页面进入后触发气体报警
  aboutToAppear(): void {
    setTimeout(() => {
      this.showGasLeakAlert()
    }, 5000)
  }

  // 摔倒弹窗
  showFallAlert(): void {
    this.showAlert = true
    setTimeout(() => {
      this.showAlert = false
    }, 5000)
  }

  // 气体报警弹窗
  showGasLeakAlert(): void {
    this.showGasAlert = true
    setTimeout(() => {
      this.showGasAlert = false
    }, 5000)
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
        Text('监控画面')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')

      // 视频 + 弹窗
      Stack() {
        // 视频流加载
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

        // 加载指示器
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

        // 状态提示
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

        // 🚨 老人摔倒弹窗
        if (this.showAlert) {
          Column() {
            Text('⚠️ 检测到老人摔倒')
              .fontSize(26)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ bottom: 16 })

            Text('正在通知监护人...')
              .fontSize(20)
              .fontColor('#FFFFFF')
          }
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(200, 0, 0, 0.85)')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }

        // 🧯 可燃气体报警弹窗
        if (this.showGasAlert) {
          Column() {
            Text('⚠️ 检测到非法闯入')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ bottom: 16 })

            Text('已进行人脸抓拍，请确认房屋是否安全')
              .fontSize(18)
              .fontColor('#FFFFFF')
              .textAlign(TextAlign.Center)
              .padding({ left: 20, right: 20 })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(255, 69, 0, 0.85)')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#000000')
    }
    .width('100%')
    .height('100%')
  }
}
