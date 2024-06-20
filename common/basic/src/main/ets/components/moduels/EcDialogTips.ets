class ButtonConfig {
  text: string = '我知道了'
  color?: ResourceStr = ''
  cb?: () => void = () => {
  }
}

/**
 *
 * @param title:标题
 * @param tipsContent:提示的Builder -->
 * @param confirmButton(ButtonConfig)：确认按钮
 * @param cancelButton(ButtonConfig)：取消按钮
 * @class ButtonConfig {
 text: string = '我知道了'
 color?: ResourceStr = ''
 cb?: () => void = () => {
 }
 }
 */
@Preview
@CustomDialog
export struct EcDialogTips {
  // 提示标题
  title: string = '提示'
  titleAlign: 'start' | 'center' = 'start'
  // 列表数据
  @BuilderParam
  tipsContent: () => void = this.DefaultTipsContent
  // 按钮配置
  // 确定
  confirmButton: ButtonConfig | null = null
  // 取消
  cancelButton: ButtonConfig | null = null
  // 控制器
  controller: CustomDialogController

  // 默认Builder
  @Builder
  DefaultTipsContent() {
    Text('默认提示！')
  }

  build() {
    Column() {
      //  1. 标题
      Row() {
        Text(this.title)
          .fontColor($r('app.color.yk_mid_19'))
          .fontSize(18)
          .fontWeight(500)
      }
      .width('100%')
      .justifyContent(this.titleAlign === 'start' ? FlexAlign.Start : FlexAlign.Center)
      .padding({ left: 18, right: 18 })
      .height(56)

      // 2. 提示内容
      this.tipsContent()

      // 分割线
      Divider()
        .color($r('app.color.yk_mid_line'))
        .margin({ left: 15, right: 15 })
      // 按钮
      Row() {
        // 取消
        Button(this.cancelButton?.text)
          .onClick(() => {
            // this.controller.close()
            this.cancelButton?.cb && this.cancelButton?.cb()
          })
          .fontSize($r('app.float.yk_module_title_font_size'))
          .backgroundColor('transparent')
          .fontColor(this.cancelButton?.color || $r('app.color.yk_mid_59'))
        // 确定
        if (this.confirmButton?.text) {
          Divider()
            .vertical(true)
            .height(24)
            .color($r('app.color.yk_mid_99'))

          Button(this.confirmButton?.text)
            .onClick(() => {
              // this.controller.close()
              this.confirmButton?.cb && this.confirmButton?.cb()
            })
            .fontSize($r('app.float.yk_module_title_font_size'))
            .backgroundColor('transparent')
            .fontColor(this.confirmButton?.color || $r('app.color.yk_main_color'))
        }
      }
      .width('100%')
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .backgroundColor(null)
    .linearGradient(null)
  }
}
