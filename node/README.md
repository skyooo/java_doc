# 知识点整理


1. Http2.0 头部压缩，服务端推送，单一长连接，多路复用等 
> 长连接:  
HTTP 1.1支持长连接（PersistentConnection）和请求的流水线（Pipelining）处理，在一个TCP连接上可以传送多个HTTP请求和响应，减少了建立和关闭连接的消耗和延迟，在HTTP1.1中默认开启Connection： keep-alive，一定程度上弥补了HTTP1.0每次请求都要创建连接的缺点。
>
> 多路复用:  
允许同时通过单一的 HTTP/2 连接发起多重的请求-响应消息。有了新的分帧机制后，HTTP/2 不再依赖多个TCP 连接去实现多流并行了。每个数据流都拆分成很多互不依赖的帧，而这些帧可以交错（乱序发送），还可以分优先级。最后再在另一端把它们重新组合起来。HTTP 2.0 连接都是持久化的，而且客户端与服务器之间也只需要一个连接（每个域名一个连接）即可。
> 
> 服务端推送  
>- 服务器可以对一个客户端请求发送多个响应。服务器向客户端推送资源无需客户端明确地请求。
>- HTTP 2.0 连接后，客户端与服务器交换SETTINGS 帧，借此可以限定双向并发的流的最大数量。
>- 所有推送的资源都遵守同源策略。换句话说，服务器不能随便将第三方资源推送给客户端，而必须是经过双方确认才行。  
服务器必须遵循请求- 响应的循环，只能借着对请求的响应推送资源
>
> 服务器推送到底是什么:  
服务端推送能把客户端所需要的资源伴随着index.html一起发送到客户端，省去了客户端重复请求的步骤。正因为没有发起请求，建立连接等操作，所以静态资源通过服务端推送的方式可以极大地提升速度。  
>
> header压缩:  
HTTP1.x的header带有大量信息，而且每次都要重复发送，HTTP/2使用encoder来减少需要传输的header大小，通讯双方各自cache一份header fields表，既避免了重复header的传输，又减小了需要传输的大小。
>

2. https 和 http 区别
>HTTPS和HTTP的区别主要如下：
>- https协议需要到ca申请证书，一般免费证书较少，因而需要一定费用。
>- http是超文本传输协议，信息是明文传输，https则是具有安全性的ssl加密传输协议。
>- http和https使用的是完全不同的连接方式，用的端口也不一样，前者是80，后者是443。
>- http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全。
>

3. 跨域的几种方法，以及什么是跨域 [Reference](http://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html)
> 跨域方法:
> 1. jsonp跨域：在js中，我们直接用XMLHttpRequest请求不同域上的数据时，是不可以的。但是，在页面上引入不同域上的js脚本文件却是可以的，jsonp正是利用这个特性来实现的。
> 2. 修改document.domain跨子域：document.domain的设置是有限制的，我们只能把document.domain设置成自身或更高一级的父域，且主域必须相同。例如：a.b.example.com 中某个文档的document.domain 可以设成a.b.example.com、b.example.com 、example.com中的任意一个，但是不可以设成 c.a.b.example.com,因为这是当前域的子域，也不可以设成baidu.com,因为主域已经不相同了。
> 3. window.name跨域：window.name的值只能是字符串的形式，大小约2M，根据浏览器不同。通过一个隐藏的代理iframe来跨域。
> 4. H5的window.postMessage跨域：window.onmessage = function(data) {}
> 5. 图片ping：常用于跟踪用户点击页面或动态广告曝光次数，但只能发送单向请求。
> 6. WebSocket：`WebSocket` 是 HTML5 开始提供的一种在单个 TCP 连接上进行全双工通讯的协议。基于多线程或多进程的服务器无法适用于 WebSockets，WebSockets 服务器端实现都需要一个异步服务器。Node 实现：Socket.IO
>
> 
>
>
>
> 同源：指域名，协议，端口均相同。两个域名之间不能跨过域名来发送请求或者请求数据，否则就是不安全的，这种不安全也就是CSRF（Cross-site request forgery），中文名称：跨站请求伪造，也被称为：one click attack/session riding，缩写为：CSRF/XSRF。
> xss：跨站脚本攻击(Cross Site Scripting) 恶意攻击者往Web页面里插入恶意Script代码，当用户浏览该页之时，嵌入其中Web里面的Script代码会被执行，从而达到恶意攻击用户的目的。  

4. Arrays.sort实现原理和Collections.sort实现原理
> Collections.sort方法底层会调用Arrays.sort方法，底层实现都是TimeSort实现的。TimSort算法就是找到已经排好序数据的子序列，然后对剩余部分排序，然后合并起来

5.反射中，Class.forName和ClassLoader区别
> 分析 Class.forName()和ClassLoader.loadClass
~~~
 Class.forName(className)方法，内部实际调用的方法是  Class.forName(className,true,classloader);
 第2个boolean参数表示类是否需要初始化，  Class.forName(className)默认是需要初始化。
 一旦初始化，就会触发目标对象的 static块代码执行，static参数也也会被再次初始化。
 
 ClassLoader.loadClass(className)方法，内部实际调用的方法是  ClassLoader.loadClass(className,false);
 第2个 boolean参数，表示目标对象是否进行链接，false表示不进行链接，由上面介绍可以，
 不进行链接意味着不进行包括初始化等一些列步骤，那么静态块和静态对象就不会得到执行
~~~
