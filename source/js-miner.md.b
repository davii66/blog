title: "JS挖矿替代广告：CoinHive&ProjectPoi"
date: 2017-10-05 23:00:00 +0800
update: 2017-10-05 23:00:00 +0800
author: me
cover: "-/images/js-miner.png"
tags:
    - JS
    - 赚钱
---
之前看到一则新闻说海盗湾在网站上挂了挖矿“病毒”，于是去研究了一番，发现其实是一个用js挖矿代替广告和验证码的服务。
这项服务的提供商是国外公司CoinHive，当然还有一个国内“仿品” ProjectPoi。
<!--more-->
![](/images/js-miner.png)
## 挖矿验证码
通过挖矿让爬虫付出更多的算力，以防止恶意爬虫。
不过手机用户估计会很痛苦，我用手机登录coinhive的时候挖了三分钟...电脑倒是还好。
![coinhive captcha在某网站的应用](/images/coinhive-captcha.png)
## 挖矿短网址
继adfly广告短网址之后又一钻钱短网址方式，不过手机...

CoinHive官方提供了短网址服务，ProjectPoi没有提供，不过自建一个也还是挺容易的。
![coinhive短网址界面](/images/coinhive_shorturl.png)

> 这里是[CoinHive短网址示例（目标是本站）](https://cnhv.co/32k6) 和 [ProjectPoi短网址示例（自建）](http://r.e123.pw/1)，可以戳一下支持我

## 币种&付款
这两个平台挖的都是XMR门罗币，因为XMR可以用CPU挖。据称效率是普通挖矿程序的65%...

CoinHive是0.5XMR付款，抽30%;ProjectPoi是0.3XMR起付，抽10%。明显感觉后者更好，但是后者能撑多久是个迷...

## 链接

> [CoinHive coinhive.com](https://coinhive.com)

> [ProjectPoi ppoi.org](https://ppoi.org)

## 演示（支持我）
> [CoinHive短网址示例](https://cnhv.co/32k6) 和 
[ProjectPoi短网址示例](http://r.e123.pw/wkuang)

做个按钮是为了防止直接被报毒，现在各大国内杀软都把这个当病毒，甚至屏蔽人家的验证码...
以下演示用的都是projectpoi，（感觉上）速度比较快吧。coinhive样子和他完全相同，毕竟仿品...

当然各位也可以挖一下支持我
<br/>
<button onclick="this.style.display='none';document.getElementById('ys').innerHTML=document.getElementById('ys-c').value">点这里开启验证码&广告位的演示</button>
<textarea style="display:none" id="ys-c">
<li style="float:left">挖矿广告位<br/>
<iframe style="width: 256px; height: 230px;" frameborder="0" src="https://ppoi.org/media/miner.html?key=aW6lO8Xn2o3wA3xemePxdcHN&user=&whitelabel=0&autostart=0&throttle=&threads=auto&background=fafafa&text=000&action=1e9ee0&graph=1e9ee0"></iframe></li>
<li style="float:left">挖矿验证码<br/>
<iframe src="https://ppoi.org/captcha/?goal=512&amp;key=aW6lO8Xn2o3wA3xemePxdcHN&amp;autostart=0&amp;whitelabel=0" style="width: 304px; height: 76px; border: none;"></iframe>
</li>
<div style="clear:both;height:0;overflow:hidden;"></div>
</textarea>
<div id="ys"></div>
