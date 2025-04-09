import {CloseAndYesButtonComp, CloseAndYesButtonCompLock} from '../component/HeadBackAndTitleComp'
import {AddSpecEquipButton,CloseAndYesButtonItem} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import { lockClass } from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {typeElecAppState,elecAppTypeConst} from '../models/EquipData'
import { ThirdComp } from '../component/thirdcom'

@Entry
@Component
struct SpecEquipAddPage {
  @State closeAndYesButtonData:CloseAndYesButtonItem[]=[]
  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=[]
  @State lockName:string=""

  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.closeAndYesButtonItem=params as CloseAndYesButtonItem[]
    }
  }

  build() {
    Column(){
      Row(){
        Button({type:ButtonType.Circle,stateEffect: true}){
          Image(this.closeAndYesButtonItem[0].image).width(30).height(30)
        }
        .width(55)
        .height(55)
        .backgroundColor(Color.Transparent)
        .onClick(()=>{
          router.replaceUrl({
            url:this.closeAndYesButtonItem[0].routeTo
          },router.RouterMode.Single,(err) => {
            if (err) {
              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Invoke pushUrl succeeded.');
          })
        })
        Text(this.closeAndYesButtonItem[0].title).fontSize(20)
        Blank()
        Button({type:ButtonType.Circle,stateEffect: true}){
          Image(this.closeAndYesButtonItem[1].image).width(30).height(30)
        }
        .width(55)
        .height(55)
        .backgroundColor(Color.Transparent)
        .onClick(()=>{
          AppStorage.setOrCreate('lock',this.lockName)
          router.replaceUrl({
            url:"pages/LockPage",
            params:  new lockClass(0,this.lockName,new roomClass(0,'客厅'),elecAppTypeConst.lock,)
          },router.RouterMode.Single,(err) => {
            if (err) {
              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Invoke pushUrl succeeded.');
          })
        })
      }.width('100%')

      Blank().height(30)
      TextInput({placeholder:'请输入设备名称',text:this.lockName})
        .onChange((value:string)=>{
          console.info(value)
          this.lockName=value
        })
    }
  }
}