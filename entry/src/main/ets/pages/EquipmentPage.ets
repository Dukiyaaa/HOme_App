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
import {RoomDataComp,} from '../component/RoomDataComp'
import { getLatestTemperatureHumidity } from '../http/temperatureAndHumidity'

@Entry
@Component
struct EquipmentPage {

  //场景数据
  @State tempSceneList:SceneClassList=new SceneClassList([new SceneClass(
    0,
    '回家模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction(
      [new airConditionAction(0, '客厅空调', elecAppTypeConst.airCondition, 0, 0, airConditionModeConst.auto, airConditionWindSpeedConst.low, airConditionWindWayConst.upAndDown, 0)],
      undefined,
      [new curtainAction(0, '客厅空调', elecAppTypeConst.curtain, 0)],
      [new lockAction(0, '客厅空调', elecAppTypeConst.lock, 0)]
    )),new SceneClass(1,
    '离家模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)])),new SceneClass(2,
    '模式',
    $r('app.media.leave_home'),
    $r('app.media.leave_home_close'),
    0,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)])),new SceneClass(3,
    '家模式',
    $r('app.media.back_home'),
    $r('app.media.leave_home_close'),
    1,
    new elecAppAction([new airConditionAction(0,
      '客厅空调',
      elecAppTypeConst.airCondition,
      0,
      0,
      airConditionModeConst.auto,
      airConditionWindSpeedConst.low,
      airConditionWindWayConst.upAndDown,
      0)]))])
  //房间及电器数据
  @State roomAndElecAppList:roomAndElecListClass[]= [
    new roomAndElecListClass(new roomClass(0,'客厅'),tempElecAppList),
    new roomAndElecListClass(new roomClass(1,'卧室'),tempElecAppList)]
  //用户信息数据
  @State userData:UserData=new UserData()
  //温度湿度数据
  @State temperatureAndHumdityData:TemperatureAndHumidity=new TemperatureAndHumidity(new roomClass(0,'客厅'),20,50)

  // 定时器ID
  private timerId: number = -1

  aboutToAppear() {
    // 页面加载时立即获取一次数据
    this.fetchTemperatureHumidity()
    // 设置定时器,每30秒获取一次数据
    this.timerId = setInterval(() => {
      this.fetchTemperatureHumidity()
    }, 30000)
  }

  aboutToDisappear() {
    // 页面销毁时清除定时器
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
    }
  }

  // 获取温湿度数据
  private async fetchTemperatureHumidity() {
    try {
      const response = await getLatestTemperatureHumidity()
      if (response.status === 'success' && response.latest) {
        this.temperatureAndHumdityData.temperature = response.latest.temperature_indoor
        this.temperatureAndHumdityData.humidity = response.latest.humidity_indoor
      }
    } catch (error) {
      console.error('获取温湿度数据失败:', error)
    }
  }

  build() {
    Column(){
      //用户信息栏
      UserInfoComp({userData:this.userData})
      //房间栏
      Tabs(){
        ForEach(this.roomAndElecAppList,(item:roomAndElecListClass)=>{
          RoomDataComp({
            temperatureAndHumidityData:this.temperatureAndHumdityData,
            sceneDataList:this.tempSceneList,
            roomAndElecAppData:item
          })
        },(item:roomAndElecListClass)=>item.room.roomId.toString())
      }
      .barHeight(40)
      .width('100%')
    }.height('100%')
  }
}

export { EquipmentPage }