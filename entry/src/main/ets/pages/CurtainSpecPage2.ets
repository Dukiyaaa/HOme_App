import {router} from '@kit.ArkUI'
import {CloseAndOpenButton} from '../component/CloseAndOpenButton'
import { CloseAndYesButtonComp2, curClass, HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {curtainClass, elecAppTypeConst} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {SliderAdjust} from '../component/SliderAdjust'
import {open_percentParas,equipControl} from '../http/basicEquipAdjust'
import {AirConditionSpecBackItemList,CloseAndYesButtonItem,CloseAndYesButton,EquipSpecItemList} from '../models/CloseAndYesButton'

@Entry
@Component
struct CurtainSpecPage {
  @State message: string = 'Hello World';
  @State currentValue:number=0

  //窗帘参数
  @State curtainData:curtainClass=new curtainClass(0,'客厅窗帘',new roomClass(0,'客厅'),elecAppTypeConst.curtain)
  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.curtainData=params as curtainClass
    }
  }

  min:number=0
  max:number=100
  step:number=10
  build() {
    Scroll(){
      Column(){
        Row(){
          CloseAndYesButtonComp2({closeAndYesButtonItem:EquipSpecItemList,item:new curClass()})
        }.width('100%')
        Blank()
          .height(30)
        List({space:20}){
          ListItem(){
            SliderAdjust({
              title:'开度调节',
              value:this.curtainData.state,
              body:new equipControl("attribute","curtain_openPercent",new open_percentParas(this.curtainData.state))
            })
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .width('100%')
          .height(100)
          .padding({left:10,right:10})
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
        .width('100%')
        CloseAndOpenButton({
          stateFromParent: this.curtainData.state,
          updateState: {
            run: (newState: number) => {
              this.curtainData.state = newState
            }
          },
          deviceType: 'curtain'
        })
          .position({top:'75%',left:'36%'})
      }.height('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}