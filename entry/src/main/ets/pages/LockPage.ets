import {LockBackItemList} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {ElecAppButtonSpecItem,LockSpecItemList} from '../models/ElecAppButtonSpec'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {lockClass,typeElecAppState,elecAppTypeConst} from '../models/EquipData'
import { roomClass } from "../models/RoomData"

@Component
struct LockButton{
  @ObjectLink item:lockClass
  @State item2:lockClass[]=[new lockClass(0,'门锁',new roomClass(0,'客厅'),elecAppTypeConst.lock)]

  build() {
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(this.item?.type?.typeIconClose && this.item?.type?.typeIconOpen ? 
          (this.item.state==0?this.item.type.typeIconClose:this.item.type.typeIconOpen) : 
          $r('app.media.close2_gray'))
          .width(40)
        Column(){
          Text(this.item?.title || '未知门锁').fontSize(20)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .onClick(() => {
      if (this.item) {
        router.pushUrl({
          url:'pages/LockSpecPage',
          params:this.item
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
        console.info(this.item.state.toString())
      }
    })
    .height('100')
    .width('100%')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }
}


@Entry
@Component
struct LockPage {
  @State lockListData:typeElecAppState=new typeElecAppState([new lockClass(0,'门锁',new roomClass(0,'客厅'),elecAppTypeConst.lock)],-1)

  onPageShow(): void {
    const params=router.getParams()
    if (params) {
      this.lockListData=new typeElecAppState([new lockClass(0,'门锁',new roomClass(0,'客厅'),elecAppTypeConst.lock),params as lockClass],-1)
    }
  }
  //窗帘按钮
  @Builder
  CurtainButton(item:ElecAppButtonSpecItem){
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(item.img1)
          .width(40)
        Column(){
          Text(item.title).fontSize(20)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .onClick(() => {
      router.pushUrl({
        url:item.routeTo
      },router.RouterMode.Single,(err) => {
        if (err) {
          console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        console.info('Invoke pushUrl succeeded.');
      })
    })
    .height('100')
    .width('100%')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }

  build() {
    Scroll(){
      Column({space:15}){
        HeadBackAndTitleComp({item:LockBackItemList[0]})
        Blank().height(30)
        ForEach(this.lockListData.elecAppList,(item:lockClass)=>{
          LockButton({item:item})
        })
      }.height('100%').width('100%')
    }.height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}