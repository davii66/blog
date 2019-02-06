title: "Referrer-Policy与Referrer防盗链"
date: 2019-02-06 20:30:00 +0800
date: 2019-02-06 20:30:00 +0800
author: me
cover: "-/images/referrer.jpg"
tags:
    - HTTP
    - Referrer
    - 防盗链
---

前几天安装NextCloud的时候发现了一个响应头:Referrer-Policy，仔细研究一番后发现他可以让目前流行的referrer防盗链机制几乎失效。这里给个栗子。
<!--more-->
## Demo1
这是QQ空间的图片。抓包可以看到实际上地址相同，唯一的区别是`referrerpolicy="no-referrer"`。
<img style="margin:auto" referrerpolicy="no-referrer" src="http://m.qpic.cn/psb?/46015da3-1d58-4f01-88e1-accc164c4516/gzvOEXqtRJFkCxQZjAPLFUN4FM29KaOKs7Bi1KlabvE!/b/dL8AAAAAAAAA&bo=dwAzAAAAAAADB2Y!&rf=viewer_4">
<img style="margin:auto" src="http://m.qpic.cn/psb?/46015da3-1d58-4f01-88e1-accc164c4516/gzvOEXqtRJFkCxQZjAPLFUN4FM29KaOKs7Bi1KlabvE!/b/dL8AAAAAAAAA&bo=dwAzAAAAAAADB2Y!&rf=viewer_4?abcd">
## Demo2 （流量巨大注意）
这里盗链了一个网盘（个人网盘，看他啥时候倒闭）作为视频播放源。
<br/>
<button onclick="document.getElementById('ys').innerHTML=document.getElementById('ys-b').value">
视频盗链(成功)
</button><button onclick="document.getElementById('ys').innerHTML=document.getElementById('ys-c').value">
视频盗链(失败)
</button>

<textarea style="display:none" id="ys-b"><iframe referrerpolicy="no-referrer" frameborder="0" style="width:330px;height:190px;" src="data:text/html;base64,PG1ldGEgbmFtZT1yZWZlcnJlciBjb250ZW50PW5ldmVyPjx2aWRlbyB3aWR0aD0zMDBweCBjb250cm9scyBzcmM9aHR0cDovL2YuZTEyMy5wdy9mdWNrLXhteXAvZ3VybC5waHA/cGF0aD03NDY0Mjk3My0xLTExMi5tcDQ+PC92aWRlbz4="></iframe></textarea>
<textarea style="display:none" id="ys-c"><video width="300px" referrerpolicy="no-referrer" controls src="http://f.e123.pw/fuck-xmyp/gurl.php?path=74642973-1-112.mp4"></video></textarea>
<div id="ys"></div>

查看源码可以发现，盗链成功的视频位于一个iframe中。iframe的src是dataurl，实际内容是：
```html
<meta name=referrer content=never>
<video width=300px controls src=视频地址></video>
```
## 原理

>Referrer Policy（引用策略）就是从一个文档发出请求时，是否在请求头部定义 Referrer 的设置。

这里就得提到一个HTTP协议中的拼写错误：浏览器发送的请求头是`Referer`，实际上是`Referrer`，HTTP协议中少了一个`r`但是在其他处均已更正。

referrer-policy分为新旧两个标准。IE,Edge,iOS仅支持旧标准，其余大部分浏览器都支持新标准。旧标准通常被向下兼容。

![浏览器支持情况](/images/referrer-caniuse.png)
## 标准

Referrer-Policy本意是保护隐私，<del>并不是破解防盗链</del>。新标准支持以下几个属性:

 - `""`(空字符串，大部分浏览器处理为no-referrer-when-downgrade)
 - `no-referrer` 永不发送
 - `no-referrer-when-downgrade` HTTPS->HTTP不发送
 - `same-origin` 跨域不发送
 - `origin` (只发送origin,协议+域名+端口)
 - `strict-origin` (HTTPS->HTTP不发送，否则发送origin)
 - `origin-when-cross-origin` (跨域只发送origin)
 - `strict-origin-when-cross-origin` (HTTPS->HTTP不发送，跨域只发送origin)
 - `unsafe-url` (全部发送)
 
旧标准支持以下几个属性：

 - `default` 等同于 `""`
 - `never` 等同于 `no-referrer`
 - `always` 等同于 `unsafe-url`

支持的设置方式：

 - 服务端设置header `Referrer-Policy:no-referrer`
 - HTML Head 中放置Meta标签 `<meta name=referrer content=no-referrer>`
 - `<a>` `<img>` `<iframe>`标签（目前已知）支持`referrerpolicy="no-referrer"`属性
 - `<a>`标签还支持`rel="noreferrer"`属性。

>旧标准通常只在Meta标签中被支持。

## 进一步防盗链
可能基于URL的Token防盗链是唯一方案？但好像配合服务端爬虫也可以破解。解决方案仍等待寻找...