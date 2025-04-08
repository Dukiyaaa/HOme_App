//input调整框

@Component
export struct InputAdjust{
  @State title:string=''
  @State value:number=0
  @State step:number=1
  @State max:number=100
  @State min:number=0
  build() {
    Column(){
      Text(this.title).fontSize(20)
      Row({ space: 0 }) {
        Button({type:ButtonType.Normal}){
          Text('-')
        }
        .width(50)
        .height(50)
        .fontSize(20)
        .backgroundColor('#E0E0E0')
        .borderRadius({ topLeft: 25, bottomLeft: 25 })
        .onClick(() => {
          if (this.value >=this.min) {
            this.value-=this.step
          }
        })
        Text(this.value.toString())
          .width('70%')
          .height(50)
          .fontSize(20)
          .backgroundColor('#E0E0E0')
          .borderRadius(0)
          .textAlign(TextAlign.Center)

        Button({type:ButtonType.Normal}){
          Text('+')
        }
        .width(50)
        .height(50)
        .fontSize(20)
        .backgroundColor('#E0E0E0')
        .borderRadius({ topRight: 25, bottomRight: 25 })
        .onClick(() => {
          if(this.value<=this.max){
            this.value+=this.step
          }
        })
      }
      .width('fit-content')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .padding({ top: 15,bottom:10})
      .borderRadius(25)
    }
    .padding({top:10,bottom:10})
    .alignItems(HorizontalAlign.Start)
  }
}