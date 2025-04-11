import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import web_webview from '@ohos.web.webview'

@Entry
@Component
struct MonitorPage {
  @State debugText: string = ''
  @State isLoading: boolean = true
  private context = getContext(this) as common.UIAbilityContext
  private cameraIP: string = '172.20.10.3'
  private controller: web_webview.WebviewController = new web_webview.WebviewController()

  // 保存图片到相册
  async saveImage(): Promise<void> {
    try {
      const fileName = `monitor_${new Date().getTime()}.jpg`
      // TODO: 实际项目中，这里需要将视频帧数据写入文件
      this.debugText = '照片已保存：' + fileName
    } catch {
      this.debugText = '保存失败'
    }
  }

  // 拍照功能
  takePhoto(): void {
    try {
      this.debugText = '正在保存...'
      // TODO: 实际项目中，这里需要从视频流中截取当前帧
      this.saveImage()
    } catch {
      this.debugText = '拍照失败'
    }
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

      // 主要内容区域
      Stack() {
        // 视频预览区域
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

        // 状态文本
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

        // 底部拍照按钮
        Column() {
          Blank()
          Image($r('app.media.take_photo'))
            .width(80)
            .height(80)
            .margin({ bottom: 50 })
            .onClick(() => {
              this.debugText = '拍照功能开发中...'
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#000000')
    }
    .width('100%')
    .height('100%')
  }
} 