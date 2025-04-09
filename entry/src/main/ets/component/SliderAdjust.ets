import { equipControl, open_percentParas, postEquipControl } from '../http/basicEquipAdjust'

@Component
export struct SliderAdjust {
  @Prop title: string = ''
  @Link value: number  // ✅ 双向绑定滑块值
  @Prop body: equipControl = new equipControl("attribute", "curtain_openPercent", new open_percentParas(0))
  @Prop max: number = 100
  @Prop min: number = 0
  @Prop step: number = 1

  build() {
    Column() {
      Text(this.title).fontSize(20)
      Slider({
        value: this.value,  // 显示当前值
        min: this.min,
        max: this.max,
        step: this.step
      })
        .onChange((newValue: number, mode: SliderChangeMode) => {
          this.value = newValue  // ✅ 强制更新双向绑定
          if (mode === 0) {
            const angle = Math.round(newValue * 1.5)

            const newBody = new equipControl(
              this.body.service_id,
              this.body.command_name,
              new open_percentParas(angle)
            )

            postEquipControl(newBody)
          }
        })
        .showTips(true)
        .stepColor(Color.Pink)
        .width('90%')  // ✅ 避免 fit-content 显示异常
        .padding({ top: 15, bottom: 10 })
        .borderRadius(25)
    }
    .padding({ top: 10, bottom: 10 })
    .alignItems(HorizontalAlign.Start)
  }
}
