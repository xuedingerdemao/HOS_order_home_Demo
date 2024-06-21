import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';
import { Log } from '@abner/log';
import abilityAccessCtrl, { PermissionRequestResult, Permissions } from '@ohos.abilityAccessCtrl';
import { common } from '@kit.AbilityKit';
import { access } from '@kit.ConnectivityKit';

class EcBlueAuth {
  /**
   * 1. 检查蓝牙授权检查
   * @param callback  1. 检查蓝牙权限 2. 蓝牙开关=>执行
   */
  async checkBluePermission(callback: () => void) {
    // 1. 获取应用信息=》 tokenID 应用身份标识
    // 额外获取带有metadataArray信息的appInfo
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    try {
      const bundinfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
      Log.info(bundinfo.appInfo.accessTokenId + '')
      //  2. 检查蓝牙授权
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      let permissionName: Permissions = 'ohos.permission.ACCESS_BLUETOOTH';
      let data: abilityAccessCtrl.GrantStatus =
        atManager.checkAccessTokenSync(bundinfo.appInfo.accessTokenId, permissionName);
      if (data === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        Log.error(`用户未授权蓝牙权限：${data}`)
        // 拉起用户授权窗口
        this.reqUserPermission(callback)
        return
      }

      if (!this.isBlueOpen()) {
        AlertDialog.show({
          message: '请打开蓝牙开关！'
        })
        return
      }

      // 满足两个条件：1. 用户授权 2. 蓝牙功能打开
      // Log.info('go')
      callback()

    } catch (err) {
      Log.error(err)
    }
  }

  /**
   * 2. 请求用户授权
   */
  reqUserPermission(callback: () => void) {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    // 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
    let context: Context = getContext(this) as common.UIAbilityContext;
    // 拉取的是蓝牙权限的授权窗口
    atManager.requestPermissionsFromUser(context, ['ohos.permission.ACCESS_BLUETOOTH'],
      (err: BusinessError, data: PermissionRequestResult) => {
        if (err) {
          Log.error(`requestPermissionsFromUser fail, err->${JSON.stringify(err)}`);
        } else {
          // 正常拉起授权窗口=》获取用户操作信息
          Log.info('data:' + JSON.stringify(data));
          if (data.authResults[0] === 0) {
            // 当前授权窗口覆盖拉起授权窗口=》单例
            // AlertDialog.show({
            //   message: '授权'
            // })
            if (this.isBlueOpen()) {
              // Log.info('go')
              callback()
            } else {
              AlertDialog.show({
                message: '请打开蓝牙开关！'
              })
            }
          } else {
            // 未授权
            AlertDialog.show({
              message: '请前往系统页面授权蓝牙权限后，才能继续绑定操作！'
            })
          }
        }
      });
  }

  /**
   * 3. 判断蓝牙功能是否打开
   */
  isBlueOpen() {
    try {
      const state = access.getState()
      if (state === access.BluetoothState.STATE_ON) {
        // 蓝牙打开的
        return true
      } else {
        // 蓝牙关闭的
        return false
      }
    } catch (e) {
      Log.error('ble_demo_log' + e.message)
      return false
    }
  }
}

export const ecBlueAuth = new EcBlueAuth()