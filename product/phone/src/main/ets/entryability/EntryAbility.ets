import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Log } from '@abner/log'
import dayjs from 'dayjs';
import 'dayjs/locale/zh-cn'
import { AdvSettingStore, ADV_WIN, getAdvAPI, RouterConfig, TokenStore, TOKEN_KEY } from '@orderHome/common/basic';

// 设置语言为中文
dayjs.locale('zh-cn');


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    TokenStore.context = this.context
    const advStore = new AdvSettingStore(this.context)

    // 设置全屏 沉浸式
    const win = windowStage.getMainWindowSync()
    win.setWindowLayoutFullScreen(true)
    const topHeight = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
    const bottomHeight = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height
    AppStorage.setOrCreate("topHeight", px2vp(topHeight))
    AppStorage.setOrCreate("bottomHeight", px2vp(bottomHeight))

    //加载广告
    const resAdv = await getAdvAPI()
    await advStore.setAdvStore(resAdv) // 写入首选项
    //如果有创建广告窗口
    if (resAdv.showAd) {
      const win = await windowStage.createSubWindow(ADV_WIN)
      //展示窗口
      await win.showWindow()
      //展示广告窗口
      win.setUIContent(RouterConfig.SPLASH_URL)
    }
    const token = TokenStore.getToken()
    //设置token首选项
    AppStorage.setOrCreate(TOKEN_KEY, token)
    if (token) {
      windowStage.loadContent('pages/Index', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      });
    } else {
      windowStage.loadContent(RouterConfig.LOGIN_URL)
    }


  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
