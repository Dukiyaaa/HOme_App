import {AirConditionBackItemList,CloseAndYesButtonItem} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import { airConditionClass, typeClass, typeElecAppState} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {sceData} from '../pages/ScenePage'

@Component
export struct HeadBackAndTitleComp{
  item?:CloseAndYesButtonItem
  //顶部返回按钮和title
  @Builder
  CloseAndYesButtonBuilder() {
    Row(){
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image(this.item!.image).width(30).height(30)
      }
      .width(55)
      .height(55)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        router.replaceUrl({
          url: this.item!.routeTo
        }, router.RouterMode.Single, (err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
      Text(this.item!.title).fontSize(20)
    }.width('100%')
  }

  build() {
    this.CloseAndYesButtonBuilder()
  }
}

@Component
export struct CloseAndYesButtonComp{
  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=[]
  build() {
    Row(){
      Button({type:ButtonType.Circle,stateEffect: true}){
        Image(this.closeAndYesButtonItem[0].image).width(30).height(30)
      }
      .width(55)
      .height(55)
      .backgroundColor(Color.Transparent)
      .onClick(()=>{
        router.replaceUrl({
          url:this.closeAndYesButtonItem[0].routeTo
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
        router.replaceUrl({
          url:this.closeAndYesButtonItem[0].routeTo
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
    }.width('100%')
  }
}

@Component
export struct CloseAndYesButtonCompLock{
  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=[]
  build() {
    Row(){
      Button({type:ButtonType.Circle,stateEffect: true}){
        Image(this.closeAndYesButtonItem[0].image).width(30).height(30)
      }
      .width(55)
      .height(55)
      .backgroundColor(Color.Transparent)
      .onClick(()=>{
        router.replaceUrl({
          url:this.closeAndYesButtonItem[0].routeTo
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
        router.replaceUrl({
          url:this.closeAndYesButtonItem[0].routeTo
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
    }.width('100%')
  }
}


@Component
export struct CloseAndYesButtonComp3{
  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=[]
  @State scedate:sceData=new sceData()
  build() {

  }
}


export class airClass{
  constructor(state: number) {
    this.state = state
  }
  name:string="空调"
  state:number=0
}

export class curClass{
  constructor(state: number) {
    this.state = state
  }
  name:string="窗帘"
  state:number=0
}

export class loClass{
  constructor(state: number) {
    this.state = state
  }
  name:string="门锁"
  state:number=0
}

export class liClass{
  constructor(state: number) {
    this.state = state
  }
  name:string="灯光"
  state:number=0
}

@Component
export struct CloseAndYesButtonComp2{
  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=[]
  @State equipName:string=""
  @State item:airClass=new airClass(0)
  build() {
    Row(){
      Button({type:ButtonType.Circle,stateEffect: true}){
        Image(this.closeAndYesButtonItem[0].image).width(30).height(30)
      }
      .width(55)
      .height(55)
      .backgroundColor(Color.Transparent)
      .onClick(()=>{
        console.info("我执行了")
        router.replaceUrl({
          url:this.closeAndYesButtonItem[0].routeTo,
          params:this.equipName
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
        console.info("zheli6")
        console.info(this.equipName+"gaga")
        router.pushUrl({
          url:this.closeAndYesButtonItem[0].routeTo,
          params:this.item
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
    }.width('100%')
  }
}

@Component
export struct CloseAndYesButtonComp4{
  @State closeAndYesButtonItem:CloseAndYesButtonItem[]=[]
  @State equipName:string=""
  @State item:airClass=new airClass(1)
  build() {
    Row(){
      Button({type:ButtonType.Circle,stateEffect: true}){
        Image(this.closeAndYesButtonItem[0].image).width(30).height(30)
      }
      .width(55)
      .height(55)
      .backgroundColor(Color.Transparent)
      .onClick(()=>{
        console.info("我执行了")
        router.replaceUrl({
          url:this.closeAndYesButtonItem[0].routeTo,
          params:this.equipName
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
        console.info("zheli6")
        console.info(this.equipName+"gaga")
        router.pushUrl({
          url:this.closeAndYesButtonItem[0].routeTo,
          params:this.item
        },router.RouterMode.Single,(err) => {
          if (err) {
            console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
            return;
          }
          console.info('Invoke pushUrl succeeded.');
        })
      })
    }.width('100%')
  }
}


