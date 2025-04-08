import {router} from '@kit.ArkUI'
import {CloseAndOpenButton} from '../component/CloseAndOpenButton'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {DataShow} from '../component/ElecAppDataShow'
import {curtainClass, elecAppTypeConst} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {CloseAndYesButton} from '../models/CloseAndYesButton'
import {SliderAdjust} from '../component/SliderAdjust'
import {open_percentParas,equipControl} from '../http/basicEquipAdjust'


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
        HeadBackAndTitleComp({item: new CloseAndYesButton(this.curtainData.title,$r('app.media.close'),'pages/CurtainPage')})
        Blank()
          .height(30)
        List({space:20}){
          ListItem(){
            DataShow({
              itemList:this.curtainData.elecData
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
              title:'开度调节',
              value:this.curtainData.state,
              body:new equipControl("attribute","curtain_openPercent",new open_percentParas(this.curtainData.state))
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
          state: this.curtainData.state,
          body: this.curtainData.state==0?
            new equipControl("attribute","curtain_openPercent",new open_percentParas(100))
            :new equipControl("attribute","curtain_openPercent",new open_percentParas(0))
        })
          .position({top:'75%',left:'36%'})
      }.height('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}