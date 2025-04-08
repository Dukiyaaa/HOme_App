import {CloseAndYesButtonComp,HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {CloseAndYesButtonItem} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'

//列表分割线样式定义
class DividerTmp {
  strokeWidth: Length = 1
  startMargin: Length = 60
  endMargin: Length = 10
  color: ResourceColor = '#ffe9f0f0'

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth
    this.startMargin = startMargin
    this.endMargin = endMargin
    this.color = color
  }
}

@Entry
@Component
struct AITemperatureAndHumidityPage {
  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')

  @State closeAndYesButtonData:CloseAndYesButtonItem[]=[]
  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.closeAndYesButtonData=params as CloseAndYesButtonItem[]
    }
  }

  build() {
    Column(){
      HeadBackAndTitleComp({
        item:this.closeAndYesButtonData[0]
      })
      Blank().height(30)
      List(){
        ListItem(){
          Row(){
            Image($r('app.media.temperature_set'))
              .width(40)
            Text('智能温度监测')
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: true })
              .onChange((isOn:boolean)=>{

              })
              .height(30)
              .width(50)
          }
          .width('100%')
          .height(60)
        }

        ListItem(){
          Row(){
            Image($r('app.media.humidity2'))
              .width(40)
            Text('智能湿度监测')
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: true })
              .onChange((isOn:boolean)=>{

              })
              .height(30)
              .width(50)
          }
          .width('100%')
          .height(60)
        }
      }
      .width('95%')
      .borderRadius(15)
      .divider(this.egDivider)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    }
  }
}