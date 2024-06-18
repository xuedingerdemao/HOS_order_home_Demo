import { Context } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'
import { TOKEN_KE, TOKEN_STORE } from '../../constants'

export class TokenStore {
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  //初始化
  initTokenStore() {
    return preferences.getPreferencesSync(this.context, { name: TOKEN_STORE })

  }


  //存token
  async setToken(token: string) {
    const store = this.initTokenStore()
    store.putSync(TOKEN_KE, token)
    await store.flush()
  }

  //取token
  async getToken() {
    const store = this.initTokenStore()
    return store.getSync(TOKEN_KE, '') as string
  }

  //删除token
  async delToken() {
    const store = this.initTokenStore()
    store.deleteSync(TOKEN_KE)
    await store.flush()
  }
}

