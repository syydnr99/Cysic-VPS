#!/bin/bash

# ==============================
# VPS服务器一键部署脚本 作者Mir
# ==============================

function handle_kernel_upgrade() {
    echo "检测到内核升级完成，需要重启系统以加载新内核。"
    read -p "是否现在重启系统？(y/n): " reboot_choice
    if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
        echo "正在重启系统..."
        sudo reboot
    else
        echo "请稍后手动重启以应用更改！"
        read -p "按回车键返回主菜单..."
    fi
}

while true; do
    clear
    echo "=============================="
    echo "VPS服务器一键部署脚本 作者Mir"
    echo "=============================="
    echo "1. 安装 Node.js 和 npm"
    echo "2. 配置 Cysic 验证器"
    echo "3. 启动验证器"
    echo "4. 查看日志"
    echo "5. 重启验证器"
    echo "6. 退出脚本"
    echo "=============================="
    read -p "请输入数字 (1-6)： " choice

    case $choice in
        1)
            echo "正在安装 Node.js 和 npm..."
            sudo apt update
            sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
            # 检查是否需要重启（通过 /var/run/reboot-required 文件判断）
            if [ -f /var/run/reboot-required ]; then
                handle_kernel_upgrade
                continue
            fi
            curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
            sudo apt install -y nodejs
            echo "Node.js 和 npm 安装完成！"
            echo "Node.js 版本: $(node -v)"
            echo "npm 版本: $(npm -v)"
            echo "安装 PM2..."
            sudo npm install -g pm2
            echo "PM2 版本: $(pm2 -v)"
            read -p "按回车键返回主菜单..."
            ;;
        2)
            echo "正在配置 Cysic 验证器..."
            read -p "请输入验证器地址: " verifier_address
            if [[ -n "$verifier_address" ]]; then
                curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh
                bash ~/setup_linux.sh "$verifier_address"
                echo "验证器配置完成！"
            else
                echo "未输入验证器地址，操作取消。"
            fi
            read -p "按回车键返回主菜单..."
            ;;
        3)
            echo "正在启动验证器..."
            cd ~/cysic-verifier || { echo "cysic-verifier 目录不存在！"; read -p "按回车键返回主菜单..."; continue; }
            pm2 start ./start.sh --name cysic-verifier
            echo "验证器已启动！"
            read -p "按回车键返回主菜单..."
            ;;
        4)
            echo "正在查看验证器日志..."
            pm2 logs cysic-verifier
            read -p "按回车键返回主菜单..."
            ;;
        5)
            echo "正在重启验证器..."
            pm2 restart cysic-verifier
            echo "验证器已成功重启！"
            read -p "按回车键返回主菜单..."
            ;;
        6)
            echo "退出脚本！再见！"
            exit 0
            ;;
        *)
            echo "输入错误，请输入 1-6 的数字。"
            read -p "按回车键返回主菜单..."
            ;;
    esac
done
