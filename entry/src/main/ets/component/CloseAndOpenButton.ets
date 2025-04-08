import { SceneSetItemList,CloseAndYesButtonItem, AddSpecEquipButton} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {airConditioner_stateParas,open_percentParas,close_percentParas,color_RGBParas,door_stateParas,equipControl,postEquipControl} from '../http/basicEquipAdjust'
@Component
export struct CloseAndOpenButton{
  @State state:number=0
  @State body:equipControl=new equipControl("attribute","airConditioner_setState",new airConditioner_stateParas(0))
  build() {
    Button(){
      Image($r(this.state==0?'app.media.close2_gray':'app.media.close2_blue'))
        .width(100)
        .height(100)
        .shadow(ShadowStyle.OUTER_FLOATING_SM)
        .margin(0)
        .borderRadius('50%')
    }
    .onClick(()=>{
      this.state=this.state==0?1:0
      postEquipControl(this.body)
    })
    .backgroundColor(Color.Transparent)

    .width(100)
    .height(100)
    .padding(0)
    .margin({top:70})
  }

}


