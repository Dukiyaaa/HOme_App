import {equipControl,open_percentParas, postEquipControl} from '../http/basicEquipAdjust'

// 滑动框调节组件

@Component
export struct SliderAdjust{
  @State title:string=''
  @State value:number=0
  @State body:equipControl=new equipControl("arrtibute","curtain_openPercent",new open_percentParas(100))

  build(){
      Column(){
    Text(this.title).fontSize(20)
    Slider({
      value:this.value,
      min:0,
      max:100,
      step:10
    }).onChange((newValue:number,mode:SliderChangeMode)=>{
      this.value=newValue
      if(mode==0){
        postEquipControl(new equipControl(this.body.service_id,this.body.command_name,new open_percentParas(newValue)))
      }
    })
      .showTips(true)
      .stepColor(Color.Pink)
      .width('fit-content')
      .padding({ top: 15,bottom:10})
      .borderRadius(25)
  }
  .padding({top:10,bottom:10})
  .alignItems(HorizontalAlign.Start)
  }

}
