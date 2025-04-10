@Component
export struct ElectricityDataComp {
  voltage: number = 220
  current: number = 5.5

  build() {
    Row() {
      Image($r('app.media.elec'))
        .width(24)
        .height(24)
        .margin({ right: 8 })
      Column() {
        Text(`电压：${this.voltage}V`)
          .fontSize(16)
          .fontColor('#333')
        Text(`电流：${this.current}A`)
          .fontSize(16)
          .fontColor('#333')
      }
    }
    .backgroundColor('#fff')
    .borderRadius(8)
    .padding(12)
    .margin({ top: 8 })
    .width('100%')
  }
} 