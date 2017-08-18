title: "hashover系列第二篇：SMTP发邮件"
date: 2017-08-18 21:50:00 +0800
update: 2017-08-18 21:50:00 +0800
author: me
cover: "-/images/hashover.png"
tags:
    - 博客
    - 程序
    - 评论
    - 邮件
    - hashover
---

hashover默认使用mail函数发送邮件，一般情况我们无法收到。因此，我们要引入smtp库解决邮件问题。
<!--more-->
![](/images/hashover.png)
## SMTP发送邮件
>使用的SMTP库的Github地址：[https://github.com/swt83/php-smtp](https://github.com/swt83/php-smtp)。
这个库使用composer安装依赖，改造不方便，可以下载我修改的文件：[>smtp.php.zip<](/attachments/smtp.php.zip)

下载smtp库后，放在hashover的scripts目录下。接下来，修改配置文件`settings.php`，将下面代码放到`public$notificationEmail`之上：

```php
//SMTP Settings
    public $smtp_host    = "smtp.exmail.qq.com";//SMTP服务器
    public $smtp_port    = "465";       //smtp端口
    public $smtp_encrypt = "ssl";       //是否启用加密,null或者'ssl'
    public $smtp_user    = "i@ye4.pw";      //发件邮箱
    public $smtp_pass    = "********";      //密码
    public $smtp_name    = "Weng's Blog";   //博客名称，hashover没提供接口
    public $smtp_sender    = "某翁的信使";  //发信人昵称
    //模板，兼容Wordpress插件Comment Reply Notification。
    public $smtp_title   = "Hi，您在《[postname]》的评论被回复啦！";
    public $smtp_tpl     = <<<EOT
<div style="-moz-border-radius: 5px;-webkit-border-radius: 5px;-khtml-border-radius: 5px;border-radius: 5px;background-color:white;border-top:2px solid #1bb565;box-shadow:0 1px 3px #AAAAAA;line-height:180%;padding:0 15px 12px;width:500px;margin:50px auto;color:#555555;font-family:Century Gothic,Trebuchet MS,Hiragino Sans GB,微软雅黑,Microsoft Yahei,Tahoma,Helvetica,Arial,SimSun,sans-serif;font-size:12px;">
	<h2 style="border-bottom:1px solid #DDD;font-size:14px;font-weight:normal;padding:13px 0 10px 8px;">
	<span style="color: #1bb565;font-weight: bold;">></span>
	您在 <a style="text-decoration:none;color: #1bb565;" href="[blogurl]" target="_blank">[blogname]</a> 博客上的留言有回复啦！</h2>
	<div style="padding:0 12px 0 12px;margin-top:18px">
		<p>亲爱的 [pc_author]， 您好！您曾在文章《[postname]》上发表评论：</p>
		<p style="background-color: #f5f5f5;border: 0px solid #DDD;padding: 10px 15px;margin:18px 0">[pc_comment]</p>
		<p>[cc_author]给您的回复如下：</p>
		<p style="background-color: #f5f5f5;border: 0px solid #DDD;padding: 10px 15px;margin:18px 0">[cc_comment]</p>
		<p>您可以点击<a href="[cc_url]">查看回复的完整内容</a>，欢迎再次光临<a href="[blogurl]">[blogname]</a> 。</p>
	</div>
</div>
EOT;
	//有任何新评论管理员都会收到邮件的模板。
    public $smtp_admin_title   = "[blogname]: 文章《[postname]》有新评论";
    public $smtp_admin_tpl     = <<<EOT
<div style="-moz-border-radius: 5px;-webkit-border-radius: 5px;-khtml-border-radius: 5px;border-radius: 5px;background-color:white;border-top:2px solid #1bb565;box-shadow:0 1px 3px #AAAAAA;line-height:180%;padding:0 15px 12px;width:500px;margin:50px auto;color:#555555;font-family:Century Gothic,Trebuchet MS,Hiragino Sans GB,微软雅黑,Microsoft Yahei,Tahoma,Helvetica,Arial,SimSun,sans-serif;font-size:12px;">
	<h2 style="border-bottom:1px solid #DDD;font-size:14px;font-weight:normal;padding:13px 0 10px 8px;">
	<span style="color: #1bb565;font-weight: bold;">></span>
	文章 <a style="text-decoration:none;color: #1bb565;" href="[cc_url]" target="_blank">[postname]</a> 有新评论啦！</h2>
	<div style="padding:0 12px 0 12px;margin-top:18px">
		<p>[cc_author] 说：</p>
		<p style="background-color: #f5f5f5;border: 0px solid #DDD;padding: 10px 15px;margin:18px 0">[cc_comment]</p>
	</div>
</div>
EOT;
```
随后，打开`writecomments.php`，找到`writeComment`函数，将其中两处和下面一样的代码注释掉。（防止回复者邮箱被发给被回复者）
```php
$from_line .= ' <' . $this->email . '>';
```
找到第一个`mail`函数，注释掉，并在下方加上smtp发送代码：
```php
//mail ($reply_email, $this->setup->domain . ' - New Reply', $reply_message, $this->userHeaders);
//被注释掉的mail函数
$urls=parse_url($this->setup->pageURL);
$smtp_config=array(
    'debug_mode' => false,
    'default' => 'primary',
    'connections' => [
        'primary' => [
        'host' => $this->setup->smtp_host,
        'port' => $this->setup->smtp_port,
        'secure' => $this->setup->smtp_encrypt,
        'auth' => true,
        'user' => $this->setup->smtp_user,
        'pass' => $this->setup->smtp_pass,
        ],
    ],
    'localhost' => $this->setup->domain,
);
$mail=new smtp($smtp_config);
$mail->to($reply_email);
$mail->from($this->setup->smtp_user,$this->setup->smtp_sender);
$mail->subject(str_replace(array(
    "[blogname]",
    "[blogurl]",
    "[postname]",
    "[pc_date]",
    "[pc_comment]",
    "[pc_author]",
    "[cc_date]",
    "[cc_comment]",
    "[cc_author]",
    "[cc_url]"
),array(
    $this->setup->smtp_name,
    $urls["sheme"]."://".$urls["host"].isset($parsed_url['port']) ? ':' . $parsed_url['port'] : '',
    html_entity_decode($this->setup->pageTitle),
    $reply_comment['date'],
    $reply_comment['body'],
    $reply_name,
    $this->commentData['date'],
    $this->commentData['body'],
    $from_line,
    $this->setup->pageURL. '#' . $permalink
),$this->setup->smtp_title));
$mail->body(str_replace(array(
    "[blogname]",
    "[blogurl]",
    "[postname]",
    "[pc_date]",
    "[pc_comment]",
    "[pc_author]",
    "[cc_date]",
    "[cc_comment]",
    "[cc_author]",
    "[cc_url]"
),array(
    $this->setup->smtp_name,
    $urls["sheme"]."://".$urls["host"].isset($parsed_url['port']) ? ':' . $parsed_url['port'] : '',
    $this->setup->pageTitle,
    $reply_comment['date'],
    $reply_comment['body'],
    $reply_name,
    $this->commentData['date'],
    $this->commentData['body'],
    $from_line,
    $this->setup->pageURL. '#' . $permalink
),$this->setup->smtp_tpl));
$result = $mail->send();
```
再往下找到第二个mail函数，注释，加上提醒管理员的代码：
```php
//mail ($this->setup->notificationEmail, 'New Comment', $webmaster_message, $this->headers);$urls=parse_url($this->setup->pageURL);
//被注释掉的mail函数
$smtp_config=array(
    'debug_mode' => false,
    'default' => 'primary',
    'connections' => [
        'primary' => [
            'host' => $this->setup->smtp_host,
            'port' => $this->setup->smtp_port,
            'secure' => $this->setup->smtp_encrypt,
            'auth' => true,
            'user' => $this->setup->smtp_user,
            'pass' => $this->setup->smtp_pass,
        ],
    ],
    'localhost' => $this->setup->domain,
);
$mail=new smtp($smtp_config);
$mail->to($this->setup->notificationEmail);
$mail->from($this->setup->smtp_user,$this->setup->smtp_sender);
$mail->subject(str_replace(array(
    "[blogname]",
    "[blogurl]",
    "[postname]",
    "[cc_date]",
    "[cc_comment]",
    "[cc_author]",
    "[cc_url]"
),array(
    $this->setup->smtp_name,
    $urls["sheme"]."://".$urls["host"].isset($parsed_url['port']) ? ':' . $parsed_url['port'] : '',
    html_entity_decode($this->setup->pageTitle),
    $this->commentData['date'],
    $this->commentData['body'],
    $from_line,
    $this->setup->pageURL. '#' . $permalink
),$this->setup->smtp_admin_title));
$mail->body(str_replace(array(
    "[blogname]",
    "[blogurl]",
    "[postname]",
    "[cc_date]",
    "[cc_comment]",
    "[cc_author]",
    "[cc_url]"
),array(
    $this->setup->smtp_name,
    $urls["sheme"]."://".$urls["host"].isset($parsed_url['port']) ? ':' . $parsed_url['port'] : '',
    html_entity_decode($this->setup->pageTitle),
    $this->commentData['date'],
    $this->commentData['body'],
    $from_line,
    $this->setup->pageURL. '#' . $permalink
),$this->setup->smtp_admin_tpl));
$result = $mail->send();
```
保存，接下来应该就能收到邮件了。注意，自己回自己不会发送。

>本博客已修改，可就地评论体验效果。不过因测试导致发送大量邮件，本博客使用的邮箱被qq邮箱拦截，截止发布本文时尚未恢复，并不代表该功能失效。

### 懒人包（`smtp.php+writecomments.php`）：[>hashover-smtp.zip<](/attachments/hashover-smtp-pack.zip)

## 几个魔改想法（List）：
* （完成）  完善邮件功能
* （准备写文章）加上表情包
* （实现中）加上显示地区和UA
* （不可能）加上评论等级
* （实现中）在不启用密码的情况下做评论管理

如果真能实现，这个系统就万能了（才不是呢）。