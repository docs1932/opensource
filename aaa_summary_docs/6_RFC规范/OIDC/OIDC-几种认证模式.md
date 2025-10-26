以下是 **OIDC（OpenID Connect）所有核心流程** 的详细 Mermaid 图解，涵盖 **认证码模式（Authorization Code Flow）**、**隐式模式（Implicit Flow）**、**混合模式（Hybrid Flow）** 三大标准流程，并标注关键安全机制。

---

## 🌐 1. **认证码模式（Authorization Code Flow）**
> **✅ 最安全、最推荐**（适用于 Web 应用、有后端的应用）

```mermaid
sequenceDiagram
    participant User as 用户浏览器
    participant Client as 客户端 (RP)
    participant OP as OpenID Provider (OP)
    participant Resource as 资源服务器

    Note over User,OP: 第一阶段：获取 Authorization Code

    User->>Client: 访问受保护资源
    Client->>User: 重定向到 OP 登录页<br/>?response_type=code<br/>&client_id=CLIENT_ID<br/>&redirect_uri=CALLBACK<br/>&scope=openid profile<br/>&state=RANDOM_STRING<br/>&nonce=RANDOM_NONCE

    User->>OP: 提交登录凭证
    OP->>User: 显示授权确认页（可选）
    User->>OP: 确认授权

    OP->>User: 重定向回客户端<br/>?code=AUTH_CODE<br/>&state=RANDOM_STRING

    User->>Client: 浏览器自动跳转到 CALLBACK

    Note over Client,OP: 第二阶段：用 Code 换 Token

    Client->>OP: POST /token<br/>grant_type=authorization_code<br/>&code=AUTH_CODE<br/>&redirect_uri=CALLBACK<br/>&client_id=CLIENT_ID<br/>&client_secret=CLIENT_SECRET

    OP->>Client: 返回 JSON<br/>{<br/>  "access_token": "ACCESS_TOKEN",<br/>  "id_token": "ID_TOKEN",<br/>  "token_type": "Bearer",<br/>  "expires_in": 3600<br/>}

    Note over Client,OP: 第三阶段：验证 ID Token

    Client->>Client: 1. 验证 ID Token 签名<br/>2. 检查 iss, aud, exp, iat<br/>3. 验证 nonce (防重放)

    Note over Client,Resource: 第四阶段：访问用户信息

    Client->>Resource: GET /userinfo<br/>Authorization: Bearer ACCESS_TOKEN

    Resource->>Client: 返回用户信息<br/>{ "sub": "123", "name": "John" }

    Client->>User: 显示用户信息
```

> 🔒 **关键安全机制**：
> - `state`：防 CSRF
> - `nonce`：防 ID Token 重放
> - `client_secret`：后端验证客户端身份
> - PKCE（未图示）：用于公共客户端（如 SPA）

---

## 📱 2. **隐式模式（Implicit Flow）**
> **⚠️ 已弃用**（OAuth 2.1 / OIDC 1.0 不推荐，仅用于遗留系统）

```mermaid
sequenceDiagram
    participant User as 用户浏览器
    participant Client as 客户端 (SPA)
    participant OP as OpenID Provider (OP)

    Note over User,OP: 直接返回 Token（无后端）

    User->>Client: 访问 SPA 应用
    Client->>User: 重定向到 OP<br/>?response_type=id_token token<br/>&client_id=CLIENT_ID<br/>&redirect_uri=CALLBACK<br/>&scope=openid profile<br/>&nonce=RANDOM_NONCE

    User->>OP: 登录并授权
    OP->>User: 重定向回 SPA<br/>#access_token=ACCESS_TOKEN<br/>&id_token=ID_TOKEN<br/>&token_type=Bearer

    User->>Client: 浏览器 URL Hash 中提取 Token

    Client->>Client: 验证 ID Token<br/>(签名、iss、aud、exp、nonce)

    Client->>User: 显示用户信息
```

> ⚠️ **为什么弃用**？
> - Token 暴露在 URL（浏览器历史、日志）
> - 无 `client_secret`（无法验证客户端）
> - 无法使用 Refresh Token

---

## ⚡ 3. **混合模式（Hybrid Flow）**
> **适用于需要前端+后端协同的场景**（如 Angular + Node.js）

