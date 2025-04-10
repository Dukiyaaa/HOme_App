import { http } from '@kit.NetworkKit'

const BASE_URL = 'http://43.155.36.236:5000'

@Component
export struct LineChart {
  @Prop imageUrl: string = `${BASE_URL}/chart/temperature`
  @State private timestamp: number = Date.now()

  aboutToAppear() {
    console.info('[LineChart] Component aboutToAppear, initializing with timestamp:', this.timestamp)
  }

  build() {
    Column() {
      Image(this.imageUrl + `&t=${this.timestamp}`)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .backgroundColor(Color.White)
        .onError(() => {
          console.error('[Temperature Chart] Failed to load chart image:', this.imageUrl)
        })
        .onComplete(() => {
          console.info('[Temperature Chart] Image loaded successfully with URL:', this.imageUrl + `&t=${this.timestamp}`)
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}