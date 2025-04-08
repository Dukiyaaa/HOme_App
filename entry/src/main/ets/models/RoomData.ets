import {typeElecAppState,tempElecAppList} from '../models/EquipData'
//房间类型
@Observed
export class  roomClass{
  constructor(roomId: number, roomTitle: string) {
    this.roomId = roomId
    this.roomTitle = roomTitle
  }
  roomId:number=0
  roomTitle:string='卧室'
}

//房间及电器数据
@Observed
export class roomAndElecListClass{
  constructor(room: roomClass, elecAppList: typeElecAppState[]) {
    this.room = room
    this.elecAppList = elecAppList
  }
  room:roomClass=new roomClass(0,'客厅')
  elecAppList:typeElecAppState[]=tempElecAppList
}

//房间温湿度数据
@Observed
export class TemperatureAndHumidity{
  constructor(room?: roomClass, temperature?: number, humidity?: number) {
    this.room = room
    this.temperature = temperature
    this.humidity = humidity
  }
  room?:roomClass=new roomClass(0,'全屋')
  temperature?:number=20
  humidity?:number=50
}
