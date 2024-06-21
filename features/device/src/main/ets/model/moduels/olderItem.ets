// 搜索选择老人
@Observed
export class OldItem {
  index: number = 0
  sel: boolean = false

  constructor(index: number, sel: boolean) {
    this.index = index
    this.sel = sel
  }
}
