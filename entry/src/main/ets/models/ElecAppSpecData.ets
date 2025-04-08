//定义各种电器的参数

export class PowerConsumption{
  monthConsumption:number=0
  todayConsumption:number=0
  nowPower:number=0

  constructor(monthConsumption:number,todayConsumption:number,nowPower:number) {
    this.monthConsumption=monthConsumption
    this.todayConsumption=todayConsumption
    this.nowPower=nowPower
  }
}

export class LightSpecData{
  lightId:number=0
  lightName:string='灯'
  states:boolean=false
  brightness:number=0
  colTemperature:number=0
  powerConsumption:PowerConsumption=new PowerConsumption(0,0,0)

  constructor(lightId:number,lightName:string,states:boolean,brightness:number,colTemperature:number,powerConsumption:PowerConsumption) {
    this.lightId=lightId
    this.lightName=lightName
    this.states=states
    this.brightness=brightness
    this.colTemperature=colTemperature
    this.powerConsumption=powerConsumption
  }
}

