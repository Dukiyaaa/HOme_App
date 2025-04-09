import {AirConditionSpecBackItemList,CloseAndYesButtonItem,CloseAndYesButton,EquipSpecItemList} from '../models/CloseAndYesButton'
import { airClass, CloseAndYesButtonComp2, HeadBackAndTitleComp} from '../component/HeadBackAndTitleComp'
import {AirConditionBackItemList} from '../models/CloseAndYesButton'
import {router} from '@kit.ArkUI'
import {
  airConditionClass,
  typeElecAppState,
  elecAppTypeConst,
  airConditionWindSpeedConst,
  airConditionModeConst,
  airConditionWindWayConst} from '../models/EquipData'
import { roomClass } from '../models/RoomData'
import {CloseAndOpenButton} from '../component/CloseAndOpenButton'
import {PowerConsumption,LightSpecData} from '../models/ElecAppSpecData'
import {SliderAdjust} from '../component/SliderAdjust'
import {InputAdjust} from '../component/InputAdjust'
import {equipControl, airConditioner_stateParas,postEquipControl} from  '../http/basicEquipAdjust'
import {CloseAndYesButtonComp} from '../component/HeadBackAndTitleComp'

@Entry
@Component
struct AirConditionSpecPage {
  @State message: string = 'Hello World';
  @State airConditionData: airConditionClass =
    new airConditionClass(0, '', new roomClass(0, 'j'), elecAppTypeConst.airCondition)

  aboutToAppear(): void {
    const params = router.getParams()
    if (params) {
      this.airConditionData = params as airConditionClass
    }
  }

  @State body: equipControl = new equipControl(
    "attribute",
    "airConditioner_setState",
    new airConditioner_stateParas('cold', 1)
  )

  private updateAirConditionerState() {
    const mode: 'cold' | 'hot' = this.airConditionData.airConditionMode === airConditionModeConst.hot ? 'hot' : 'cold';
    
    let speed: 1 | 2 | 3 = 1;
    switch(this.airConditionData.airConditionWind) {
      case airConditionWindSpeedConst.low: speed = 1; break;
      case airConditionWindSpeedConst.middle: speed = 2; break;
      case airConditionWindSpeedConst.high: speed = 3; break;
      default: speed = 1;
    }

    const body = new equipControl(
      "attribute",
      "airConditioner_setState",
      new airConditioner_stateParas(mode, speed)
    );
    
    postEquipControl(body);
  }

