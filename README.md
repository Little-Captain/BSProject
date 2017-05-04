# 百思不得姐(学习版)

## 项目介绍

* 一个通过百思不得姐官方开放的接口高仿的项目. 代码风格规范, 注释详尽, 非常适合学习使用.
* 本项目`目前`采用的架构是 `MVC`, `后续`会采用 `MVVM` 和 `VIPER` 架构进行重构.
* 本项目`最后`会采用`组件化`进行重构
* 本项目`目前`采用的语言是 `Objective-C` , `后续`会开发 `Swift` 版本.
* 一个尽最大可能涵盖社交娱乐类 App 所有功能的开源项目

## 实现功能

* `登录注册`模块的界面实现
* `精华`模块和`新帖`模块的内容展示
  * 全部展示和分类展示
  * `音频`和`视频`功能
* `推荐关注`模块的实现
* `发布段子`模块的实现
  * 自定义带`占位文字`的TextView
  * 标签功能的实现
* `我的`模块的实现
  * 使用 WKWebView 实现网页的加载, 实时监控网页加载真实进度
* `设置`模块实现了基本的缓存清理功能
* 实现 App 启动页面的`广告`功能
* 实现`新浪分享`功能
* 集成了`Bugly`

## 即将实现功能...

* `SQLite` 数据库`缓存`功能
* `换肤`功能
* `第三方登录`
* ...

## 第三方框架和技术

* `AFNetworking` : 网络请求
* `YYWebImage` : 图片下载和图片缓存
* `pop` : 动画
* `Masonry` : 自动布局
* `MJRefresh` : 上拉下拉刷新
* `MJExtension` : 字典转模型
* `DACircularProgress` : 进度控件
* `SVProgressHUD` : HUD
* `RXCollections` : Objective-C 函数式编程框架
* 友盟分享
  * UMengUShare/UI : U-Share SDK UI模块（分享面板，建议添加）
  * UMengUShare/Social/WeChat : 微信
  * UMengUShare/Social/Sina : 新浪微博
* `Bugly` : Crash 日志

## 其他

* 如果有 bug 欢迎联系我, 也可以在 github 上 pull request
* e-mail : littlecaptain@foxmail.com
* 项目地址 : https://github.com/Little-Captain/BSProject
