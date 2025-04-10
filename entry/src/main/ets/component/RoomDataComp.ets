import {router} from '@kit.ArkUI'
import {SceneClass,SceneClassList} from '../models/SceneData'
import {
  typeElecAppState,
  elecAppRouteToConst,
  elecAppRouteToConst2,
  airConditionClass,
  curtainClass,
  lockClass,
  lightClass,
  elecAppRouteToConst3} from '../models/EquipData'
import {roomAndElecListClass,TemperatureAndHumidity} from '../models/RoomData'
import {ElectricityData} from '../models/ElectricityData'
import {ElectricityDataComp} from './ElectricityDataComp'

@Component
export struct EquipListComp{
  @ObjectLink roomAndElecAppData:roomAndElecListClass

  build() {
    Column({space:10}){
      List({space:15}){
        ForEach(this.roomAndElecAppData.elecAppList,(item:typeElecAppState)=>{
          ListItem(){
            ElecAppButton2({item:item})
          }
          .width('100%')
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .lanes(2,15)
    }
    .width('96%')
  }
}

@Component
export struct EquipListComp2{
  @ObjectLink roomAndElecAppData:roomAndElecListClass

  build() {
    Column({space:10}){
      List({space:15}){
        ForEach(this.roomAndElecAppData.elecAppList,(item:typeElecAppState)=>{
          ListItem(){
            ElecAppButton3({item:item})
          }
          .width('100%')
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .lanes(2,15)
    }
    .width('96%')
  }
}



// 添加标题组件
@Component
struct SectionTitle {
  @Prop title: string

  build() {
    Row() {
      Row() {
        Divider()
          .vertical(true)
          .height(14)
          .width(2)
          .color('#5686E1')
          .margin({ right: 6 })
        Text(this.title)
          .fontSize(13)
          .fontWeight(FontWeight.Regular)
          .fontColor('#333')
      }
      Blank()
      Divider()
        .height(1)
        .width('70%')
        .color('#E8E8E8')
        .opacity(0.6)
    }
    .width('94%')
    .margin({ top: 8, bottom: 6 })
    .padding({ left: 10, right: 10, top: 6, bottom: 6 })
    .backgroundColor('#E6E8F1')
    .borderRadius(6)
  }
}

//房间页面组件
@Component
export struct RoomDataComp{
  @ObjectLink temperatureAndHumidityData:TemperatureAndHumidity
  @ObjectLink roomAndElecAppData:roomAndElecListClass
  @ObjectLink sceneDataList:SceneClassList
  @ObjectLink electricityData: ElectricityData

  build() {
    TabContent(){
      Scroll() {
        Column({space:10}){
          // 传感器数据监测标题
          SectionTitle({ title: '传感器数据监测' })

          //房间温湿度和电流电压数据
          Row({space:8}){
            // 温度显示
            Button({type:ButtonType.Normal}){
              Row(){
                Image($r('app.media.temperature_set')).width(20)
                Column() {
                  Text('温度')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                  Row() {
                    Text(this.temperatureAndHumidityData.temperature?.toString())
                      .fontColor('#5686E1')
                      .fontSize(18)
                    Text('°C')
                      .fontSize(10)
                      .fontColor('#5686E1')
                      .margin({left: 2})
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .margin({left: 8})
              }
              .width('100%')
              .height(45)
              .justifyContent(FlexAlign.Center)
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .width('32%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/TemperatureDetailPage'
              }, router.RouterMode.Single, (err) => {
                if (err) {
                  console.error(`跳转温度详情页失败: ${err.message}`)
                  return
                }
                console.info('跳转温度详情页成功')
              })
            })

            // 湿度显示
            Button({type:ButtonType.Normal}){
              Row(){
                Image($r('app.media.humidity2')).width(20)
                Column() {
                  Text('湿度')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                  Row() {
                    Text(this.temperatureAndHumidityData.humidity?.toString())
                      .fontColor('#5686E1')
                      .fontSize(18)
                    Text('%')
                      .fontSize(10)
                      .fontColor('#5686E1')
                      .margin({left: 2})
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .margin({left: 8})
              }
              .width('100%')
              .height(45)
              .justifyContent(FlexAlign.Center)
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .width('32%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HumidityDetailPage'
              }, router.RouterMode.Single, (err) => {
                if (err) {
                  console.error(`跳转湿度详情页失败: ${err.message}`)
                  return
                }
                console.info('跳转湿度详情页成功')
              })
            })

            // 电量显示
            Button({type:ButtonType.Normal}){
              Row(){
                Image($r('app.media.elec')).width(20)
                Column() {
                  Text('用电')
                    .fontSize(12)
                    .fontColor(Color.Gray)
                  Row() {
                    Text(this.electricityData.power.toFixed(2))
                      .fontColor('#5686E1')
                      .fontSize(18)
                    Text('mW')
                      .fontSize(10)
                      .fontColor('#5686E1')
                      .margin({left: 2})
                  }
                }
                .alignItems(HorizontalAlign.Start)
                .margin({left: 8})
              }
              .width('100%')
              .height(45)
              .justifyContent(FlexAlign.Center)
            }
            .backgroundColor(Color.White)
            .borderRadius(8)
            .width('32%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/PowerDetailPage'
              }, router.RouterMode.Single, (err) => {
                if (err) {
                  console.error(`跳转用电详情页失败: ${err.message}`)
                  return
                }
                console.info('跳转用电详情页成功')
              })
            })
          }
          .width('94%')
          .justifyContent(FlexAlign.SpaceBetween)

          // 常用场景标题
          SectionTitle({ title: '常用场景' })

          //上方场景列表部分
          if (this.roomAndElecAppData.room.roomId==0){
            Scroll(){
              Row({space:15}){
                ForEach(this.sceneDataList.sceneDataList,(item:SceneClass)=>{
                  SceneButton({
                    sceneData:item
                  })
                },(item:SceneClass)=>item.sceneId.toString())
              }.height(80)
            }
            .width('94%')
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
          }

          // 监控画面标题
          SectionTitle({ title: '实时监控' })

          //监控部分
          Column() {
            Stack() {
              Image($r('app.media.monitor_preview'))
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Cover)
                .borderRadius(10)
              
              Column() {
                Row() {
                  Text('监控画面')
                    .fontSize(16)
                    .fontColor('#FFFFFF')
                  Blank()
                  Image($r('app.media.camera'))
                    .width(24)
                    .height(24)
                }
                .width('100%')
                .padding(12)
                .backgroundColor('rgba(0, 0, 0, 0.3)')
              }
              .width('100%')
              .position({ y: 0 })
            }
          }
          .width('94%')
          .height(200)
          .backgroundColor('#f1f3f5')
          .borderRadius(10)
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/MonitorPage'
            }, router.RouterMode.Single, (err) => {
              if (err) {
                console.error(`跳转失败: ${err.code}, ${err.message}`);
                return;
              }
              console.info('跳转到监控页面成功');
            });
          })

          // 家居控制标题
          SectionTitle({ title: '家居控制' })

          //下方电器列表部分
          Column({space:10}){
            List({space:15}){
              ForEach(this.roomAndElecAppData.elecAppList,(item:typeElecAppState)=>{
                ListItem(){
                  ElecAppButton({item:item})
                }
                .width('100%')
              })
            }
            .scrollBar(BarState.Off)
            .width('100%')
            .lanes(2,15)
          }
          .width('94%')
          .margin({ bottom: 80 })
        }
      }
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
      .height('100%')
    }
    .tabBar(this.roomAndElecAppData.room.roomTitle)
  }
}

