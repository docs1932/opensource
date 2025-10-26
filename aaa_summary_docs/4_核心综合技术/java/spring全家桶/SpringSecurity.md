#1.


#2.Oauth2
```
第三方认证技术方案最主要是解决认证协议的通用标准问题，因为要实现跨系统认证，各系统之间要遵循一定的接口协议。

OAUTH协议为用户资源的授权提供了一个安全的、开放而又简易的标准。
同时，任何第三方都可以使用OAUTH认证服务，任何服务提供商都可以实现自身的OAUTH认证服务，因而OAUTH是开放的。
业界提供了OAUTH的多种实现如PHP、JavaScript，Java，Ruby等各种语言开发包，大大节约了程序员的时间，因而OUTH是简易的。
互联网很多服务如Open APl，很多大公司如Google，Yahoo，Microsoft等都提供了OAUTH认证服务，
这些都足以说明OAUTH标准逐渐成为开放资源授权的标准。

Oauth协议目前发展到2.0版本，1.0版本过于复杂，2.0版本已得到广泛应用。
```

## 2.1 认证流程
```
1.客户端
本身不存储资源，需要通过资源拥有者的授权去请求资源服务器的资源，
比如: Android客户端、Web客户端(浏览器端)、微信客户端等。

2.资源拥有者
通常为用户，也可以是应用程序，即该资源的拥有者。

3.授权服务器（也称认证服务器)
用来对资源拥有的身份进行认证、对访问资源进行授权。
客户端要想访问资源需要通过认证服务器由资源拥有者授权后方可访问。

4.资源服务器
存储资源的服务器，比如，网站用户管理服务器存储了网站用户信息，
网站相册服务器存储了用户的相册信息，微信的资源服务存储了微信的用户信息等。
客户端最终访问资源服务器获取资源信息。
```

## 2.2 常见术语
```
客户凭证(c1ient credentials):
客户端的clientld和密码用于认证客户

令牌(tokens):
授权服务器在接收到客户请求后，颁发的访问令牌

作用域(scopes):
客户请求访问令牌时，由资源拥有者额外指定的细分权限(permission)
```

## 2.3 令牌类型
```
1.授权码:
仅用于授权码授权类型，用于交换获取访问令牌和刷新令牌

2.访问令牌:
用于代表一个用户或服务直接去访问受保护的资源

3.刷新令牌:
用于去授权服务器获取一个刷新访问令牌

4.BearerToken:
不管谁拿到Token都可以访问资源，类似现金

5.Proof of Possession(PoP) Token:
可以校验client是否对Token有明确的拥有权
```

## 2.4 优缺点
```
优点:
更安全，客户端不接触用户密码，服务器端更易集中保护
广泛传播并被持续采用
短寿命和封装的token
资源服务器和授权服务器解耦
集中式授权，简化客户端
HTTPIJSON友好，易于请求和传递token
考虑多种客户端架构场景
客户可以具有不同的信任级别

缺点:
协议框架太宽泛，造成各种实现的兼容性和互操作性差
不是一个认证协议，本身并不能告诉你任何用户信息。
```

## 2.5 授权模式
```
https://blog.51cto.com/u_13626762/3113777

1.授权码模式(Authorization Code)
C 端认证常用模式, 最复杂, 也最安全

2.简化授权模式(Implicit)

3.密码模式(Resource Owner PasswordCredentials)
可用于公司内网之间两个服务之间简单认证

4.客户端模式(Client Credentials)
无用户参与, 如 docker 拉取镜像
```

#3.JWT
## 3.1 常见的认证机制
### 3.1.1 Http Basic Auth
```
HTTP Basic Auth简单点说明就是每次请求API时都提供用户的username和password，
简言之，Basic Auth是配合RESTful API使用的最简单的认证方式，只需提供用户名密码即可，
但由于有把用户名密码暴露给第三方客户端的风险，在生产环境下被使用的越来越少。
因此，在开发对外开放的RESTful API时，尽量避免采用HTTP BasicAuth。
```

