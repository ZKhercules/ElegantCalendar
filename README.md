# ElegantCalendar
平滑翻页的优雅日历

也可以不局限于日历，可以使用在任何横向滑动，但是每个cell高度不同的地方

![RPReplay_Final168956 -original-original](https://github.com/ZKhercules/ElegantCalendar/assets/14028942/ff23b23f-dd30-461d-aff2-5a81fff5ee45)

使用UIcollectionview 添加分页横向滑动的方法创建的日历

因每月日期不同，日历的高度要随之变化

在月份滑动结束之后再更新高度，过度会过于生硬

思路创新，在滑动过程中，判断即将要话到的月份高度

首先判断当前UIcollectionview 正在向左滑或是右滑

然后判断即将滑到的月份高度与当前月份高度差

使用 （高度差 / 屏幕宽度 * contentOffset.x） 缓慢增加差值

这里着重说明一下contentOffset.x，本质上每一页滑动时都是希望从 0 ~ 屏幕宽

但是以414屏幕宽距离，从第二页开始再向右滑动时就已经是从414 ~ 828了，这个值如果直接使用越往后越会出现绝大的偏差

所以contentOffset.x在使用时，要减掉已经滑过去的页面的值，保证每一页滑动时都是从0 ~ 屏幕宽

关键代码已在工程中标注

希望可以帮助到你

