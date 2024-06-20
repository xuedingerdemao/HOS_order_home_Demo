/**
 * 全屏 loading 提示
 * @param tips 提示文案
 * @param icon 图片
 * @param wd 宽
 * @param ht 高
 * @param animate 是否开启图片旋转动画，默认false
 * @param angle 旋转角度
 */
@Component
@CustomDialog
export struct EcLoading {
  @Prop
  tip: string = '正在加载中...'
  @Prop
  icon: ResourceStr = $r('app.media.page_loading')
  wd: number = 65
  ht: number = 20
  // 是否开启图片旋转动画
  @Prop
  animate: boolean = false
  @State
  angle: number = 0
  controller: CustomDialogController

  aboutToAppear(): void {
    this.animate && setTimeout(() => {
      this.angle = 360
    })

  }

  build() {
    Column() {
      Image(this.icon)
        .width(this.wd)
        .height(this.ht)
        .rotate({ angle: this.angle })
        .animation({
          delay: 200,
          duration: 2000,
          iterations: -1,
          curve: Curve.FastOutSlowIn
        })
      Text(this.tip)
        .fontSize($r('app.float.yk_module_title_font_size'))// .fontColor($r('app.color.yk_mid_99'))
        .fontColor('#fff')
        .fontWeight(500)
        .margin({ top: 18 })
    }
    .width(160)
    .height(160)
    .justifyContent(FlexAlign.Center)
    .borderRadius(24)
    .backgroundColor('rgba(0,0,0,0.3)')
  }
}