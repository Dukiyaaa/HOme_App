@Component
export struct ThirdComp{
  build() {
    Column(){
      Column({space:20}){
        Column(){
          Text('用户名称').backgroundColor(Color.Pink).fontSize(20)
          Row({space:5}){
            Text('一个家庭')
            Text('|')
            Text('五个设备')
          }
        }
        Row(){
          Column(){
            Text('用户名称')
            Text('三个成员').fontSize(10).fontColor(Color.Gray)
          }
          Button('图标')
          Button('图标')
        }

        Column({space:15}){
            Button('账户管理')
            Button('系统消息')
            Button('更多设置')
        }.height(150).width('100%').backgroundColor(Color.Pink)

      }
    }
  }
}