import { Log } from '@abner/log'
import axios, {
  AxiosError,
  AxiosHeaders,
  AxiosResponse,
  InternalAxiosRequestConfig,
  Method,
  RawAxiosRequestHeaders
} from '@ohos/axios'
import { BASE_BRL, RouterConfig } from '../../constants'
import { promptAction, router } from '@kit.ArkUI'
import { TokenStore } from './TokenStore'


//初始化请求实例
const instance = axios.create({
  baseURL: BASE_BRL, //配置基地址
  timeout: 5000    // 请求超时时间
})

/*请求拦截器
 *
 *
*/
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const token = TokenStore.getToken()
  if (token) {
    config.headers.Authorization = token
  }
  return config
}, (err: AxiosError) => {
  return Promise.reject(err)
})


/*
 * 响应拦截器
*/
instance.interceptors.response.use((response: AxiosResponse) => {
  if (response.data?.code && response.data.code !== 200) {
    AlertDialog.show({
      message: response.data?.msg
    })
    Log.error('code请求错误：' + JSON.stringify(response.data))
    promptAction.showToast({ message: '服务器异常' })
    return Promise.reject(response.data)
  }
  return response.data?.data;
}, (error: AxiosError) => {
  if (error.response?.status === 401) {
    promptAction.showToast({ message: '登录超时，请重新登陆' })
    TokenStore.delToken()
    router.replaceUrl({
      url: RouterConfig.LOGIN_URL
    })
    return Promise.reject(error);
  }
  if (error.response?.status === 404) {
    promptAction.showToast({ message: '请求地址错误' })
    return Promise.reject(new Error("请求地址错误"))
  }
  return Promise.reject(error);
});

interface RequestParams<P> {
  url: string
  method?: Method
  params?: P
  data?: P
  headers?: RawAxiosRequestHeaders | AxiosHeaders
  context?: Context
}

function request<D = null, P = null>(requestParams: RequestParams<P>): Promise<D> {
  // 内核instance
  return instance<null, D>(requestParams)
}

export { instance, request }