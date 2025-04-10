import { router } from '@kit.ArkUI'

@Entry
@Component
struct HumidityDetailPage {
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

      // 湿度数据展示区域
      Column() {
        // TODO: 添加湿度历史数据图表等
        Text('湿度历史数据展示')
          .fontSize(16)
          .margin({ top: 20 })
      }
      .width('100%')
      .padding(15)
    }
  }
} 