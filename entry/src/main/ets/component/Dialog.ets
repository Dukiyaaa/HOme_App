import {ConditionAndActionButtonItem,ConditionAndActionButtonList} from '../models/ConditionAndActionButton'
import {SceneCondition,timeConditionClass,temperatureConditionClass,humidityConditionClass} from '../models/SceneData'
import {router} from '@kit.ArkUI'

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

//设置触发条件弹出框
@CustomDialog
export struct CustomDialogExample {

  openBox?: (()=>void)[]
  controller?: CustomDialogController

  cancel?: () => void
  confirm?: () => void

  @Builder
  ConditionAndActionButton(item:ConditionAndActionButtonItem){
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(item.img)
          .width(40)
        Column(){
          Text(item.title).fontSize(20)
          Text(item.description).fontSize(10)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .onClick(() => {
      if(item.index==0){
        console.info("niahoaaa")
        this.controller?.close()
        router.pushUrl({
          url:'pages/EquipList'
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      }else{
        this.openBox![item.index]();
      }
    })
    .height('80')
    .width('45%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }

  build() {
    Column() {
      Text('添加触发条件').fontSize(20).margin({ top: 10, bottom: 10 })
      Column({space:10}){
        Row({space:10}){
            this.ConditionAndActionButton(ConditionAndActionButtonList[0])
            this.ConditionAndActionButton(ConditionAndActionButtonList[1])
        }
        Row({space:10}){
          this.ConditionAndActionButton(ConditionAndActionButtonList[2])
          this.ConditionAndActionButton(ConditionAndActionButtonList[3])
        }
      }.padding({bottom:15})
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller!.close()
            if (this.cancel) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}

//设置触发条件-时间弹出框
@CustomDialog
export struct TimeDialogExample {
  controller3: CustomDialogController = new CustomDialogController({
    builder: TimeDialogExample(),
  })
  controller2?:CustomDialogController
  openRepeatPickerBox?:()=> void

  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @State repeatText:string='不重复'
  @State time:Date=new Date()
  @State isRepeat:boolean[]=[false,false,false,false,false,false,false]
  @State isFestival:boolean=false

  cancel?: () => void
  confirm?: (timeCondition:timeConditionClass) => void

  build() {
    Column() {
      Text('选择时间').fontSize(20).margin({ top: 10, bottom: 10 })
      Column({space:10}){
        TimePicker()
          .useMilitaryTime(true)
          .onChange((value:TimePickerResult)=>{
            let temp=new Date()
            this.time=new Date(temp.getFullYear(),temp.getMonth(),temp.getDate(),value.hour,value.minute,value.second)
          })
        List(){
          ListItem(){
            Row(){
              Text('智能跳过节假日').fontSize(20)
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.isFestival })
                .onChange((isOn:boolean)=>{
                  this.isFestival=isOn
                })
                .height(30)
                .width(50)
            }
            .width('100%')
            .height(50)
          }
          .padding({top:40})
          .margin({top:40})
          .width('100%')
          ListItem(){
            Row(){
              Text('重复').fontSize(20)
              Blank()
              Text(this.repeatText).fontSize(15).fontColor(Color.Grey)
              Image($r('app.media.inter')).width(23)
            }
            .width('100%')
            .height(50)
            .onClick(()=>{
              this.openRepeatPickerBox!()
              this.controller2
            })
          }.width('100%')
        }
        .width('95%')
        .divider(this.egDivider)
      }.padding({bottom:15})
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            if (this.cancel) {
              this.cancel()
            }
            console.info('dianjile')
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            if (this.confirm) {
              this.confirm(new timeConditionClass(this.time,this.isFestival,this.isRepeat))
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}

//设置触发条件-时间-重复弹出框
@CustomDialog
export struct repeatDialogExample {
  controller: CustomDialogController = new CustomDialogController({
    builder: repeatDialogExample({}),
  })

  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @State isRepeat:boolean[]=[false,false,false,false,false,false,false]

  cancel?: () => void
  confirm?: (isRepeat:boolean[]) => void

  @Builder
  ConditionAndActionButton(item:ConditionAndActionButtonItem){
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(item.img)
          .width(40)
        Column(){
          Text(item.title).fontSize(20)
          Text(item.description).fontSize(10)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .height('80')
    .width('45%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }

  build() {
    Column(){
      List(){
        ListItem(){
          Row(){
            Text('周一').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[0] })
              .onChange((isOn:boolean)=>{
                  this.isRepeat[0]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
        ListItem(){
          Row(){
            Text('周二').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[1] })
              .onChange((isOn:boolean)=>{
                this.isRepeat[1]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
        ListItem(){
          Row(){
            Text('周三').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[2] })
              .onChange((isOn:boolean)=>{
                this.isRepeat[2]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
        ListItem(){
          Row(){
            Text('周四').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[3] })
              .onChange((isOn:boolean)=>{
                this.isRepeat[3]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
        ListItem(){
          Row(){
            Text('周五').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[4] })
              .onChange((isOn:boolean)=>{
                this.isRepeat[4]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
        ListItem(){
          Row(){
            Text('周六').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[5] })
              .onChange((isOn:boolean)=>{
                this.isRepeat[5]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
        ListItem(){
          Row(){
            Text('周日').fontSize(20)
            Blank()
            Toggle({ type: ToggleType.Checkbox, isOn: this.isRepeat[6] })
              .onChange((isOn:boolean)=>{
                this.isRepeat[6]=isOn
              })
              .selectedColor(Color.Pink)
          }.width('100%')
        }
        .margin({top:20,left:10,right:10})
        .height(40)
      }.divider(this.egDivider)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('返回')
          .onClick(() => {
            this.controller.close()
            if (this.confirm) {
              this.confirm
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }

  }
}

//设置触发条件-温度弹出框
@CustomDialog
export struct TemperatureDialogExample {
  openRepeatPickerBox?: ()=>void

  controller: CustomDialogController = new CustomDialogController({
    builder: TimeDialogExample({}),
  })

  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @State temperatureTextPickerOptions:TextPickerOptions={
    range:[['高于','低于'],['-30','-29','-28','-27','-26','-25','-24','-23','-22',
      '-21','-20','-19','-18','-17','-16','-15','-14','-13','-12','-11','-10','-9',
      '-8','-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4',
      '5','6','7','8','9','10','11','12','13','14','15','16','17',
      '18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33',
      '34','35','36','37','38','39','40']],
    selected:[0,45]
  }

  cancel?: () => void
  confirm?: (temperatureCondition:temperatureConditionClass) => void

  @Builder
  ConditionAndActionButton(item:ConditionAndActionButtonItem){
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(item.img)
          .width(40)
        Column(){
          Text(item.title).fontSize(20)
          Text(item.description).fontSize(10)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .height('80')
    .width('45%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }

  build() {
    Column() {
      Text('设定温度（°C）').fontSize(20).margin({ top: 10, bottom: 10 })
      Column({space:10}){
        TextPicker(this.temperatureTextPickerOptions).canLoop(false)
      }.padding({bottom:15})
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            if (this.cancel) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.controller.close()
            if (this.confirm) {
              this.confirm(new temperatureConditionClass('高于',15))
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}

//设置触发条件-湿度弹出框
@CustomDialog
export struct humidityDialogExample {
  openRepeatPickerBox?: ()=>void

  controller: CustomDialogController = new CustomDialogController({
    builder: TimeDialogExample({}),
  })

  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')
  @State humidityTextPickerOptions:TextPickerOptions={
    range:[['高于','低于'],['0','10','20','30','40','50','60','70','80','90','100']],
    selected:[0,45]
  }

  cancel?: () => void
  confirm?: (humidityCondition:humidityConditionClass) => void

  @Builder
  ConditionAndActionButton(item:ConditionAndActionButtonItem){
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(item.img)
          .width(40)
        Column(){
          Text(item.title).fontSize(20)
          Text(item.description).fontSize(10)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .height('80')
    .width('45%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }

  build() {
    Column() {
      Text('设定湿度（%）').fontSize(20).margin({ top: 10, bottom: 10 })
      Column({space:10}){
        TextPicker(this.humidityTextPickerOptions).canLoop(false)
      }.padding({bottom:15})
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            if (this.cancel) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {
            this.controller.close()

            if (this.confirm) {
              this.confirm(new humidityConditionClass('低于',80))
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}

//添加执行动作弹出框
@CustomDialog
export struct ConditionDialogExample {

  openBox?: (()=>void)[]
  controller?: CustomDialogController

  cancel?: () => void
  confirm?: () => void

  @Builder
  ConditionAndActionButton(item:ConditionAndActionButtonItem){
    Button({type:ButtonType.Normal,stateEffect: true}){
      Row({space:10}){
        Image(item.img)
          .width(40)
        Column(){
          Text(item.title).fontSize(20)
          Text(item.description).fontSize(10)
        }.alignItems(HorizontalAlign.Start)
      }.width('88%')
    }
    .onClick(() => {
      if(item.index==4){
        console.info("niahoaaa")
        this.controller?.close()
        router.pushUrl({
          url:'pages/EquipList'
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      }else{
        this.openBox![item.index-4]();
      }
    })
    .height('80')
    .width('45%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
  }

  build() {
    Column() {
      Text('添加执行动作').fontSize(20).margin({ top: 10, bottom: 10 })
      Column({space:10}){
        Row({space:10}){
          this.ConditionAndActionButton(ConditionAndActionButtonList[4])
          this.ConditionAndActionButton(ConditionAndActionButtonList[5])
        }
        Row({space:10}){
          this.ConditionAndActionButton(ConditionAndActionButtonList[6])
          this.ConditionAndActionButton(ConditionAndActionButtonList[7])
        }
      }.padding({bottom:15})
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller!.close()
            if (this.cancel) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}

//添加执行动作-延时弹出框
@CustomDialog
export struct delayDialogExample {
  openRepeatPickerBox?: ()=>void
  @State selectedTime: Date=new Date

  controller: CustomDialogController = new CustomDialogController({
    builder: delayDialogExample({}),
  })

  @State egDivider: DividerTmp = new DividerTmp(1, 50, 10, '#ffe9f0f0')

  cancel?: () => void = ()=>{

  }
  confirm?: (time:Date) => void

  build() {
    Column() {
      Text('选择延迟时长').fontSize(20).margin({ top: 10, bottom: 10 })
      Column({space:10}){
        TimePicker()
          .onChange((value:TimePickerResult)=>{
            this.selectedTime.setHours(value.hour,value.minute,value.second)
          })
          .useMilitaryTime(true)
      }.padding({bottom:15})
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            if (this.cancel) {
              this.cancel()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(() => {

            this.controller.close()
            if (this.confirm) {
              this.confirm(this.selectedTime)
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
      }.margin({ bottom: 10 })
    }
  }
}


@Entry
@Component
struct Dialog {

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
    }),
    offset: { dx: 0, dy: '40%' },
  })

  dialogController2: CustomDialogController = new CustomDialogController({
    builder: TimeDialogExample(),
    offset: { dx: 0, dy: '40%' },
  })

  build() {
    Column() {
      Button('click me')
        .onClick(() => {
          this.dialogController.open()
        })
    }.width('100%').margin({ top: 5 })
  }
}