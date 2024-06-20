import { request } from '@orderHome/common/basic'
import { MessageCountData } from '../../model'


/**
 * 统计当前护理员的未读消息数量
 * @returns
 */
export const getMessageCountAPI = () => {
  return request<MessageCountData>({ url: '/employee/message/statisticsUnreadByType' })
}
