title: "移植无损压图工具LimitPNG到web端"
date: 2017-07-29 20:50:00 +0800
update: 2017-07-29 20:50:00 +0800
author: me
cover: "-/images/limitpng.png"
tags:
    - 作品
    - 工具
---
>[limitPNG](http://nullice.com/limitPNG/) 支持无损压缩和有损压缩两种压缩方式，其中无损压缩是不损失任何画质的压缩方法，与有损压缩相比（如 tinypng），虽然体积没优势，但是在对品质有要求的生产环境中不改变原图任何一个像素是必须的。

增加Web版本后，使用更加简便。
<!--more-->
![](/images/limitpng.png)
[limitPNG](http://nullice.com/limitPNG/)原版使用的是`Electron`，这也就意味着原版代码只要去掉UI部分并暴露API接口就可以在NodeJS环境下运行。前端代码使用`Vue`，将打开文件的函数更换为`Webuploader`并将处理部分及其回调函数更改为API调用。

>Github开源地址：[https://github.com/homeii/limitpng-online](https://github.com/homeii/limitpng-online)

### 附录：limit极限无损压图算法
非常的简单...其他算法可在`limitpng.js`中获得
```shell
TruePNG  文件名
pngout  文件名
pngwolf --in=文件名 --out=文件名
zopflipng -m -y 文件名  文件名
```