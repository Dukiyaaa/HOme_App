import { equipControl } from '../http/basicEquipAdjust'

@Component
export struct SliderAdjust {
  @Prop title: string = ''
  @Link value: number
  @Prop body: equipControl
  @Prop max: number = 100
  @Prop min: number = 0
  @Prop step: number = 1
  
  @State private sliderValue: number = 0

  // 添加回调函数属性
  onValueChange?: (value: number) => void
  
  private handleValueChange(value: number) {
    this.sliderValue = value
    this.value = value
    // 调用回调函数
    if (this.onValueChange) {
      this.onValueChange(value)
    }
  }

  aboutToAppear(): void {
    this.sliderValue = this.value
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(16)
        .margin({ bottom: 10 })
      Slider({
        value: this.sliderValue,
        min: this.min,
        max: this.max,
        step: this.step
      })
      .onChange((value: number): void => {
        this.handleValueChange(value)
      })
      .showTips(true)
      .stepColor(Color.Pink)
      .width('90%')
      .padding({ top: 15, bottom: 10 })
      .borderRadius(25)
    }
    .padding({ top: 10, bottom: 10 })
    .alignItems(HorizontalAlign.Start)
  }
}
