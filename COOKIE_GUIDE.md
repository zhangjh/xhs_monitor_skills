# 小红书监控技能配置指南

本指南说明两类必要配置：

1. **小红书登录态**：用于抓取搜索结果
2. **消息接收渠道**：用于把监控结果发送给自己或群聊

---

## 一、获取并配置 XHS Cookie

为了让监控脚本正常抓取小红书内容，需要先获取网页版 `Cookie`。

### 获取方法
1. 在电脑浏览器登录 [小红书网页版](https://www.xiaohongshu.com)。
2. 按 `F12` 打开开发者工具。
3. 切换到 **Network (网络)** 选项卡。
4. 刷新页面。
5. 点击任意一个 `search_result` 或 `home` 请求。
6. 在 **Headers (标头)** → **Request Headers (请求标头)** 中找到 `cookie`。
7. 复制其完整值。

### 注入方式
在对应脚本中填写：

```bash
export XHS_COOKIE="此处粘贴你的 Cookie"
```

---

## 二、配置消息接收渠道

如果希望脚本执行后把结果自动发送出来，还需要配置接收渠道。

通用写法：

```bash
export CHANNEL="wecom"     # 或 telegram
export TARGET_ID="YOUR_ID"
```

### 1. Telegram 示例

#### 获取 Telegram 数字 ID
1. 打开 Telegram。
2. 搜索机器人 `@userinfobot`。
3. 向它发送任意消息。
4. 它返回的数字 ID 即为你的 Telegram ID。

#### 配置示例
```bash
export CHANNEL="telegram"
export TARGET_ID="telegram:YOUR_TELEGRAM_ID"
```

例如：
```bash
export CHANNEL="telegram"
export TARGET_ID="telegram:123456789"
```

### 2. 企业微信（WeCom）示例

企业微信渠道需要先在 OpenClaw 中完成 wecom 通道接入，然后填写接收目标 ID。

#### 配置示例
```bash
export CHANNEL="wecom"
export TARGET_ID="wecom:YOUR_WECOM_ID"
```

例如：
```bash
export CHANNEL="wecom"
export TARGET_ID="wecom:YOUR_WECOM_ID"
```

#### 说明
- `YOUR_WECOM_ID` 可以是你在当前 OpenClaw / wecom 通道配置中实际使用的接收目标标识
- 如果是给自己发，通常填写个人接收 ID
- 如果是给群发，则填写群聊对应的目标 ID

---

## 三、典型脚本配置片段

### Telegram
```bash
export XHS_COOKIE="YOUR_XHS_COOKIE_HERE"
export CHANNEL="telegram"
export TARGET_ID="telegram:YOUR_TELEGRAM_ID"
```

### 企业微信
```bash
export XHS_COOKIE="YOUR_XHS_COOKIE_HERE"
export CHANNEL="wecom"
export TARGET_ID="wecom:YOUR_WECOM_ID"
```

---

## 四、隐私与安全提醒

请勿把以下真实信息提交到 GitHub：
- 真实 Cookie
- Telegram 数字 ID
- 企业微信接收 ID
- 带敏感信息的日志或截图

建议统一使用占位符：
- `YOUR_XHS_COOKIE_HERE`
- `YOUR_TELEGRAM_ID`
- `YOUR_WECOM_ID`

---

## 五、运行

完成配置后，即可执行对应脚本或通过 OpenClaw 调用技能。