  build() {
      Column() {
        Row(){
          CloseAndYesButtonComp2({closeAndYesButtonItem:EquipSpecItemList,item:new airClass()})
        }.width('100%')
        Blank().height(30)
          List({ space: 20 }) {
            //温度调节
            ListItem() {
              InputAdjust({
                title: '温度',
                value: this.airConditionData.temperature,
                step: 0.5,
                max: 30,
                min: 16
              })
            }
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
            .width('100%')
            .height(100)
            .padding({ left: 10, right: 10 })
            .backgroundColor(Color.White)
            .borderRadius(10)
            //模式
            ListItem() {
              Column() {
                Text('模式').fontSize(20)
                Row({ space: 30 }) {
                  Column() {
                    Image(this.airConditionData.airConditionMode==airConditionModeConst.auto?
                    $r('app.media.a_blue'):
                    $r('app.media.a')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionMode==airConditionModeConst.auto?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('自动')
                  }.onClick(()=>{
                    this.airConditionData.airConditionMode=airConditionModeConst.auto
                  })
                  Column() {
                    Image(this.airConditionData.airConditionMode==airConditionModeConst.cold?
                    $r('app.media.cold_blue'):
                    $r('app.media.cold')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionMode==airConditionModeConst.cold?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('制冷')
                  }.onClick(()=>{
                    this.airConditionData.airConditionMode=airConditionModeConst.cold
                    this.updateAirConditionerState()
                  })
                  Column() {
                    Image(this.airConditionData.airConditionMode==airConditionModeConst.hot?
                    $r('app.media.hot_blue'):
                    $r('app.media.hot')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionMode==airConditionModeConst.hot?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('制热')
                  }.onClick(()=>{
                    this.airConditionData.airConditionMode=airConditionModeConst.hot
                    this.updateAirConditionerState()
                  })
                  Column() {
                    Image(this.airConditionData.airConditionMode==airConditionModeConst.humidity?
                    $r('app.media.humidity_blue'):
                    $r('app.media.humidity')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionMode==airConditionModeConst.humidity?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('除湿')
                  }.onClick(()=>{
                    this.airConditionData.airConditionMode=airConditionModeConst.humidity
                  })
                  Column() {
                    Image(this.airConditionData.airConditionMode==airConditionModeConst.wind?
                    $r('app.media.wind_blue'):
                    $r('app.media.wind')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionMode==airConditionModeConst.wind?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('除湿')
                  }.onClick(()=>{
                    this.airConditionData.airConditionMode=airConditionModeConst.wind
                  })
                }
                .justifyContent(FlexAlign.Center)
                .width('100%')

              }
              .padding({top:10,bottom:10})
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
            .width('100%')
            .height(100)
            .padding({ left: 10, right: 10 })
            .margin({ top: 30 })
            .backgroundColor(Color.White)
            .borderRadius(10)
            //风速
            ListItem() {
              Column() {
                Text('风速').fontSize(20)
                Row({ space: 30 }) {
                  Column() {
                    Image(this.airConditionData.airConditionWind==airConditionWindSpeedConst.auto?
                    $r('app.media.a_blue'):
                    $r('app.media.a')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWind==airConditionWindSpeedConst.auto?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('自动')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWind=airConditionWindSpeedConst.auto
                  })
                  Column() {
                    Image(this.airConditionData.airConditionWind==airConditionWindSpeedConst.low?
                    $r('app.media.l_blue'):
                    $r('app.media.l')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWind==airConditionWindSpeedConst.low?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('低')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWind=airConditionWindSpeedConst.low
                    this.updateAirConditionerState()
                  })
                  Column() {
                    Image(this.airConditionData.airConditionWind==airConditionWindSpeedConst.middle?
                    $r('app.media.m_blue'):
                    $r('app.media.m')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWind==airConditionWindSpeedConst.middle?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('中')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWind=airConditionWindSpeedConst.middle
                    this.updateAirConditionerState()
                  })
                  Column() {
                    Image(this.airConditionData.airConditionWind==airConditionWindSpeedConst.high?
                    $r('app.media.h_blue'):
                    $r('app.media.h')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWind==airConditionWindSpeedConst.high?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('高')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWind=airConditionWindSpeedConst.high
                    this.updateAirConditionerState()
                  })
                }
                .justifyContent(FlexAlign.Center)
                .width('100%')

              }
              .padding({top:10,bottom:10})
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
            .width('100%')
            .height(100)
            .padding({ left: 10, right: 10 })
            .margin({ top: 30 })
            .backgroundColor(Color.White)
            .borderRadius(10)
            //扫风
            ListItem() {
              Column() {
                Text('扫风').fontSize(20)
                Row({ space: 30 }) {
                  Column() {
                    Image(this.airConditionData.airConditionWindWay==airConditionWindWayConst.close?
                    $r('app.media.stop_blue'):
                    $r('app.media.stop')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWindWay==airConditionWindWayConst.close?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('关闭')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWindWay=airConditionWindWayConst.close
                  })
                  Column() {
                    Image(this.airConditionData.airConditionWindWay==airConditionWindWayConst.upAndDown?
                    $r('app.media.upanddown_blue'):
                    $r('app.media.upanddown')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWindWay==airConditionWindWayConst.upAndDown?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('上下扫风')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWindWay=airConditionWindWayConst.upAndDown
                  })
                  Column() {
                    Image(this.airConditionData.airConditionWindWay==airConditionWindWayConst.leftAndRigjt?
                    $r('app.media.leftandright_blue'):
                    $r('app.media.leftandright')
                    )
                      .width(40)
                      .borderColor(this.airConditionData.airConditionWindWay==airConditionWindWayConst.leftAndRigjt?'#5686E1':'#333333')
                      .borderWidth(2)
                      .borderRadius('50%')
                      .padding(5)
                    Text('左右扫风')
                  }.onClick(()=>{
                    this.airConditionData.airConditionWindWay=airConditionWindWayConst.leftAndRigjt
                  })
                }
                .justifyContent(FlexAlign.Center)
                .width('100%')

              }
              .padding({top:10,bottom:10})
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .shadow(ShadowStyle.OUTER_DEFAULT_SM)
            .width('100%')
            .height(100)
            .padding({ left: 10, right: 10 })
            .margin({ top: 30 })
            .backgroundColor(Color.White)
            .borderRadius(10)
            ListItem(){
              Column(){
                Blank().height('25%')
              }

            }
          }
          .width('100%')
          .height('650')
        CloseAndOpenButton({
          stateFromParent: this.airConditionData.state,
          updateState: {
            run: (newState: number) => {
              this.airConditionData.state = newState
            }
          },
          deviceType: 'airCondition'
        })

            .position({top:'75%',left:'36%'})
        }
        .height('100%')
        .width('100%')
        .backgroundImage($r('app.media.bgimg'))
        .backgroundImageSize({width:'100%',height:'100%'})
    }
  }