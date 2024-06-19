import promptAction from '@ohos.promptAction'

@Component
export struct EcList {
  sticky: StickyStyle = StickyStyle.None
  // 是否自动加载
  @Prop
  autoLoad: boolean = true
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive
  // 文字提示
  loadingText: string = '加载中...'
  finishedText: string = '没有更多了~'
  gutter: number = 10
  // 加载中loading
  @Prop
  loading: boolean = false
  // 是否加载完成
  @Prop
  finished: boolean = false
  // 刷新中
  // 双向绑定
  @Link
  isRefreshing: boolean
  // 列表数据
  @BuilderParam
  listContent: () => void = this.DefaultListContent

  // 默认Builder
  @Builder
  DefaultListContent() {
    ListItem() {
      Text('列表...')
    }
  }

  // 触底加载数据
  load: () => void = () => {
  }
  // 刷新列表
  refresh: () => void = () => {
  }

  // 加载交互
  @Builder
  LoadingBuilder() {
    if (this.finished) {
      Row() {
        Text(this.finishedText)
          .fontColor($r('app.color.yk_mid_99'))
          .fontSize($r('app.float.yk_normal_font_size'))
      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.Center)
    } else {
      if (this.loading) {
        Row() {
          LoadingProgress()
            .width(24)
            .margin({ right: 5 })
          Text(this.loadingText)
            .fontColor($r('app.color.yk_mid_59'))
            .fontSize($r('app.float.yk_normal_font_size'))
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
    }
  }

  refreshStatusTxt() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '下拉刷新'
      case RefreshStatus.OverDrag:
        return '释放刷新'
      case RefreshStatus.Refresh:
        return '刷新中...'
      default:
        return ''
    }
  }

  @Builder
  RefreshBuilder() {
    Row() {
      Progress({ value: 0, total: 100, type: ProgressType.Ring })
        .width(20)
        .color($r('app.color.yk_main_color'))
        .style({
          strokeWidth: 20,
          status: this.refreshStatus === RefreshStatus.Refresh ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING
        })
        .margin({ right: 10 })
      Text(this.refreshStatusTxt())
        .fontColor($r('app.color.yk_mid_59'))
        .fontSize($r('app.float.yk_normal_font_size'))
    }
    .margin(30)
  }

  // aboutToAppear() {
  //   this.autoLoad && this.load()
  // }

  build() {
    // 下拉刷新，上拉加载
    Column() {
      // list
      // Refresh({ refreshing: $$this.isRefreshing }) {
      Refresh({ refreshing: $$this.isRefreshing, builder: this.RefreshBuilder() }) {
        List({ space: this.gutter }) {
          // 列表
          this.listContent()
          // 加载状态
          if (this.refreshStatus !== RefreshStatus.Refresh) {
            ListItem() {
              this.LoadingBuilder()
            }
          }
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .sticky(this.sticky)
        // .padding({ left: 15, right: 15 })
        .onReachEnd(() => {
          this.autoLoad && this.load()
        })
      }
      // 下拉刷新状态
      .onStateChange((refreshStatus: RefreshStatus) => {
        this.refreshStatus = refreshStatus
        console.info('Refresh onStatueChange state is ' + refreshStatus)
        if (refreshStatus === RefreshStatus.Done) {
          promptAction.showToast({
            message: '刷新成功'
          })
        }
      })
      .onRefreshing(() => {
        this.refresh()
      })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .layoutWeight(1)
  }
}