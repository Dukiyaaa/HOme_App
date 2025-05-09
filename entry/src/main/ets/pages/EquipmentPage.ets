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
import { getLatestElectricityData } from '../http/electricityData'
import { ElectricityData } from '../models/ElectricityData'

@Entry
@Component
struct EquipmentPage {

  //场景数据
  @State tempSceneList:SceneClassList=new SceneClassList([new SceneClass(
    0,
    '跌倒检测',
    $r('app.media.diedao'),
    $r('app.media.diedao'),
    0,
    new elecAppAction(
      undefined,
      undefined,
      undefined,
      [new lockAction(0, '紧急电话', elecAppTypeConst.phone, 0)]
    )),new SceneClass(1,
    '经期跟踪',
    $r('app.media.jingqi2'),
    $r('app.media.jingqi2'),
    0,
    new elecAppAction(
      undefined,
      undefined,
      undefined,
      [new lockAction(0, '提醒', elecAppTypeConst.notice, 0)]
    ))])
  //房间及电器数据
  @State roomAndElecAppList:roomAndElecListClass[]= [
    new roomAndElecListClass(new roomClass(0,'客厅'),tempElecAppList),
    new roomAndElecListClass(new roomClass(1,'卧室'),tempElecAppList)]
  //用户信息数据
  @State userData:UserData=new UserData()
  //温度湿度数据
  @State temperatureAndHumdityData:TemperatureAndHumidity=new TemperatureAndHumidity(new roomClass(0,'客厅'),20,50)
  //用电数据
  @State electricityData: ElectricityData = new ElectricityData(0)

  // 定时器ID
  private timerId: number = -1

  aboutToAppear() {
    // 页面加载时立即获取一次数据
    this.fetchAllData()
    // 设置定时器,每30秒获取一次数据
    this.timerId = setInterval(() => {
      this.fetchAllData()
    }, 30000)
  }

  aboutToDisappear() {
    // 页面销毁时清除定时器
    if (this.timerId !== -1) {
      clearInterval(this.timerId)
    }
  }

  // 获取所有数据
  private async fetchAllData() {
    await Promise.all([
      this.fetchTemperatureHumidity(),
      this.fetchElectricityData()
    ])
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

  // 获取用电数据
  private async fetchElectricityData() {
    try {
      const response = await getLatestElectricityData()
      console.info('获取用电数据响应:', JSON.stringify(response))
      if (response.status === 'success' && response.latest) {
        // 将微瓦转换为毫瓦
        const powerInMw = response.latest.power / 1000
        console.info('用电数据(μW):', response.latest.power)
        console.info('转换后用电数据(mW):', powerInMw)
        this.electricityData.power = powerInMw
      } else {
        console.warn('用电数据响应格式不正确:', response)
      }
    } catch (error) {
      console.error('获取用电数据失败:', error)
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
            roomAndElecAppData:item,
            electricityData: this.electricityData
          })
        },(item:roomAndElecListClass)=>item.room.roomId.toString())
      }
      .barHeight(40)
      .width('100%')
    }.height('100%')
  }
}

export { EquipmentPage }