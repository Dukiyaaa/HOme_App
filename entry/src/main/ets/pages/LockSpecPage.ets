import {router} from '@kit.ArkUI'
import {CloseAndOpenButton} from '../component/CloseAndOpenButton'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {lockClass, elecAppTypeConst} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {CloseAndYesButton} from '../models/CloseAndYesButton'
import {equipControl,door_stateParas} from '../http/basicEquipAdjust'

@Entry
@Component
struct LockSpecPage {
  @State message: string = 'Hello World';
  @State currentValue:number=0

  //窗帘参数
  @State lockData:lockClass=new lockClass(0,'客厅窗帘',new roomClass(0,'客厅'),elecAppTypeConst.lock)
  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.lockData=params as lockClass
    }
  }

  min:number=0
  max:number=100
  step:number=10
  build() {
    Scroll(){
      Column(){
        HeadBackAndTitleComp({item: new CloseAndYesButton(this.lockData.title,$r('app.media.close'),'pages/LockPage')})
        Blank()
          .height(30)
        List({space:20}){
        }
        .width('100%')
        CloseAndOpenButton({
          stateFromParent: this.lockData.state,
          updateState: {
            run: (newState: number) => {
              this.lockData.state = newState
            }
          },
          deviceType: 'lock'
        })
          .position({top:'75%',left:'36%'})
      }.height('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}