import {SceneClass,elecAppAction,airConditionAction,curtainAction,lockAction,SceneClassList} from '../models/SceneData'
import { elecAppTypeConst,
  airConditionModeConst,
  airConditionWindSpeedConst,
  airConditionWindWayConst,
  tempElecAppList,
  typeElecAppState} from '../models/EquipData'
import {UserData} from '../models/UserData'
import {roomClass,roomAndElecListClass,TemperatureAndHumidity} from '../models/RoomData'
import {UserInfoComp} from '../component/UserInfoComp'
import {RoomDataComp,EquipListComp, EquipListComp2} from '../component/RoomDataComp'
import {CloseAndYesButtonComp} from '../component/HeadBackAndTitleComp'
import {EquipItemList,EquipListBackItemList} from '../models/CloseAndYesButton'
import {HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'

@Entry
@Component
struct Page {
  @State message: string = 'Hello World';
  @State roomAndElecAppList:roomAndElecListClass[]= [
    new roomAndElecListClass(new roomClass(0,'客厅'),tempElecAppList)]

  build() {
    Column(){
      HeadBackAndTitleComp({item:EquipListBackItemList[0]})
      ForEach(this.roomAndElecAppList,(item:roomAndElecListClass)=>{
        EquipListComp2({roomAndElecAppData:item})
      })
    }
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}