//首页上方场景按钮
@Component
export struct SceneButton{
  @ObjectLink sceneData:SceneClass
  build(){
    Button({ type: ButtonType.Normal, stateEffect: true }){
      Row(){
        Column() {
          Row(){
            Image(this.sceneData.closeOrOpen==0?this.sceneData.sceneImageClose:this.sceneData.sceneImageOpen)
              .width(45)
              .margin({right:10})
            Column(){
              Text(this.sceneData.sceneTitle)
                .margin({bottom: 8})
              Row({space:6}){
                if (this.sceneData.sceneAction.airConditionAction!==undefined){
                  Image(this.sceneData.sceneAction.airConditionAction[0].type.typeIconOpen)
                    .width(20)
                }
                if (this.sceneData.sceneAction.lightAction!==undefined){
                  Image(this.sceneData.sceneAction.lightAction[0].type.typeIconOpen)
                    .width(20)
                }
                if (this.sceneData.sceneAction.curtainAction!==undefined){
                  Image(this.sceneData.sceneAction.curtainAction[0].type.typeIconOpen)
                    .width(20)
                }
                if (this.sceneData.sceneAction.lockAction!==undefined){
                  Image(this.sceneData.sceneAction.lockAction[0].type.typeIconOpen)
                    .width(20)
                }
              }
            }.alignItems(HorizontalAlign.Start)
          }
        }
        .padding({left: 5, right: 15, top: 12, bottom: 12})
        .width('100%')
      }
    }
    .height(70)
    .width('48%')
    .borderRadius(10)
    .backgroundColor(Color.White)
    .fontColor(Color.Black)
    .onClick(()=>{
      this.sceneData.closeOrOpen=this.sceneData.closeOrOpen==0?1:0
      console.info(this.sceneData.closeOrOpen.toString())
    })
  }
}
//下方电器列表按钮
@Component
export struct ElecAppButton{
  @ObjectLink item: typeElecAppState
  build() {
    Column(){
      Image(this.item.state==0?$r('app.media.close2_gray') : $r('app.media.close2_blue'))
        .width(20)
        .height(20)
        .margin({top:10})
        .position({
          x:'80%'
        })
        .onClick(()=>{
          if(this.item.state!=0){
            this.item.elecAppList.forEach((item:airConditionClass|curtainClass|lockClass|lightClass)=>{
              item.state=0
            })
            this.item.state=0
          }else{
            this.item.elecAppList.forEach((item:airConditionClass|curtainClass|lockClass|lightClass)=>{
              item.state=1
            })
            this.item.state=1
          }
          console.info(this.item.elecAppList[0].state.toString())
        })
      Row({space:10}){
        Image(this.item.state==0?this.item.elecAppList[0].type.typeIconClose:this.item.elecAppList[0].type.typeIconOpen)
          .width(40)
        Column(){
          Text(this.item.elecAppList[0].type.typeName).fontSize(16)
          Text(this.item.state!=0?(this.item.state==1?'全部打开':'部分打开'):'关闭').fontSize(12).fontColor(Color.Gray)
        }.alignItems(HorizontalAlign.Start)
      }
      .margin({top:30})
      .width('88%')
      .onClick(() => {
        console.info(this.item.elecAppList[0].state.toString())
        router.pushUrl({
          url:this.item.elecAppList[0].type.typeName=='空调'?elecAppRouteToConst.airConditionRouteTo:
            this.item.elecAppList[0].type.typeName=='灯光'?elecAppRouteToConst.lightRouteTo:
              this.item.elecAppList[0].type.typeName=='窗帘'?elecAppRouteToConst.curtainRouteTo:
              elecAppRouteToConst.lockRouteTo,
          params:this.item
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
    .height('100')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }
}

//下方电器列表按钮
@Component
export struct ElecAppButton2{
  @ObjectLink item: typeElecAppState
  build() {
    Column(){
      Row({space:10}){
        Image(this.item.state==0?this.item.elecAppList[0].type.typeIconClose:this.item.elecAppList[0].type.typeIconOpen)
          .width(40)
        Column(){
          Text(this.item.elecAppList[0].type.typeName).fontSize(16)
        }.alignItems(HorizontalAlign.Start)
      }
      .margin({top:30})
      .width('88%')
      .onClick(() => {
        console.info(this.item.elecAppList[0].state.toString())
        console.info("wozaizheli")
        router.pushUrl({
          url:this.item.elecAppList[0].type.typeName=='空调'?elecAppRouteToConst2.airConditionRouteTo:
            this.item.elecAppList[0].type.typeName=='灯光'?elecAppRouteToConst2.lightRouteTo:
              this.item.elecAppList[0].type.typeName=='窗帘'?elecAppRouteToConst2.curtainRouteTo:
              elecAppRouteToConst2.lockRouteTo,
          params:this.item
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
    .height('100')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }
}

//下方电器列表按钮
@Component
export struct ElecAppButton3{
  @ObjectLink item: typeElecAppState
  build() {
    Column(){
      Row({space:10}){
        Image(this.item.state==0?this.item.elecAppList[0].type.typeIconClose:this.item.elecAppList[0].type.typeIconOpen)
          .width(40)
        Column(){
          Text(this.item.elecAppList[0].type.typeName).fontSize(16)
        }.alignItems(HorizontalAlign.Start)
      }
      .margin({top:30})
      .width('88%')
      .onClick(() => {
        console.info(this.item.elecAppList[0].state.toString())
        console.info("wozaizheli")
        router.pushUrl({
          url:this.item.elecAppList[0].type.typeName=='空调'?elecAppRouteToConst3.airConditionRouteTo:
            this.item.elecAppList[0].type.typeName=='灯光'?elecAppRouteToConst3.lightRouteTo:
              this.item.elecAppList[0].type.typeName=='窗帘'?elecAppRouteToConst3.curtainRouteTo:
              elecAppRouteToConst3.lockRouteTo,
          params:this.item
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
    .height('100')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }
}


//模式详情中的场景列表项
@Component
export struct SceneListItem{
  @ObjectLink sceneData:SceneClass
  build(){
    Button({type:ButtonType.Normal}){
      Row(){
        Image(this.sceneData.closeOrOpen==0?this.sceneData.sceneImageClose:this.sceneData.sceneImageOpen)
          .width(55)
        Column(){
          Text(this.sceneData.sceneTitle).fontSize(18)
          Row({space:3}){
            if (this.sceneData.sceneAction.airConditionAction!==undefined){
              Image(this.sceneData.sceneAction.airConditionAction[0].type.typeIconOpen)
                .width(25)
            }
            if (this.sceneData.sceneAction.lightAction!==undefined){
              Image(this.sceneData.sceneAction.lightAction[0].type.typeIconOpen)
                .width(25)
            }
            if (this.sceneData.sceneAction.curtainAction!==undefined){
              Image(this.sceneData.sceneAction.curtainAction[0].type.typeIconOpen)
                .width(25)
            }
            if (this.sceneData.sceneAction.lockAction!==undefined){
              Image(this.sceneData.sceneAction.lockAction[0].type.typeIconOpen)
                .width(25)
            }
          }
        }.alignItems(HorizontalAlign.Start)
        Blank()
        Image($r('app.media.inter'))
          .width(25)
      }
      .width('100%')
    }
      .width('100%')
      .height(70)
      .padding({left:10,right:10})
      .borderRadius(10)
      .backgroundColor(Color.White)
      .onClick(()=>{
      })
  }
}
