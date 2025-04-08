import {AirConditionBackItemList} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import { airConditionClass, typeElecAppState} from '../models/EquipData'

@Component
struct AirConditionButton{
  @ObjectLink item:airConditionClass
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
        url:'pages/AirConditionSpecPage2',
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
struct AirConditionPage {
  @State message: string = 'Hello World';
  @State airConditionListData:typeElecAppState=new typeElecAppState([],-1)

  aboutToAppear(){
    const params=router.getParams()
    if (params) {
      this.airConditionListData=params as typeElecAppState
    }
  }

  build() {
    Scroll(){
      Column({space:15}){
        HeadBackAndTitleComp({item:AirConditionBackItemList[0]})
        Blank().height(30)
        ForEach(this.airConditionListData.elecAppList,(item:airConditionClass)=>{
          AirConditionButton({item:item})
        })
      }.height('100%').width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}