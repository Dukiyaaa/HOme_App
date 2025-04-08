import {LightDataShowItemList,DataShowItem} from '../models/DataShowData'
import {elecDataClass} from '../models/EquipData'

//数据显示
@Component
export struct DataShow{
  @ObjectLink itemList:elecDataClass
  build() {
    Row(){
      Column(){
        Text(this.itemList.monthElec.toString()).fontSize(40)
        Text('当月耗电(度)')
      }.width('33%').height(100).justifyContent(FlexAlign.Center)
      Column(){
        Text(this.itemList.todayElec.toString()).fontSize(40)
        Text('今日耗电(度)')
      }.width('33%').height(100).justifyContent(FlexAlign.Center)
      Column(){
        Text(this.itemList.nowElec.toString()).fontSize(40)
        Text('当前功率(kw)')
      }.width('33%').height(100).justifyContent(FlexAlign.Center)
    }
  }

}