import {CurtainBackItemList} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {ElecAppButtonSpecItem,CurtainnSpecItemList} from '../models/ElecAppButtonSpec'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {curtainClass,typeElecAppState} from '../models/EquipData'

@Component
struct CurtainButton{
  @ObjectLink item:curtainClass
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
        url:'pages/CurtainSpecPage3',
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
struct CurtainPage {
  @State message: string = 'Hello World';
  @State curtainListData:typeElecAppState=new typeElecAppState([],-1)

  aboutToAppear(){
    const params=router.getParams()
    if (params) {
      this.curtainListData=params as typeElecAppState
    }
  }
  build() {
    Scroll(){
      Column({space:15}){
        HeadBackAndTitleComp({item:CurtainBackItemList[0]})
        Blank().height(30)
        ForEach(this.curtainListData.elecAppList,(item:curtainClass)=>{
          CurtainButton({item:item})
        })
      }.height('100%').width('100%')
    }.height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}