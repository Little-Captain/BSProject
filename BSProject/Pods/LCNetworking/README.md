# LCNetworking

[![CI Status](http://img.shields.io/travis/Little-Captain/LCNetworking.svg?style=flat)](https://travis-ci.org/Little-Captain/LCNetworking)
[![Version](https://img.shields.io/cocoapods/v/LCNetworking.svg?style=flat)](http://cocoapods.org/pods/LCNetworking)
[![License](https://img.shields.io/cocoapods/l/LCNetworking.svg?style=flat)](http://cocoapods.org/pods/LCNetworking)
[![Platform](https://img.shields.io/cocoapods/p/LCNetworking.svg?style=flat)](http://cocoapods.org/pods/LCNetworking)

## Requirements

* iOS 7.0+
* OS X 10.0+

## Installation

LCNetworking is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LCNetworking"
```

## Author

Little-Captain, littlecaptain@foxmail.com

## License

LCNetworking is available under the MIT license. See the LICENSE file for more info.

# 中文描述

## 环境要求

* iOS 7.0+
* OS X 10.0+

## 安装

```ruby
pod "LCNetworking"
```

## 问题及解决方案

* 默认的 AFNetworking 存在内存泄漏问题, 本框架采用单例对象解决内存泄漏问题

## 如何使用

* 获取对象

```objc
// 单例对象
[LCHTTPSessionManager sharedInstance];
// 创建非单例对象, 不推荐
[LCHTTPSessionManager manager];
```

* 发送请求 GET/POST 请求

```objc
[[LCHTTPSessionManager sharedInstance] request:...];
```

* 上传文件

```objc
[[LCHTTPSessionManager sharedInstance] upload:...];
```

## 作者

Little-Captain, littlecaptain@foxmail.com

## 版权

查看 LICENSE 文件获取更多信息