```mermaid
sequenceDiagram
    participant User as 用户浏览器
    participant Frontend as 前端 (SPA)
    participant Backend as 后端 (RP)
    participant OP as OpenID Provider (OP)

    Note over User,OP: 第一阶段：获取 Code + Token

    User->>Frontend: 访问应用
    Frontend->>User: 重定向到 OP<br/>?response_type=code id_token<br/>&client_id=CLIENT_ID<br/>&redirect_uri=CALLBACK<br/>&scope=openid profile<br/>&state=RANDOM_STRING<br/>&nonce=RANDOM_NONCE

    User->>OP: 登录授权
    OP->>User: 重定向回前端<br/>?code=AUTH_CODE<br/>&id_token=ID_TOKEN<br/>&state=RANDOM_STRING

    User->>Frontend: 浏览器跳转到 CALLBACK

    Frontend->>Frontend: 1. 验证 ID Token<br/>2. 提取 code 和 id_token

    Note over Frontend,Backend: 第二阶段：后端用 Code 换 Access Token

    Frontend->>Backend: POST /auth/callback<br/>{ code: "AUTH_CODE", id_token: "ID_TOKEN" }

    Backend->>OP: POST /token<br/>grant_type=authorization_code<br/>&code=AUTH_CODE<br/>&client_secret=SECRET

    OP->>Backend: 返回 access_token

    Backend->>Frontend: 返回会话 Cookie / JWT

    Frontend->>User: 应用登录成功
```

> ✅ **优势**：
> - 前端立即获得 ID Token（快速显示用户信息）
> - 后端安全获取 Access Token（用于调用 API）
> - 符合安全最佳实践

---

## 🔑 4. **PKCE 扩展（用于公共客户端）**
> **解决 SPA 无法安全存储 client_secret 的问题**

```mermaid
sequenceDiagram
    participant User as 用户浏览器
    participant Client as 客户端 (SPA)
    participant OP as OpenID Provider (OP)

    Client->>Client: 1. 生成 code_verifier (随机字符串)<br/>2. 生成 code_challenge = BASE64URL(SHA256(code_verifier))

    User->>Client: 访问应用
    Client->>User: 重定向到 OP<br/>?response_type=code<br/>&client_id=CLIENT_ID<br/>&code_challenge=CODE_CHALLENGE<br/>&code_challenge_method=S256<br/>&...其他参数

    User->>OP: 登录授权
    OP->>User: 重定向回 SPA<br/>?code=AUTH_CODE

    User->>Client: 浏览器跳转

    Client->>OP: POST /token<br/>grant_type=authorization_code<br/>&code=AUTH_CODE<br/>&code_verifier=CODE_VERIFIER<br/>&...其他参数

    OP->>OP: 验证 code_verifier == SHA256(code_challenge)

    OP->>Client: 返回 tokens
```

> ✅ **PKCE 是现代 SPA 的必备安全措施**（RFC 7636）

---

## 📊 流程对比表

| 流程 | 适用场景 | 安全性 | 是否推荐 |
|------|----------|--------|----------|
| **认证码 + PKCE** | SPA、移动 App | ⭐⭐⭐⭐⭐ | ✅ **强烈推荐** |
| **认证码（传统）** | Web 应用（有后端） | ⭐⭐⭐⭐ | ✅ 推荐 |
| **混合模式** | 前后端分离应用 | ⭐⭐⭐⭐ | ✅ 可选 |
| **隐式模式** | 遗留 SPA | ⭐ | ❌ **已弃用** |

---

## 💡 关键概念说明

- **RP (Relying Party)**：OIDC 客户端（你的应用）
- **OP (OpenID Provider)**：身份提供商（如 Auth0、Google）
- **ID Token**：JWT 格式，包含用户身份信息（`sub`, `name`, `email`）
- **Access Token**：用于访问 UserInfo Endpoint 或 API
- **nonce**：随机字符串，绑定认证请求与 ID Token，防重放攻击
- **state**：随机字符串，防 CSRF 攻击

---

> 📌 **最佳实践**：  
> **所有新项目应使用 `Authorization Code Flow + PKCE`**，这是 OAuth 2.1 和 OIDC 的现代标准。

这些流程图覆盖了 OIDC 所有官方支持的认证模式，可直接用于系统设计或安全审计！ 🔐