import { router } from '@kit.ArkUI'
import { CloseAndOpenButton } from '../component/CloseAndOpenButton'
import { HeadBackAndTitleComp } from '../component/HeadBackAndTitleComp'
import { curtainClass, elecAppTypeConst } from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import { CloseAndYesButton } from '../models/CloseAndYesButton'
import { SliderAdjust } from '../component/SliderAdjust'
import { open_percentParas, equipControl } from '../http/basicEquipAdjust'
import { postEquipControl } from '../http/basicEquipAdjust'

@Entry
@Component
struct CurtainSpecPage {
  @State curtainData: curtainClass = new curtainClass(0, '客厅窗帘', new roomClass(0, '客厅'), elecAppTypeConst.curtain)
  @State currentOpenPercent: number = 0  // 当前开度百分比（0-100）

  min: number = 0
  max: number = 100
  step: number = 1

  aboutToAppear(): void {
    const params = router.getParams()
    if (params) {
      this.curtainData = params as curtainClass
      // 将窗帘实际角度（0-150）转换为显示百分比（0-100）
      this.currentOpenPercent = Math.round(this.curtainData.state / 1.5)
    }
  }

  // 更新窗帘开度的方法
  private updateCurtainState(percent: number) {
    // 将显示百分比（0-100）转换为实际控制值（0-150）
    const actualValue = Math.round(percent * 1.5)
    
    // 构造并发送控制命令
    const body = new equipControl(
      "attribute",
      "curtain_openPercent",
      new open_percentParas(actualValue)
    )
    postEquipControl(body)
    
    // 更新状态
    this.curtainData.state = actualValue
    this.currentOpenPercent = percent
  }

  build() {
    Column() {
      HeadBackAndTitleComp({
        item: new CloseAndYesButton(this.curtainData.title, $r('app.media.close'), 'pages/CurtainPage')
      })
      Blank().height(30)

      List({ space: 20 }) {
        ListItem() {
          SliderAdjust({
            title: '开度调节',
            value: this.currentOpenPercent,
            max: this.max,
            min: this.min,
            step: this.step,
            onValueChange: (value: number) => {
              this.updateCurtainState(value)
            }
          })
        }
        .shadow(ShadowStyle.OUTER_DEFAULT_SM)
        .width('100%')
        .height(100)
        .padding({ left: 10, right: 10 })
        .backgroundColor(Color.White)
        .borderRadius(10)
      }
      .width('100%')
      .height('650')

      CloseAndOpenButton({
        stateFromParent: this.curtainData.state > 0 ? 1 : 0,
        updateState: {
          run: (newState: number) => {
            // 开关按钮点击时，设置为完全打开或完全关闭
            const targetPercent = newState === 1 ? 100 : 0
            this.updateCurtainState(targetPercent)
          }
        },
        deviceType: 'curtain'
      })
      .position({ top: '75%', left: '36%' })
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}
