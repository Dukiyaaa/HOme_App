import {SceneBlockItemList,SeceneBlockItem} from '../models/SceneBlock'
import {router} from '@kit.ArkUI'
import {UserInfoComp} from '../component/UserInfoComp'
import {UserData} from '../models/UserData'
import {TempModeListConst,SceneClass,SceneClassList,ModeClass}from '../models/SceneData'
import {ModeListItemComp} from '../component/ModeListItemComp'
import {tabBarItem,tabBarItemList} from '../models/TabBarItem'
import {MinePage}from '../pages/MinePage'
import {AIPage}from '../pages/AIPage'
import {EquipmentPage} from '../pages/EquipmentPage'

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
export struct ScenePage {
  //用户信息数据
  @State userData:UserData=new UserData()
  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  //推荐栏数据
  @State modeList:ModeClass[]=TempModeListConst
  @State sceneList:sceData[]=AppStorage.get('scedate') as sceData[]
  @State selectIndex: number = 1
  @State selectIndex2: number = 1
  @State tabBarItemList: tabBarItem[] = tabBarItemList

  onPageShow(): void {
    const params=router.getParams() as sceData
    if (params) {
      this.sceneList=AppStorage.get('scedate') as sceData[]
      console.info("yess"+this.sceneList.length)
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
              Tabs({
                index: this.selectIndex2
              }){
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
                        Image($r('app.media.startIcon')).width(30)
                        Text('未创建场景，点击"+"添加')
                        Blank().height(100)
                      }.height('100%').justifyContent(FlexAlign.Center)
                    }else{
                      Column(){
                        List(){
                          ForEach(this.sceneList,(item:sceData)=>{
                            ListItem() {
                              Button({ type: ButtonType.Normal, stateEffect: true }) {
                                Row({ space: 10 }) {
                                  Image($r('app.media.Scene_blue'))
                                    .width(40)
                                  Text(item.name)
                                  Blank()
                                  Toggle({ type: ToggleType.Switch, isOn: true })
                                    .height(30)
                                    .width(50)
                                }.width('95%')
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
                      }.height('100%')
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