### 3.1.2 Cookie Auth
```
Cookie认证机制就是为一次请求认证在服务端创建一个Session对象，
同时在客户端的浏览器端创建了一个Cookie对象;
通过客户端带上来Cookie对象来与服务器端的session对象匹配来实现状态管理的。
默认的，当我们关闭浏览器的时候，cookie会被删除。
但可以通过修改cookie的expire time使cookie在一定时间内有效。
```

### 3.1.3 OAuth
```
OAuth(开放授权,Open Authorization)是一个开放的授权标准，
允许用户让第三方应用访问该用户在某一web服务上存储的私密的资源(如照片，视频，联系人列表)，
而无需将用户名和密码提供给第三方应用。如网站通过微信、微博登录等，主要用于第三方登录。

OAuth允许用户提供一个令牌，而不是用户名和密码来访问他们存放在特定服务提供者的数据。
每一个令牌授权一个特定的第三方系统（例如，视频编辑网站)在特定的时段（例如，接下来的2小时内）内
访问特定的资源（例如仅仅是某一相册中的视频)。
这样，OAuth让用户可以授权第三方网站访问他们存储在另外服务提供者的某些特定信息，而非所有内容。

这种基于OAuth的认证机制适用于个人消费者类的互联网产品，如社交类APP等应用，
但是不太适合拥有自有认证权限管理的企业应用。
```

### 3.1.4 Token Auth
```
使用基于Token的身份验证方法，在服务端不需要存储用户的登录记录。大概的流程是这样的:
1.客户端使用用户名跟密码请求登录
2.服务端收到请求，去验证用户名与密码
3.验证成功后，服务端会签发一个Token，再把这个Token发送给客户端
4.客户端收到Token 以后可以把它存储起来，比如放在Cookie里
5.客户端每次向服务端请求资源的时候需要带着服务端签发的Token
6.服务端收到请求，然后去验证客户端请求里面带着的Token，如果验证成功，就向客户端返回请求的数据


比 Http Basic Auth 更安全，
比 Cookie Auth 更节约服务器资源，
比 OAuth 更加轻量。

Token Auth的优点(Token机制相对于Cookie机制又有什么好处呢? ) ∶
1.支持跨域访问: Cookie是不允许垮域访问的，这一点对Token机制是不存在的，前提是传输的用户认证信息通过HTTP头传输.
2.无状态(也称:服务端可扩展行):Token机制在服务端不需要存储session信息，因为Token自身包含了所有登录用户的信息，只需要在客户端的cookie或本地介质存储状态信息.
3.更适用CDN:可以通过内容分发网络请求你服务端的所有资料(如: javascript，HTML,图片等)，而你的服务端只要提供API即可.
4.去耦:不需要绑定到一个特定的身份验证方案。Token可以在任何地方生成，只要在你的API被调用的时候，你可以进行Token生成调用即可公
5.更适用于移动应用:当你的客户端是一个原生平台 (iOS, Android，Windows 10等)时，Cookie是不被支持的（你需要通过Cookie容器进行处理)，这时采用Token认证机制就会简单得多。
6.CSRF:因为不再依赖于Cookie，所以你就不需要考虑对CSRF(跨站请求伪造)的防范。
7.性能:一次网络往返时间（通过数据库查询session信息）总比做一次HMACSHA256计算的Token验证和解析要费时得多.
8.不需要为登录页面做特殊处理:如果你使用Protractor做功能测试的时候，不再需要为登录页面做特殊处理.
9.基于标准化:你的API可以采用标准化的JSON Web Token (JWT).这个标准已经存在多个后端库（.NET,Ruby,java,Python,PHP)和多家公司的支持（如:Firebase,Google, Microsoft)
```

## 3.2 什么是JWT
https://jwt.io/

### 3.2.1 概念
```
JSON Web Token (JWT)是一个开放的行业标准(RFC7519)，它定义了一种简介的、自包含的协议格式，
用于在通信双方传递json对象，传递的信息经过数字签名可以被验证和信任。
JWT可以使用HMAC算法或使用RSA的公钥/私钥对来签名，防止被篡改。
```

