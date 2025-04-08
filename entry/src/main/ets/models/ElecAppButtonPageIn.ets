@Observed export class ElecAppButtonItem{
  constructor(index: number, state: number, title: string, imgOpen: Resource, imgClose: Resource, routeTo: string) {
    this.index = index
    this.state = state
    this.title = title
    this.imgOpen = imgOpen
    this.imgClose = imgClose
    this.routeTo = routeTo
  }
  index:number=0
  state:number=0
  title:string=''
  imgOpen:Resource=$r('app.media.startIcon')
  imgClose:Resource=$r('app.media.startIcon')
  routeTo:string=''


}