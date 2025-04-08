import {LockBackItemList} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {ElecAppButtonSpecItem,LockSpecItemList} from '../models/ElecAppButtonSpec'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {lockClass,typeElecAppState} from '../models/EquipData'

@Component
struct LockButton{
  @ObjectLink item:lockClass
  build() {
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(this.item.state==0?this.item.type.typeIconClose:this.item.type.typeIconOpen)
          .width(40)
        Column(){
          Text(this.item.title).fontSize(20)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .onClick(() => {
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
  @State lockListData:typeElecAppState=new typeElecAppState([],-1)

  aboutToAppear(){
    const params=router.getParams()
    if (params) {
      this.lockListData=params as typeElecAppState
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