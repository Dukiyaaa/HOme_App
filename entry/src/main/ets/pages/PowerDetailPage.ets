import { router } from '@kit.ArkUI'

@Entry
@Component
struct PowerDetailPage {
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
        Blank()
      }
      .width('100%')
      .height(50)
      .backgroundColor(Color.White)

      // 用电数据展示区域
      Column() {
        // TODO: 添加用电历史数据图表等
        Text('用电历史数据展示')
          .fontSize(16)
          .margin({ top: 20 })
      }
      .width('100%')
      .padding(15)
    }
  }
} 