#!/bin/bash

# ==============================
# VPS服务器一键部署脚本 作者: Mir
# ==============================

# 检测是否需要重启系统
function handle_kernel_upgrade() {
    if [ -f /var/run/reboot-required ]; then
        echo "检测到系统内核升级，需要重启系统以应用更改。"
        read -p "是否现在重启系统？(y/n): " reboot_choice
        if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
            echo "正在重启系统..."
            sudo reboot
        else
            echo "请稍后手动重启系统。"
        fi
    fi
}

# 功能1: 安装 Node.js 和 npm
function install_node() {
    echo "正在更新系统..."
    sudo apt update
    sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

    # 检查是否需要重启系统
    handle_kernel_upgrade

    echo "安装 Node.js 和 npm..."
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install -y nodejs
    sudo npm install -g pm2

    echo "安装完成，版本信息如下："
    echo "Node.js 版本: $(node --version)"
    echo "npm 版本: $(npm --version)"
    echo "PM2 版本: $(pm2 --version)"
}

# 功能2: 配置 Cysic 验证器
function configure_verifier() {
    echo "正在下载并配置验证器..."
    read -p "请输入您的 EVM 地址: " evm_address
    if [[ -z "$evm_address" ]]; then
        echo "EVM 地址不能为空！"
        return
    fi

    # 下载并运行验证器脚本
    curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh
    chmod +x ~/setup_linux.sh
    bash ~/setup_linux.sh "$evm_address"

    echo "验证器配置完成！"
}

# 功能3: 启动验证器
function start_verifier() {
    if [[ ! -d ~/cysic-verifier ]]; then
        echo "cysic-verifier 目录不存在，请先配置验证器！"
        return
    fi
    cd ~/cysic-verifier
    pm2 start ./start.sh --name cysic-verifier
    echo "验证器已启动！"
}

# 功能4: 查看验证器日志
function view_logs() {
    pm2 logs cysic-verifier
}

# 功能5: 重启验证器
function restart_verifier() {
    pm2 restart cysic-verifier
    echo "验证器已重启！"
}

# 功能6: 创建新用户(多开环境)
function create_user() {
    read -p "请输入新用户名: " new_user
    if id "$new_user" &>/dev/null; then
        echo "用户 $new_user 已存在！"
        return
    fi
    sudo adduser "$new_user"
    echo "用户 $new_user 创建成功！"
}

# 功能7: 切换用户
function switch_user() {
    read -p "请输入要切换的用户名: " user
    if id "$user" &>/dev/null; then
        su - "$user"
    else
        echo "用户 $user 不存在！"
    fi
}

# 功能8: 修改目录权限
function modify_permissions() {
    read -p "请输入需要修改权限的用户目录 (如 /home/username): " dir
    if [[ -d "$dir" ]]; then
        sudo chmod 755 "$dir"
        echo "目录 $dir 的权限已修改为 755（所有用户可读取）。"
    else
        echo "目录 $dir 不存在！"
    fi
}

# 功能9: 添加用户到用户组
function add_user_to_groups() {
    read -p "请输入主用户名称: " main_user
    read -p "请输入要添加到主用户组的用户名（用空格分隔多个用户）: " users
    for user in $users; do
        sudo usermod -aG "$main_user" "$user"
        echo "用户 $user 已添加到主用户组 $main_user 中。"
    done
}

# 主菜单
while true; do
    clear
    echo "=============================="
    echo "VPS服务器一键部署脚本 作者: Mir"
    echo "=============================="
    echo "1. 安装 Node.js 和 npm"
    echo "2. 配置 Cysic 验证器"
    echo "3. 启动验证器"
    echo "4. 查看验证器日志"
    echo "5. 重启验证器"
    echo "6. 创建新用户"
    echo "7. 切换用户"
    echo "8. 修改用户目录权限"
    echo "9. 添加用户到用户组"
    echo "10. 退出脚本"
    echo "=============================="
    read -p "请输入选项 (1-10): " choice

    case $choice in
        1) install_node ;;
        2) configure_verifier ;;
        3) start_verifier ;;
        4) view_logs ;;
        5) restart_verifier ;;
        6) create_user ;;
        7) switch_user ;;
        8) modify_permissions ;;
        9) add_user_to_groups ;;
        10) echo "退出脚本，再见！"; exit 0 ;;
        *) echo "无效选项，请输入 1-10 的数字。" ;;
    esac
    read -p "按回车键返回主菜单..."
done
