import picker from '@ohos.file.picker'
import cameraPicker from '@ohos.multimedia.cameraPicker';
import camera from '@ohos.multimedia.camera';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Log } from '@abner/log';

@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController
  // 回调函数=> 把子组件数据传递给父组件
  callback: (uri: string) => void = () => {
  }

  // 点击拍照
  async taskPhoto() {
    let mContext = getContext(this) as common.Context;
    try {
      let pickerProfile: cameraPicker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(mContext,
        [cameraPicker.PickerMediaType.PHOTO, cameraPicker.PickerMediaType.VIDEO], pickerProfile);
      console.log("the pick pickerResult is:" + JSON.stringify(pickerResult));
      Log.info(pickerResult.resultUri)
      // 回传
      this.callback(pickerResult.resultUri)

    } catch (error) {
      let err = error as BusinessError;
      console.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  // 选择相册
  selectPhoto() {
    // 选择文件
    const photoSelectOptions = new picker.PhotoSelectOptions()
    photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.maxSelectNumber = 1

    const photoViewPicker = new picker.PhotoViewPicker()
    photoViewPicker.select(photoSelectOptions)
      .then(result => {
        // 得到文件路径
        Log.info(result.photoUris[0])
        //   回传数据
        this.callback(result.photoUris[0])
      })
  }

  build() {
    Column() {
      // 选项列表
      List() {
        ListItem() {
          Text('拍照')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => this.taskPhoto())

        ListItem() {
          Text('从相册选择')
            .fontColor($r('app.color.ec_main_color'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => this.selectPhoto())

        ListItem() {
          Text('取消')
            .fontColor($r('app.color.ec_mid_59'))
            .fontSize($r('app.float.ec_module_title_font_size'))
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
      }
      .width('100%')
      .height('auto')
      .divider({ strokeWidth: 0.5, color: $r('app.color.ec_mid_line') })
      .padding($r('app.float.ec_content_space'))
      .backgroundColor('#fff')
      .borderRadius($r('app.float.ec_normal_radius'))

    }
  }
}
