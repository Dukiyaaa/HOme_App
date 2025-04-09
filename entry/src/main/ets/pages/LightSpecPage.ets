import {router} from '@kit.ArkUI'
import {CloseAndOpenButton} from '../component/CloseAndOpenButton'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {DataShow} from '../component/ElecAppDataShow'
import {lightClass, elecAppTypeConst} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {CloseAndYesButton} from '../models/CloseAndYesButton'
import {SliderAdjust} from '../component/SliderAdjust'

@Entry
@Component
struct LightSpecPage {
  @State message: string = 'Hello World';
  @State currentValue:number=0

  //灯光参数
  @State lightData:lightClass=new lightClass(0,'客厅灯',new roomClass(0,'客厅'),elecAppTypeConst.light)
  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.lightData=params as lightClass
    }
  }

  min:number=0
  max:number=100
  step:number=10
  build() {
    Scroll(){
      Column(){
        HeadBackAndTitleComp({item: new CloseAndYesButton(this.lightData.title,$r('app.media.close'),'pages/LightPage')})
        Blank()
          .height(30)
        List({space:20}){
          ListItem(){
            DataShow({
              itemList:this.lightData.elecData
            })
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .width('100%')
          .height(100)
          .padding({left:10,right:10})
          .backgroundColor(Color.White)
          .borderRadius(10)
          ListItem(){
            SliderAdjust({
              title:'色温调节',
              value:this.lightData.colTemperatue
            })
          }
          .margin({top: 30})
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .width('100%')
          .height(110)
          .padding({left:10,right:10})
          .backgroundColor(Color.White)
          .borderRadius(10)
          ListItem(){
            SliderAdjust({
              title:'亮度调节',
              value:this.lightData.brightness
            })
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .width('100%')
          .height(100)
          .padding({left:10,right:10})
          .margin({top: 30})
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')
        CloseAndOpenButton({
          stateFromParent: this.lightData.state,
          updateState: {
            run: (newState: number) => {
              this.lightData.state = newState
            }
          },
          deviceType: 'light'
        })

          .position({top:'75%',left:'36%'})
      }.height('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}