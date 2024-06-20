import { Context } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'
import { TOKEN_KEY, TOKEN_STORE } from '../../constants'

export class TokenStore {
  static context: Context

  //初始化
  static initTokenStore() {
    return preferences.getPreferencesSync(TokenStore.context || getContext(), { name: TOKEN_STORE })

  }


  //存token
  static async setToken(token: string) {
    const store = TokenStore.initTokenStore()
    store.putSync(TOKEN_KEY, token)
    await store.flush()
  }

  //取token
  static getToken() {
    const store = TokenStore.initTokenStore()
    return store.getSync(TOKEN_KEY, '') as string
  }

  //删除token
  static async delToken() {
    const store = TokenStore.initTokenStore()
    store.deleteSync(TOKEN_KEY)
    await store.flush()
  }
}

