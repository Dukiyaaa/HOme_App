import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import web_webview from '@ohos.web.webview'
import http from '@ohos.net.http'

// 使用class代替interface来定义类型
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

      // 视频预览区域容器
      Column() {
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

      // 空白间距
      Blank()
        .layoutWeight(1)
        .backgroundColor('#F5F5F5')

      // 底部按钮区域
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

  // 执行人脸识别
  private async performFaceRecognition(): Promise<void> {
    try {
      this.debugText = '[前端📸] 开始拍照...'
      const timestamp = Date.now()
      const request = http.createHttp()

      console.log('[前端📸] 请求高清图像：', `http://${this.cameraIP}/capture_hd?time=${timestamp}`)

      const captureResponse = await request.request(
        `http://${this.cameraIP}/capture_hd?time=${timestamp}`,
        {
          method: http.RequestMethod.GET,
          expectDataType: http.HttpDataType.ARRAY_BUFFER
        }
      )

      console.log('[前端📥] 拍照响应状态码：', captureResponse.responseCode)

      if (captureResponse.responseCode === 200) {
        this.debugText = '[前端📤] 上传图像中...'
        console.log('[前端📤] 开始上传到后端接口：', this.serverURL)

        const uploadResponse = await request.request(
          this.serverURL,
          {
            method: http.RequestMethod.POST,
            header: {
              'Content-Type': 'multipart/form-data'
            },
            extraData: captureResponse.result as ArrayBuffer
          }
        )

        console.log('[前端📬] 识别响应状态码：', uploadResponse.responseCode)

        if (uploadResponse.responseCode === 200) {
          const result = JSON.parse(uploadResponse.result as string) as RecognitionResult
          console.log('[前端🧠] 后端返回结果：', result)

          if (result.faces_detected > 0) {
            const names = result.results.map(item => item.name).join(', ')

            if (names.includes('Unknown')) {
              this.debugText = '[前端⚠️] 未识别身份'
              this.recognitionResult = '未知人脸'
            } else {
              this.debugText = `[前端✅] 识别到：${names}`
              this.recognitionResult = `识别到：${names}`
            }
          } else {
            this.debugText = '[前端❌] 未识别到人脸'
            this.recognitionResult = '未识别到人脸'
          }
        } else {
          this.debugText = '[前端⚠️] 后端识别失败'
          this.recognitionResult = '识别失败'
        }
      } else {
        this.debugText = '[前端⚠️] 摄像头拍照失败'
        this.recognitionResult = '拍照失败'
      }
    } catch (error) {
      console.error('[前端❌] 异常：', error)
      this.debugText = '[前端❌] 识别异常'
      this.recognitionResult = '识别异常'
    }
  }
} 