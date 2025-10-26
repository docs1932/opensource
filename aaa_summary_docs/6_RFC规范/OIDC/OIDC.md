是的，**OIDC（OpenID Connect）有明确的 RFC 标准**，它是在 **OAuth 2.0 协议基础上构建的身份认证层协议**，由 **OpenID Foundation** 制定，并已发布为 **正式的 IETF RFC 文档**。

---

## ✅ 核心 RFC 标准

### 1. **[RFC 9068](https://datatracker.ietf.org/doc/rfc9068/) - JSON Web Token (JWT) Profile for OAuth 2.0 Access Tokens**
> 虽然不是 OIDC 核心，但与 OIDC 的 Token 格式密切相关。

---

### 2. **OIDC 核心规范（已提交 IETF，但尚未成为 RFC）**
虽然 OIDC 规范由 OpenID Foundation 发布，**但其核心文档已被 IETF 接受为 Proposed Standard**，具有事实上的 RFC 地位：

#### 📄 **[OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)**
- **功能**：定义 OIDC 核心流程（ID Token、UserInfo Endpoint、认证请求等）
- **状态**：**Final**（2014 年发布），被全球广泛采用
- **关键组件**：
    - `id_token`（JWT 格式）
    - `openid` scope
    - `response_type=code id_token`
    - UserInfo Endpoint

#### 📄 **[OpenID Connect Discovery 1.0](https://openid.net/specs/openid-connect-discovery-1_0.html)**
- **功能**：自动发现 OP（OpenID Provider）的配置（如 `.well-known/openid-configuration`）
- **示例**：  
  `https://accounts.google.com/.well-known/openid-configuration`

#### 📄 **[OpenID Connect Dynamic Client Registration 1.0](https://openid.net/specs/openid-connect-registration-1_0.html)**
- **功能**：客户端动态注册到 OP

---

## 🔗 与 OAuth 2.0 的关系

OIDC **不是独立协议**，而是 **OAuth 2.0 的扩展**，依赖以下 OAuth 2.0 RFC：

| 协议 | RFC | 作用 |
|------|-----|------|
| **OAuth 2.0** | [RFC 6749](https://datatracker.ietf.org/doc/rfc6749/) | 授权框架 |
| **OAuth 2.0 Bearer Tokens** | [RFC 6750](https://datatracker.ietf.org/doc/rfc6750/) | Token 使用方式 |
| **OAuth 2.0 Threat Model** | [RFC 6819](https://datatracker.ietf.org/doc/rfc6819/) | 安全威胁分析 |

> 💡 **OIDC = OAuth 2.0 + ID Token + UserInfo Endpoint + Discovery**

---

## 🧩 OIDC 的关键创新（相比 OAuth 2.0）

| 特性 | OAuth 2.0 | OIDC |
|------|-----------|------|
| **主要目的** | 授权（Access Delegation） | **认证（Authentication）** |
| **返回 Token** | `access_token` | `access_token` + **`id_token`** |
| **用户信息** | 无标准 | **UserInfo Endpoint** |
| **标准化发现** | 无 | **`.well-known/openid-configuration`** |
| **身份断言** | 无 | **JWT 格式的 ID Token** |

---

## 🌐 实际应用中的标准端点

一个标准的 OIDC Provider（如 Auth0、Google、Azure AD）会提供：

```http
GET /.well-known/openid-configuration
```

返回：
```json
{
  "issuer": "https://your-oidc-provider.com",
  "authorization_endpoint": "https://.../authorize",
  "token_endpoint": "https://.../token",
  "userinfo_endpoint": "https://.../userinfo",
  "jwks_uri": "https://.../jwks.json",
  "response_types_supported": ["code", "id_token", "code id_token"],
  "subject_types_supported": ["public"],
  "id_token_signing_alg_values_supported": ["RS256"]
}
```

---

## 📚 官方文档与权威来源

1. **OpenID Foundation 官网**  
   🔗 https://openid.net/connect/

2. **IETF OAuth Working Group**  
   🔗 https://datatracker.ietf.org/wg/oauth/documents/

3. **OIDC 规范全文**
    - Core: https://openid.net/specs/openid-connect-core-1_0.html
    - Discovery: https://openid.net/specs/openid-connect-discovery-1_0.html

---

## ✅ 总结

| 问题 | 答案 |
|------|------|
| **OIDC 有 RFC 吗？** | **核心规范由 OpenID Foundation 发布，已被 IETF 接受为 Proposed Standard，具有事实 RFC 地位** |
| **依赖哪些 RFC？** | **RFC 6749 (OAuth 2.0), RFC 7519 (JWT), RFC 7515 (JWS)** |
| **是否标准化？** | **✅ 是，全球 Identity Provider（Google, Microsoft, Auth0 等）均遵循 OIDC 1.0** |
| **如何验证实现？** | 使用 [OpenID Certification](https://openid.net/certification/) 工具 |

> 💡 **开发建议**：  
> 在实现 OIDC 客户端时，**优先使用官方库**（如 `angular-oauth2-oidc`, `oidc-client-ts`），避免手动解析 JWT 或处理 OAuth 流程，以确保符合标准并保障安全。

OIDC 是现代 Web 身份认证的事实标准，理解其 RFC/规范基础对构建安全系统至关重要！ 🔐