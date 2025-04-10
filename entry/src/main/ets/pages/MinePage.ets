import { it } from '@ohos/hypium';
import {ThirdComp} from '../component/thirdcom'
import {settingButtonItem,settingButtonItemList} from '../models/SettingButtonItem'
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
export struct MinePage {
  @State message: string = 'Hello World';
  //头像
  @State touxiang:Resource=$r('app.media.avator')
  //用户名
  @State username:string='海阔天空'
  //家庭成员
  @State homeNum:number=1
  //设备数量
  @State equipNum:number=5
  @State homeName:string='相亲相爱一家人'
  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')

  build() {
    Column({space:20}){
      //顶部用户信息
      Column(){
        Row({space:10}){
          Button(){
            Image(this.touxiang).width(35).height(35)
          }
          .width(42).height(42).backgroundColor(Color.Transparent)
          Text(this.username)
          Blank()
        }
        .height('10%')
        .width('100%')
        Row(){
          Button(this.homeNum.toString()+'个家庭成员',{type:ButtonType.Normal})
            .fontSize(10)
            .height(25)
            .padding(7)
            .backgroundColor('#5686E1')
            .borderRadius({topLeft:'50%',bottomLeft:'50%',topRight:0,bottomRight:0})
          Text('|').fontSize(15).height(25).backgroundColor('#5686E1')
          Button(this.equipNum.toString()+'个设备',{type:ButtonType.Normal})
            .fontSize(10)
            .height(25)
            .padding(7)
            .backgroundColor('#5686E1')
            .borderRadius({topLeft:0,bottomLeft:0,topRight:'50%',bottomRight:'50%'})
        }
        .margin({left:10})
        .width('100%')
      }.width('100%')
      //家庭成员栏
      Row(){
        Column(){
          Text(this.homeName)
            .fontSize(20)
          Text(this.homeNum+'个成员').fontColor(Color.Gray)
        }
        .alignItems(HorizontalAlign.Start)
        .width('50%')
        Blank()
        Image($r('app.media.add_member'))
          .width(40)
      }
      .padding(15)
      .borderRadius(10)
      .backgroundColor(Color.White)
      .height('15%')
      .width('100%')
      //设置list
      List(){
        ForEach(settingButtonItemList,(item:settingButtonItem)=>{
          ListItem(){
            Button({type:ButtonType.Normal}){
              Row(){
                Image(item.icon).width(35).margin({right:10})
                Text(item.title)
                Blank()
                Image(item.inner).width(40)
              }.width('100%')
            }
            .backgroundColor(Color.Transparent)
            .padding(10)
            .height(60)
            .width('100%')
            .backgroundColor(Color.White)
            .onClick(()=>{
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
          }
        })
      }
      .divider(this.egDivider)
      .borderRadius(15)
      // ThirdComp()
    }
    .width('95%')
    .height('100%')
  }

  @Builder
  settingButton(){

  }
}