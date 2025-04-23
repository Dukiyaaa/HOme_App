import {SceneButtonList,SceneButtonItem,ModeClass,SceneClass,SceneClassList} from '../models/SceneData'
import {SceneListItem} from '../component/RoomDataComp'
import {router} from '@kit.ArkUI'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {CloseAndYesButtonItem}from '../models/CloseAndYesButton'

@Entry
@Component
struct MinePage {
  @State ModeData:ModeClass=new ModeClass(0,'',new SceneClassList([]))
  @State headBackAndTitleCompData:CloseAndYesButtonItem=new CloseAndYesButtonItem()
  aboutToAppear(): void {
    const params=router.getParams()
    if (params) {
      this.ModeData=params as ModeClass
      console.info(this.ModeData.modeName)
    }
  }

  build() {
    Column(){
      // 头部导航栏
      HeadBackAndTitleComp({item:{
        title:this.ModeData.modeName,
        image:$r('app.media.close'),
        routeTo:'pages/Index'
      }})
      
      // 场景列表
      List({space:8}){
        ForEach(this.ModeData.sceneListData.sceneDataList,(item:SceneClass)=>{
          ListItem(){
            Column(){
              Row(){
                // 场景图标
                Image(item.closeOrOpen == 0 ? item.sceneImageClose : item.sceneImageOpen)
                  .width(45)
                  .height(45)
                  .margin({right:12})
                  .objectFit(ImageFit.Contain)
                
                Column(){
                  // 场景标题
                  Text(item.sceneTitle)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .margin({bottom:6})
                  
                  // 设备图标列表
                  Row({space:8}){
                    if (item.sceneAction.airConditionAction !== undefined){
                      Image(item.sceneAction.airConditionAction[0].type.typeIconOpen)
                        .width(20)
                        .height(20)
                    }
                    if (item.sceneAction.lightAction !== undefined){
                      Image(item.sceneAction.lightAction[0].type.typeIconOpen)
                        .width(20)
                        .height(20)
                    }
                    if (item.sceneAction.curtainAction !== undefined){
                      Image(item.sceneAction.curtainAction[0].type.typeIconOpen)
                        .width(20)
                        .height(20)
                    }
                    if (item.sceneAction.lockAction !== undefined){
                      Image(item.sceneAction.lockAction[0].type.typeIconOpen)
                        .width(20)
                        .height(20)
                    }
                  }
                }
                .alignItems(HorizontalAlign.Start)
                
                Blank()
                
                // 右侧箭头
                Image($r('app.media.inter'))
                  .width(20)
                  .height(20)
                  .margin({right:4})
              }
              .width('100%')
              .padding({left:16, right:16, top:12, bottom:12})
            }
            .backgroundColor(Color.White)
            .borderRadius(12)
            .shadow({
              radius: 6,
              color: '#1A000000',
              offsetX: 0,
              offsetY: 2
            })
          }
          .padding({left:12, right:12})
        })
      }
      .padding({top:12})
      .layoutWeight(1)
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}