### 3.2.2 优缺点
```
JWT令牌的优点:
1. jwt基于json，非常方便解析。
2可以在令牌中自定义丰富的内容，易扩展。
3.通过非对称加密算法及数字签名技术，JWT防止篡改，安全性高。
4.资源服务使用JWT可不依赖认证服务即可完成授权。
JWT令牌的缺点:
1.JWT令牌较长，占存储空间比较大。

>> 
```

### 3.2.3 JWT组成
```
一个WT实际上就是一个字符串，它由三部分组成，头部、载荷与签名。
```

#### 3.2.3.1 头部(Header)
```
头部用于描述关于该WT的最基本的信息，例如其类型(即WT)以及签名所用的算法（如HMAC SHA256或RSA）等。
这也可以被表示成一个JSON对象。一般进行了BASE64编码

{
    "alg":"HS256",
    "typ":"JWT"
}
```

#### 3.2.3.2 负载(Payload)
```
第二部分是负载，就是存放有效信息的地方。这些有效信息包含三个部分:
1.标准中注册的声明(建议但不强制使用)
iss: jwt签发者
sub: jwt所面向的用户
aud: 接收jwt的一方
exp: jwt的过期时间，这个过期时间必须要大于签发时间
nbf: 定义在什么时间之前，该jwt都是不可用的.
iat: jwt的签发时间
jti: jwt的唯一身份标识，主要用来作为一次性token ,从而回避重放攻击。

2.公共的声明
公共的声明可以添加任何的信息，一般添加用户的相关信息或其他业务需要的必要信息.
但不建议添加敏感信息，因为该部分在客户端可解密.

3.私有的声明
私有声明是提供者和消费者所共同定义的声明，一般不建议存放敏感信息，因为base64是对称解密的
意味着该部分信息可以归类为明文信息。
这个指的就是自定义的claim。比如下面那个举例中的name都属于自定的claim。
这些claim跟WT标准规定的claim区别在于:JWT规定的claim，
JWT的接收方在拿到WT之后，都知道怎么对这些标准的claim进行验证(还不知道是否能够验证);
而private claims不会验证，除非明确告诉接收方要对这些claim进行验证以及规则才行。

PS: 声明中不要放置敏感信息
```

#### 3.2.3.3 签名(signature)
```
jwt的第三部分是一个签证信息，这个签证信息由三部分组成:
1.header (base64后的)
2. payload (base64后的)
3.secret(盐，一定要保密, 客户端也存储了)

这个部分需要base64加密后的 header 和base64加密后的 payload 使用.连接组成的字符串，
然后通过header中声明的加密方式进行加盐secret组合加密，然后就构成了jwt的第三部分.

将这三部分用  .  连接成一个完整的字符串,构成了最终的jwt.

注意: secret是保存在服务器端的，jwt的签发生成也是在服务器端的，
secret就是用来进行jwt的签发和jwt的验证，所以，它就是你服务端的私钥，在任何场景都不应该流露出去。
一旦客户端得知这个secret，那就意味着客户端是可以自我签发jwt了。
```

https://www.freesion.com/article/9149885824/ (session 共享)
https://my.oschina.net/chaoo/blog/5352293
https://www.freesion.com/article/3112810499/
https://cloud.tencent.com/developer/article/1427346
https://github.com/nixuechao/security-jwt

```参考资源```
https://blog.csdn.net/I_am_Hutengfei/article/details/100561564
https://github.com/WYA1993/springcloud_oauth2.0/tree/master/eshop
https://blog.csdn.net/weixin_46146718/article/details/114793940
https://blog.51cto.com/u_15127561/3988242
https://www.cnblogs.com/javasl/p/13193847.html
https://juejin.cn/post/6903732083647561736
https://www.icode9.com/content-4-1076340.html
http://www.javashuo.com/article/p-qgztmqzv-kz.html
https://developer.51cto.com/article/710619.html (oauth2 spring 新方案)
http://www.qianxiaoxiao.com/2018/04/03/20180404/
http://www.45fan.com/article.php?aid=1CO8JOSftM3bbSJg
https://juejin.cn/post/6844903542960947207
