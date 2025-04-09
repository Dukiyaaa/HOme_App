import {equipControl, postEquipControl, door_stateParas, open_percentParas, airConditioner_stateParas, color_RGBParas} from '../http/basicEquipAdjust'

interface UpdateStateHandler {
  run: (newState: number) => void
}

@Component
export struct CloseAndOpenButton {
  @Prop stateFromParent: number
  @Prop updateState: UpdateStateHandler
  @Prop deviceType: string

  build() {
    Button() {
      Image($r(this.stateFromParent == 0 ? 'app.media.close2_gray' : 'app.media.close2_blue'))
        .width(100)
        .height(100)
        .shadow(ShadowStyle.OUTER_FLOATING_SM)
        .borderRadius('50%')
    }
    .onClick(async () => {
      const newState = this.stateFromParent == 0 ? 1 : 0
      let body: equipControl

      switch (this.deviceType) {
        case 'airCondition':
          if (newState === 0) {
            // 关闭空调时，发送风速0
            body = new equipControl("attribute", "airConditioner_setState", new airConditioner_stateParas("cold", 0))
          } else {
            // 打开空调时，发送默认设置
            body = new equipControl("attribute", "airConditioner_setState", new airConditioner_stateParas("cold", 1))
          }
          break
        case 'curtain':
          body = new equipControl("attribute", "curtain_openPercent", new open_percentParas(newState == 1 ? 150 : 0))
          break
        case 'light':
          // 使用 color_RGBParas 构造开关命令
          // 关闭时亮度为0，打开时亮度为100%
          body = new equipControl(
            "attribute",
            "led_setLightness_color",
            new color_RGBParas(newState === 1 ? 100 : 0)
          )
          break
        case 'lock':
          body = new equipControl("attribute", "door_setState", new door_stateParas(newState))
          break
        default:
          console.error("Unsupported device type: " + this.deviceType)
          return
      }

      this.updateState.run(newState)  // 更新状态
      await postEquipControl(body)    // 发送控制指令
    })
  }
}

