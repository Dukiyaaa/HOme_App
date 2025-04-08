import { SceneSetItemList,CloseAndYesButtonItem } from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {AddButtonItem,AddButtonItemList} from '../models/AddButton'
import {CustomDialogExample,TimeDialogExample,repeatDialogExample,TemperatureDialogExample
        ,ConditionDialogExample,humidityDialogExample,delayDialogExample} from '../component/Dialog'
import {CloseAndYesButtonComp, CloseAndYesButtonComp3} from '../component/HeadBackAndTitleComp'
import {SceneClass,elecAppAction,delayAction,humidityConditionClass,temperatureConditionClass,timeConditionClass,
  airConditionAction,lightAction,curtainAction,lockAction,remindAction} from '../models/SceneData'
import {airClass} from '../component/HeadBackAndTitleComp'
import { sceData } from './ScenePage'

const params2=router.getParams()
if (params2 instanceof String&&params2!="") {
  console.info(params2.toString())
  console.info("zheli5")
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
struct SceneSet {
  @State message: string = 'Hello World';
  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @State sceneNowData:SceneClass=new SceneClass(0,'自定义场景',$r('app.media.Scene_blue'),$r('app.media.Scene_gray'),0,new elecAppAction())
  @State timedata:timeConditionClass[]=[new timeConditionClass(new Date,true,[false,false])]
  @State temperaturedata:temperatureConditionClass[]=[new temperatureConditionClass('高于',15)]
  @State humiditydata:humidityConditionClass[]=[new humidityConditionClass('低于',20)]
  @State delaydata:delayAction[]=[new delayAction(new Date)]
  @State reminddata:remindAction[]=[new remindAction(new Date)]
  @State timestate:number=0
  @State temperaturestate:number=0
  @State humiditystate:number=0
  @State delaystate:number=0
  @State remindstate:number=0
  @State equipData:string[]=[]
  @State equipData2:string[]=[]
  @State scedate:sceData=new sceData()

  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=SceneSetItemList
  onPageShow(){
    const params=router.getParams()
    console.info("zheli5")
    if(params){
      const temp=params as airClass
      this.equipData.push(temp.name)
      console.info(this.equipData[0])
    }else{
      console.info("undefine")
    }
    if (params instanceof String&&params!="") {

      console.info(params.toString())
      console.info("zheli5")
    }
  }

  //执行动作dialog
  ActionDialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      openBox:[
        ()=>{this.TimeDialogController.open()},
        ()=>{this.TimeDialogController.open()},
        ()=>{this.temperatureDialogController.open()},
        ()=>{this.humidityDialogController.open()},
      ]
    }),
    alignment: DialogAlignment.Bottom,
  })

  //重复dialog
  repeatDialogController: CustomDialogController = new CustomDialogController({
    builder: repeatDialogExample(),
    alignment: DialogAlignment.Bottom,
  })

  //时间dialog
  TimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialogExample({
      openRepeatPickerBox:()=>{
        this.repeatDialogController.open()
      },
      confirm:(timeCondition:timeConditionClass)=>{
        this.TimeDialogController.close()
        console.info('tianjia')
        if (!this.sceneNowData.sceneCondition.timeCondition) {
          this.timestate=1
          this.sceneNowData.sceneCondition.timeCondition=[timeCondition]
        }
        else {
          this.sceneNowData.sceneCondition.timeCondition.push(timeCondition)
          console.info('添加了时间')
        }
      },
      cancel:()=>{
        this.TimeDialogController.close()
      },
      controller2:this.repeatDialogController
    }),
    alignment: DialogAlignment.Bottom,
  })

  //温度dialog
  temperatureDialogController: CustomDialogController = new CustomDialogController({
    builder: TemperatureDialogExample({
      confirm:(temperatureCondition:temperatureConditionClass)=>{
        this.temperaturestate=1
        console.info(this.temperaturestate.toString())
        if (!this.sceneNowData.sceneCondition.temperatureCondition) {
          this.sceneNowData.sceneCondition.temperatureCondition=temperatureCondition
        }
        else {
          this.sceneNowData.sceneCondition.temperatureCondition=temperatureCondition
        }
      }
    }),
    alignment: DialogAlignment.Bottom,
  })

  //湿度dialog
  humidityDialogController: CustomDialogController = new CustomDialogController({
    builder: humidityDialogExample({
      confirm:(humidityCondition:humidityConditionClass)=>{
        this.humiditystate=1
        if(!this.sceneNowData.sceneCondition.humidityCondition){
          this.sceneNowData.sceneCondition.humidityCondition=humidityCondition
          console.info(humidityCondition.lowOrHigh)
        }
        else {
          this.sceneNowData.sceneCondition.humidityCondition=humidityCondition
        }

    }
    }),
    alignment: DialogAlignment.Bottom,
  })

  //延时dialog
  delayDialogController: CustomDialogController = new CustomDialogController({
    builder: delayDialogExample({
      confirm:(time:Date)=>{
        this.delaystate=1
        this.sceneNowData.sceneAction.delayAction=new delayAction(time)
      }
    }),
    alignment: DialogAlignment.Bottom,
  })

  //触发条件dialog
  ConditionDialogController: CustomDialogController = new CustomDialogController({
    builder: ConditionDialogExample({
      openBox:[
      ()=>{this.TimeDialogController.open()},
      ()=>{this.TimeDialogController.open()},
      ()=>{this.delayDialogController.open()},
      ()=>{this.humidityDialogController.open()},
    ]}),
    alignment: DialogAlignment.Bottom,
  })

  @Builder
  AddButton(item:AddButtonItem){
    Button({type: ButtonType.Normal,stateEffect:true}){
      Row({space:10}){
        Image(item.image)
          .width(40)
        Text(item.title)
      }
    }
    .align(Alignment.Start)
    .borderRadius(1)
    .height(50)
    .width('100%')
    .backgroundColor(Color.White)
  }

  @Builder
  ConditionOrActionButton(item:timeConditionClass|remindAction|delayAction|
  temperatureConditionClass|humidityConditionClass|string){
    ListItem(){
      Button({type: ButtonType.Normal,stateEffect:true}){
        Row({space:10}){
          if (item=="空调"){
            Image($r('app.media.airCondition_blue'))
              .width(40)
            Text('空调设置')
          }else if(item=='灯光'){
            Image($r('app.media.light_blue'))
              .width(40)
            Text('灯光设置')
          }
          else if(item=='门锁'){
            Image($r('app.media.lock_blue'))
              .width(40)
            Text('门锁设置')
          }
          else if(item=='窗帘'){
            Image($r('app.media.curtain_blue'))
              .width(40)
            Text('窗帘设置')
          }
          else if(item instanceof delayAction){
            Image($r('app.media.delay'))
              .width(40)
            Text('延时设置')
          }
          else if(item instanceof remindAction){
            Image($r('app.media.notice'))
              .width(40)
            Text('通知设置')
          }
          else if(item instanceof timeConditionClass){
            Image($r('app.media.time_set'))
              .width(40)
            Text('定时设置')
          }
          else if(item instanceof temperatureConditionClass){
            Image($r('app.media.temperature_set'))
              .width(40)
            Text('温度设置')
          }
          else if(item instanceof humidityConditionClass){
            Image($r('app.media.humidity2'))
              .width(40)
            Text('湿度设置')
          }

        }
      }
      .align(Alignment.Start)
      .borderRadius(1)
      .height(50)
      .width('100%')
      .backgroundColor(Color.White)
    }

  }

  build() {
    Scroll(){
      Column(){
        Row(){
          Row(){
            Button({type:ButtonType.Circle,stateEffect: true}){
              Image(this.closeAndYesButtonItem[0].image).width(30).height(30)
            }
            .width(55)
            .height(55)
            .backgroundColor(Color.Transparent)
            .onClick(()=>{
              console.info("dianjile")
              if (AppStorage.get('scedate')) {
                let temp=AppStorage.get('scedate') as sceData[]
                if (temp.length==0) {
                  console.info("temp0")
                  AppStorage.setOrCreate('scedate', [this.scedate]);
                }else{
                  console.info("temp1")
                  temp.push(this.scedate)
                  AppStorage.setOrCreate('scedate',temp)

                }
              }else{
                AppStorage.setOrCreate('scedate',[this.scedate])
                console.info("创建你")
              }

              router.replaceUrl({
                // url:this.closeAndYesButtonItem[0].routeTo,
                url:"pages/ScenePage",
                params:this.scedate
              },router.RouterMode.Single,(err) => {
                if (err) {
                  console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                  return;
                }
                console.info('Invoke pushUrl succeeded.');
              })
            })
            Text(this.closeAndYesButtonItem[0].title).fontSize(20)
            Blank()
            Button({type:ButtonType.Circle,stateEffect: true}){
              Image(this.closeAndYesButtonItem[1].image).width(30).height(30)
            }
            .width(55)
            .height(55)
            .backgroundColor(Color.Transparent)
            .onClick(()=>{
              if (AppStorage.get('scedate')) {
                let temp=AppStorage.get('scedate') as sceData[]
                if (temp.length==0) {
                  console.info("temp0")
                  AppStorage.setOrCreate('scedate', [this.scedate]);
                }else{
                  console.info("temp1")
                  temp.push(this.scedate)
                  AppStorage.setOrCreate('scedate',temp)
                }
              }else{
                AppStorage.setOrCreate('scedate',[this.scedate])
                console.info("创建你")
              }
              router.replaceUrl({
                // url:this.closeAndYesButtonItem[0].routeTo
                url:"pages/ScenePage",
                params:this.scedate
              },router.RouterMode.Single,(err) => {
                if (err) {
                  console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                  return;
                }
                console.info('Invoke pushUrl succeeded.');
              })
            })
          }.width('100%')
        }.width('100%')
        Column({space:30}){
          TextInput({ placeholder: '为场景取个名字吧', text: this.scedate.name })
            .onChange((value:string)=>{
              this.scedate.name=value
            })
            .fontSize(20)
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          Column({space:10}){
            Text('当以下情况发生:')
              .width('100%')
              .fontSize(20)
            List(){
              if (this.equipData2.length!=0){
                ForEach(this.equipData2,(item:string)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              if (this.temperaturestate==1){
                ForEach(this.temperaturedata,(item:temperatureConditionClass)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              if (this.timestate==1){
                ForEach(this.timedata,(item:timeConditionClass)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              if (this.humiditystate==1){
                ForEach(this.humiditydata,(item:humidityConditionClass)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              ListItem(){
                this.AddButton(AddButtonItemList[0])
              }.onClick(()=>{
                this.ActionDialogController.open()
              })
            }
            .borderRadius(15)
            .divider(this.egDivider)
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          }
          Column({space:10}){
            Text('执行以下动作:')
              .width('100%')
              .fontSize(20)
            List(){
              if (this.equipData.length!=0){
                ForEach(this.equipData,(item:string)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              if (this.delaystate==1){
                ForEach(this.delaydata,(item:delayAction)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              if (this.remindstate==1){
                ForEach(this.reminddata,(item:remindAction)=>{
                  this.ConditionOrActionButton(item)
                })
              }
              ListItem(){
                this.AddButton(AddButtonItemList[1])
              }.onClick(()=>{
                this.ConditionDialogController.open()
              })
            }
            .borderRadius(15)
            .divider(this.egDivider)
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          }
        }.margin({top:50})
      }.padding({left:10,right:10})
    }
    .align(Alignment.TopStart)
    .height('100%')
    .backgroundImage($r('app.media.bgimg'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
}
