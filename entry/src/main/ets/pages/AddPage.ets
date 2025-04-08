import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {AddBackPageButton,CloseAndYesButtonItem} from '../models/CloseAndYesButton'
import {typeClass,elecAppTypeArrayConst} from '../models/EquipData'
import {router} from '@kit.ArkUI'

//列表分割线样式定义
class DividerTmp {
  strokeWidth: Length = 1
  startMargin: Length = 60
  endMargin: Length = 10
  color: ResourceColor = '#ffe9f0f0'

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth
    this.startMargin = startMargin
    this.endMargin = endMargin
    this.color = color
  }
}

@Entry
@Component
struct AddEquip {
  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @Builder
  EquipAddButton(item:typeClass){
    ListItem(){
      Button({type:ButtonType.Normal}){
        Row({space:15}){
          Image(item.typeIconOpen).width(40)
          Text('添加'+item.typeName+'设备')
          Blank()
          Image($r('app.media.inter')).width(30)
        }
        .padding(10)
        .height(60)
        .width('100%')
      }
      .onClick(()=>{
        router.pushUrl({
          url:"pages/SpecEquipAddPage",
          params: [  {
            title:'添加'+item.typeName+'设备',
            image:$r('app.media.close'),
            routeTo:'pages/AddPage'
          },
            {
              title:'',
              image:$r('app.media.yes'),
              routeTo:'pages/Index'
            }]
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
      .backgroundColor(Color.Transparent)

    }
  }

  build() {
    Column(){
      HeadBackAndTitleComp({item:AddBackPageButton[0]})
      List(){
        ForEach(elecAppTypeArrayConst,(item:typeClass)=>{
          this.EquipAddButton(item)
        })
      }
      .width('100%')
      .borderRadius(15)
      .divider(this.egDivider)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    }
    .padding(10)
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}