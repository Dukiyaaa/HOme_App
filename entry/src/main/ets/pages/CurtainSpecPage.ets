import { router } from '@kit.ArkUI'
import { CloseAndOpenButton } from '../component/CloseAndOpenButton'
import { HeadBackAndTitleComp } from '../component/HeadBackAndTitleComp'
import { DataShow } from '../component/ElecAppDataShow'
import { curtainClass, elecAppTypeConst } from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import { CloseAndYesButton } from '../models/CloseAndYesButton'
import { SliderAdjust } from '../component/SliderAdjust'
import { open_percentParas, equipControl } from '../http/basicEquipAdjust'

@Entry
@Component
struct CurtainSpecPage {
  @State curtainData: curtainClass = new curtainClass(0, '客厅窗帘', new roomClass(0, '客厅'), elecAppTypeConst.curtain)
  @State curtainState: number = 0  // ✅ 当前 Slider 显示的“开度百分比”

  min: number = 0
  max: number = 100
  step: number = 1

  aboutToAppear(): void {
    const params = router.getParams()
    if (params) {
      this.curtainData = params as curtainClass

      // ✅ 将窗帘当前角度（0~150）转换为百分比显示（0~100）
      this.curtainState = Math.round(this.curtainData.state / 1.5)
    }
  }

  build() {
    Scroll() {
      Column() {
        HeadBackAndTitleComp({
          item: new CloseAndYesButton(this.curtainData.title, $r('app.media.close'), 'pages/CurtainPage')
        })
        Blank().height(30)

        List({ space: 20 }) {
          ListItem() {
            DataShow({ itemList: this.curtainData.elecData })
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .width('100%')
          .height(100)
          .padding({ left: 10, right: 10 })
          .backgroundColor(Color.White)
          .borderRadius(10)

          ListItem() {
            SliderAdjust({
              title: '开度调节',
              value: this.curtainState,
              body: new equipControl("attribute", "curtain_openPercent", new open_percentParas(0)),
              max: this.max,
              min: this.min,
              step: this.step
            })
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .width('100%')
          .height(100)
          .padding({ left: 10, right: 10 })
          .margin({ top: 30 })
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')

        CloseAndOpenButton({
          stateFromParent: this.curtainState,
          updateState: {
            run: (newState: number) => {
              this.curtainState = newState

              // ✅ 同步回原始数据对象，按角度存储
              this.curtainData.state = Math.round(newState * 1.5)
            }
          },
          deviceType: 'curtain'
        })
          .position({ top: '75%', left: '36%' })
      }
      .height('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
  }
}
