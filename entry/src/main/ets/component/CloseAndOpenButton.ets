import {equipControl, postEquipControl, door_stateParas, open_percentParas, airConditioner_stateParas} from '../http/basicEquipAdjust'

interface UpdateStateHandler {
  run: (newState: number) => void
}

@Component
export struct CloseAndOpenButton {
  @Prop stateFromParent: number
  @Prop updateState: UpdateStateHandler  // ✅ 使用 interface 类型
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
        case 'lock':
          body = new equipControl("attribute", "door_setState", new door_stateParas(newState))
          break
        case 'curtain':
          body = new equipControl("attribute", "curtain_openPercent", new open_percentParas(newState == 1 ? 150 : 0))
          break
        case 'light':
          body = new equipControl("attribute", "light_setState", new door_stateParas(newState))
          break
        case 'airCondition':
          body = new equipControl("attribute", "airConditioner_setState", new airConditioner_stateParas(newState))
          break
        default:
          console.error("Unsupported device type: " + this.deviceType)
          return
      }

      this.updateState.run(newState)  // ✅ 调用包裹的函数
      await postEquipControl(body)

    })
  }
}

