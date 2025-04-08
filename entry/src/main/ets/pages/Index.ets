//添加设备
//场景列表显示
//添加场景
//添加房间
import {tabBarItem,tabBarItemList} from '../models/TabBarItem'
import {ScenePage} from '../pages/ScenePage'
import {MinePage}from '../pages/MinePage'
import {AIPage}from '../pages/AIPage'
import {EquipmentPage} from '../pages/EquipmentPage'
import {getTokenBody,getToken} from '../http/basicEquipAdjust'
import {router} from '@kit.ArkUI'
import {UserInfoComp} from '../component/UserInfoComp'
import {UserData} from '../models/UserData'
import {TempModeListConst,SceneClass,SceneClassList,ModeClass}from '../models/SceneData'
import {ModeListItemComp} from '../component/ModeListItemComp'

let too:ToolbarItem={
  value:'func',
  icon:$r('app.media.app_icon')
}
let too2:ToolbarItem={
  value:'fun',
  icon:$r('app.media.app_icon')
}
let to3:ToolbarItem={
  value:'fuc',
  icon:$r('app.media.app_icon')
}
let tokenBody:getTokenBody=new getTokenBody()
getToken(tokenBody).then(temp => {
  if (temp) {
    console.log('获取到的 Token:', temp);
    // 将 token 存入全局变量或本地存储
    AppStorage.setOrCreate('token', temp);
  } else {
    console.log('获取 Token 失败');
  }
});

export class sceData{
  name:string="自定义场景1"
}

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
struct Index {
  //首页首先显示的界面
  @State selectIndex: number = 0
  @State tabBarItemList: tabBarItem[] = tabBarItemList
  @State sceneList:sceData[]=[new sceData()]
  @State userData:UserData=new UserData()
  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @State modeList:ModeClass[]=TempModeListConst

  onPageShow(): void {
    const params=router.getParams()
    console.info("page")
    if (params) {
      const temp=params as sceData
      this.sceneList.push(temp)
    }
  }

  build() {
    Navigation(){
      Column() {
        Tabs({
          barPosition: BarPosition.End,
          index: this.selectIndex
        }) {
          TabContent() {
            Scroll() {
              EquipmentPage()
            }.scrollBar(BarState.Off)
          }.tabBar(this.tabBarBuilder(this.tabBarItemList[0], 0))

          TabContent() {
            Column(){
              //用户信息栏
              UserInfoComp({userData:this.userData})
              Tabs(){
                TabContent() {
                  List({space:10}){
                    ForEach(this.modeList,(item:ModeClass)=> {
                      ModeListItemComp({
                        modeData:item
                      })
                    })
                  }.height('100%')
                }
                .height('100%')
                .width('100%')
                .tabBar('推荐')
                TabContent() {
                  Stack(){
                    if (!AppStorage.get('scedate')){
                      Column(){
                        Image($r('app.media.Scene_blue')).width(30)
                        Text('未创建场景，点击"+"添加')
                        Blank().height(100)
                      }.height('100%').justifyContent(FlexAlign.Center)
                    }else{
                      List(){
                        ForEach(AppStorage.get('scedate') as sceData[],(item:sceData)=>{
                          ListItem() {
                            Button({ type: ButtonType.Normal, stateEffect: true }) {
                              Row({ space: 10 }) {
                                Image($r('app.media.Scene_blue'))
                                  .width(40)
                                Text(item.name)
                              }
                            }
                            .align(Alignment.Start)
                            .borderRadius(1)
                            .height(50)
                            .width('100%')
                            .backgroundColor(Color.White)
                          }
                        })
                      }
                      .borderRadius(15)
                      .divider(this.egDivider)
                      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
                    }
                    Flex({
                      direction:FlexDirection.ColumnReverse,
                      alignItems:ItemAlign.End
                    }){
                      Blank().height(80)
                      Button('+')
                        .height(50)
                        .width(50)
                        .borderRadius('50%')
                        .fontSize(30)
                        .margin({right:15})
                        .onClick(()=>{
                          router.pushUrl({
                            url:'pages/SceneSet'
                          },router.RouterMode.Single,(err) => {
                            if (err) {
                              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                              return;
                            }
                            console.info('Invoke pushUrl succeeded.');
                          })
                        })
                    }.width('100%').height('100%')
                  }.height('100%')
                }.tabBar('我的')
              }
              .height('100%')
              .width('100%')
            }
            .height('100%')
          }.tabBar(this.tabBarBuilder(this.tabBarItemList[1], 1))

          TabContent() {
            AIPage()
          }.tabBar(this.tabBarBuilder(this.tabBarItemList[2], 2))

          TabContent() {
            MinePage()
          }.tabBar(this.tabBarBuilder(this.tabBarItemList[3], 3))
        }
        .barHeight(60)
        .onChange((index: number) => {
          this.selectIndex = index
        })
      }
      .height('100%')
      .backgroundImage($r('app.media.bgimg'))
      .backgroundImageSize({width:'100%',height:'100%'})
    }
    .hideToolBar(true)
}

  @Builder
  tabBarBuilder(item:tabBarItem,index:number){
    Column(){
      Image(this.selectIndex==index? item.iconSelected:item.iconNormal)
        .width(this.selectIndex==index? 35:28)
        .aspectRatio(1)
        .margin({top:5,bottom:1})
      Text(item.title).width('100%').height(14).fontSize(10).fontWeight(500)
        .margin({bottom:7})
        .textAlign(TextAlign.Center)
    }
  }
}