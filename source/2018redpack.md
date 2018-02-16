title: "只是一个红包而已"
date: 2017-02-16 18:00:00 +0800
update: 2017-02-16 18:00:00 +0800
author: me
cover: "-/images/redpack.png"
tags:
    - 个人
---
你有一个红包等待领取。
<!--more-->
仿了一下之前某大佬用加密算法发红包的形式，看看有没人领（应该没有。用JS填空即可，其实类似的网上搜得到（透题）。

解密后会得到8位ZFB红包口令

```js
var encodedBase64=['iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAAgUlEQVQYV2N8snfBf8YvTxmYLhsyMCq/Zfj7QJyBUew1A+OTXW3/uZl+M0hrcTLMYDRgYPh3ieExgy4D46anU/9/5lJn+PWNmYGH8SjDD0ZJhrv/fjAwdnHZ/Z8WwMGg9Pgzw+cfDAyMf74zML7nYWBUUFD4/+DBA0YGNIAhAJMHAAzQKtvXraUfAAAAAElFTkSuQmCC','ZGF0YTppbWFnZS9wbmc7YmFzZTY0LA=='];
var img=new Image();
img.onload=function(){
	var c=document.createElement("______");
	c.width = img.width;  
	c.height = img.height;  
	$____=c.__________("2d");  
	$____._________(img, 0, 0);  
	var $$_________ = $____.getImageData(0, 0, c.width, c.height);
	var buffer = [];  
	for ($$__________,__________________________;____) {  
		if (_ % 4 == 3) continue; 
		if (!$$_________.____[_]) break;  
		buffer.push(String.____________($$__________.____[_]));  
	}  
	console.log("Decoded Data:\r\n"+decodeURIComponent(escape(buffer.join("__"))));
}
img.src=atob(encodedBase64[1])+encodedBase64[0];
/*	Tips:
	1.不需要任何外部库
	2.需要填字符串的地方都有包引号
	3.下划线和要填写的代码宽度 基 本 一 致 ，甚至会更长。
	4.charset=utf-8;建议直接用Chrome F12运行
	5.$__和$$______都是变量，由于js特性你甚至可以不去管它
	6.解密后会得到8位ZFB红包口令。
*/
```
