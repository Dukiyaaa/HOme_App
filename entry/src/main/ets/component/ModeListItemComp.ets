import {ModeClass,SceneClass} from '../models/SceneData'
import {SceneButton} from '../component/RoomDataComp'
import {router} from '@kit.ArkUI'

@Component
export struct ModeListItemComp{
  @ObjectLink modeData:ModeClass
  build() {
    ListItem(){
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Text(this.modeData.modeName)
          Blank()
          Image($r('app.media.inter')).width(20)
        }.height('22%').width('95%')

        Row({ space: 10 }) {
          ForEach(this.modeData.sceneListData.sceneDataList,(item:SceneClass)=>{
            SceneButton({
              sceneData:item
            })
          })
        }.width('100%')
      }
      .padding(10)
      .backgroundColor(Color.White)
      .width('100%')
      .height(120)
      .borderRadius(10)
      .onClick(()=>{
        router.pushUrl({
          url:'pages/ModeSpecPage',
          params: this.modeData
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
    }
    .width('100%')

  }
}
