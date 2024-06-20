import { preferences } from '@kit.ArkData'
import { USER_KEY, USER_STORE } from '../../constants'
import { UserData } from '../../models'


export class UserStore {
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  initUserStore() {
    return preferences.getPreferencesSync(this.context, { name: USER_STORE })

  }

  async setUserInfo(data: UserData) {
    const store = this.initUserStore()
    store.putSync(USER_KEY, JSON.stringify(data))
    await store.flush()
  }


  getUserInfo() {
    const store = this.initUserStore()
    return JSON.parse(store.getSync(USER_KEY, '{}') as string) as UserData
  }

  async delUserInfo() {
    const store = this.initUserStore()
    store.deleteSync(USER_KEY)
    await store.flush()
  }
}