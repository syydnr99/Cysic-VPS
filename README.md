# VPS服务器一键部署多开脚本 - 作者 Mir

## 功能
1. 安装 Node.js 和 npm
2. 配置 Cysic 验证器
3. 启动验证器
4. 查看验证器日志
5. 重启验证器
6. 创建新用户
7. 切换用户
8. 修改用户目录权限
9. 添加用户到用户组
10. 退出脚本

## 注意事项
确保您的服务器系统是 Ubuntu 20.04 或更高版本。
Node.js 和 npm 仅需安装一次，多用户无需重复安装。
如果遇到系统内核升级，按提示重启系统确保正常运行。
验证器目录独立，多开时每个用户单独配置验证器。

## 脚本运行

使用以下命令一键运行脚本：

```bash
bash <(curl -s https://raw.githubusercontent.com/syydnr99/Cysic-VPS-/main/deploy.sh)

## 2. 必备操作（仅需执行一次）
1. 安装 Node.js 和 npm
选择主菜单的 1。
自动完成 Node.js、npm 和 PM2 的安装。
建议：完成后重启系统（脚本会提示是否需要重启）。

## 3. 单开验证器
配置并启动验证器
选择主菜单的 2，输入你的 EVM 地址完成配置。
选择主菜单的 3，启动验证器。
可通过主菜单的 4 查看验证器日志。

## 4. 多开验证器
新建用户并切换
创建新用户
主菜单选择 6，输入新用户名。
切换到新用户
主菜单选择 7，输入用户名完成切换。
配置验证器
按 单开验证器 的步骤为新用户独立配置验证器。
重复以上步骤 为多个用户分别配置验证器。

## 5. 其他功能
修改用户目录权限
主菜单选择 8，输入需要修改权限的目录路径。
添加用户到组
主菜单选择 9，输入主用户和子用户列表，轻松管理组权限。


