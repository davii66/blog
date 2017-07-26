title: "使用&魔改hashover评论系统"
date: 2017-07-26 20:30:00 +0800
update: 2017-07-26 20:30:00 +0800
author: me
cover: "-/images/hashover.png"
tags:
    - 博客
    - 程序
    - 评论
---

第三方评论的战场上，多说倒下了，云跟帖倒下了，disqus连接受阻，剩下搜狐畅言和几个小平台摇摇欲坠...
无论如何，这时候还是自建评论系统最可靠。这里要讲的就是目前比较成熟的hashover。
<!--more-->
![](/images/hashover.png)
## 下载&安装
>Github地址：[https://github.com/jacobwb/hashover-next](https://github.com/jacobwb/hashover-next)

直接打包下载解压到服务器即可。随后，按照里面的提示修改`hashover/scripts/settings.php`，即可直接使用。

## 探坑
虽然现在hashover已经可以正常运行，但其实还存在有很多坑。下面是我踩到的部分。

### PDO错误
在选择mysql并填好数据库信息后出现了这样的错误提示：`HashOver:PDO.php file could not be included!`，
原因是某个地方PDO类忘了加根命名空间。目前这个问题已经有人提交了PR，官方合并之前我们可以自己先改一下。

`hashover/scripts/parsesql.php`
```php
Line 76  在PDO前面加上“\”
$fetchAll = $results->fetchAll (\PDO::FETCH_NUM);

Line 111 同理
return (array) $result->fetch (\PDO::FETCH_ASSOC);
```
### AJAX跨域问题
当在配置文件启用ajax模式的时候，你会发现所有请求全部失败了。
因为hashover并没有对跨域访问进行处理（加cors头），所以请求被浏览器拦截。

可在`hashover/scripts/settings.php`顶部加入代码或者用Nginx/apache进行配置。
```php
header("Access-Control-Allow-Origin:".(isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:"*"));
header("Access-Control-Allow-Credentials:true");
```
### 不保存用户信息问题
前文说过hashover并没有对跨域访问进行处理，所以只加cors头无法保存cookies。
解决方法是在`hashover/scripts/javascript-mode.php`中查找`XMLHttpRequest`
并给所有的XHR对象全部加上`withCredentials=true`。
## 美化（魔改）
HashOver提供一个主题机制，可以在`hashover/themes`各个主题的文件夹中修改`layout.html`和`style.css`来自定义样式。
具体魔改例子可看本站评论区，也可自己下载本站CSS。
### 几个魔改想法（尚未实现）：
* 加上表情包
* 加上显示地区和UA
* 加上评论等级
* 在不启用密码的情况下做评论管理
* 魔改成弹幕系统的后端

如果真能实现，这个系统就万能了（才不是呢）。