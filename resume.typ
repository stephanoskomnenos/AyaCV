#import "ayacv.typ": ayacv, entry, simple-entry, dated-items, double-item, contact

#show: ayacv.with(
  name: "射命丸 文",
  title: "Syameimaru Aya",
  phone: "(+86) 188 8888 8888",
  email: "syameimaru@aya.com",
  extra: [虽说是鸦天狗, 外表和人类并无太大差别.],
  intent: [求职意向: 新闻记者],
  // 配色：purple / blue / black / burgundy / green / grey / orange / red
  // 也可以传入 rgb("#336699") 等自定义颜色。
  color: "purple",
  // 图标名称见 https://icons.getbootstrap.com/
  // 新增联系方式时填写图标名、内容和链接，例如：
  // contacts: (contact("github", [用户名], href: "https://github.com/用户名"),),
  // 取消下面的注释可更换字体、字号和间距。
  // body-size：正文字号；leading：行间空白；tracking：额外字距。
  // font: ("Times New Roman", "Source Han Serif"),
  // emphasis-font: ("Times New Roman", "方正楷体_GBK"),
  // style: (body-size: 11pt, leading: 8.5pt, tracking: 0pt),
)

= 教育背景

#entry([妖怪之山大学], [新闻学], when: [2016–2021], degree: [博士],
  detail: [虽然发了很多论文, 但不知道学了什么],
  body: [导师: 饭纲丸龙],
)
#entry([人间之里大学], [新闻学], when: [2013–2016], degree: [本科],
  detail: [虽然每门课程满绩, 但不知道学了什么],
)

= 弹幕射击游戏

#entry([东方地灵殿], [自机], when: [2008/05–至今], degree: [支援博丽灵梦], body: [
  住在山上的天狗新闻记者.
  因为发觉山上的神和河童似乎在偷偷摸摸搞些什么而潜入调查之后, 发现答案在地底世界.
  考虑到如果能采访到有价值的新闻写成报道应该能一口气提升出版量, 而利用了灵梦.
  因为对于天狗来说进入地底这种事情是必须尽量避免的.
])
#entry([东方天空璋], [自机], when: [2017/05–至今], degree: [飞散红叶的天狗],
  detail: [代表四季中的秋天], items: (
    [正在各地进行取材, 因此最先注意到了气候的异常.],
    [不只是单纯的凉夏和酷暑, 这一切的原因都被隐藏了起来.],
    [她觉得这样的异常状况是人为所致, 究竟这个直觉能不能猜中呢.],
  ),
)

= 格斗游戏

#simple-entry([东方绯想天], [
  她的思维能力极高, 先不问这是否就是事实, 她思考问题的速度绝对是普通人的好几倍.
  想要预测出她的想法是很困难的.
  除此之外, 文总是在表面上迎合着对方的思考速度, 所以在一起的人总会感觉很不舒服.
  她虽然并不喜欢战斗, 但却喜欢到处寻衅滋事.
  可是因为根本不是她的对手, 所以肯接受挑衅的人少之又少.
], when: [2007/05–至今])

= 符卡

#dated-items(
  ([风神「风神木叶隐身术」], [东方风神录]),
  ([「幻想风靡」], [东方风神录]),
  ([「无双风神」], [东方风神录]),
  ([取材「射命丸文的暴力取材」], [东方文花帖]),
  ([风符「天狗暴风雨」], [东方天空璋]),
)

= 主题曲

#double-item([风神少女], [妖怪之山 Mysterious Mountain])
