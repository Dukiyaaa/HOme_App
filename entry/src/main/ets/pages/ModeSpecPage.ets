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
      HeadBackAndTitleComp({item:{
        title:this.ModeData.modeName,
        image:$r('app.media.close'),
        routeTo:'pages/Index'
      }})
      List({space:10}){
        ForEach(this.ModeData.sceneListData.sceneDataList,(item:SceneClass)=>{
          SceneListItem({
            sceneData:item
          })
        })
      }
      .padding({left:15,right:15})
      .width('100%')
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}