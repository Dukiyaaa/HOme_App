import { http } from '@kit.NetworkKit'

const BASE_URL = 'http://43.155.36.236:5000'

@Component
export struct LineChart {
  @State private imageUrl: string = `${BASE_URL}/chart/temperature`

  build() {
    Column() {
      Image(this.imageUrl)
        .width('100%')
        .height('60%')
        .objectFit(ImageFit.Contain)
        .backgroundColor(Color.White)
        .onError(() => {
          console.error('[Temperature Chart] Failed to load chart image')
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}