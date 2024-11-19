#!/bin/bash

# ==============================
# 内网VPS服务器一键部署脚本
# 作者：Mir
# ==============================

while true; do
    clear
    echo "=============================="
    echo " 内网VPS服务器一键部署脚本"
    echo " 作者：Mir"
    echo "=============================="
    echo "请选择您要执行的任务："
    echo "1. 安装 Node.js 和 npm"
    echo "2. 配置 Cysic 验证器"
    echo "3. 添加地址"
    echo "4. 启动验证器"
    echo "5. 退出"
    echo "=============================="
    read -p "请输入数字 (1-5)： " choice

    case $choice in
        1)
            echo "正在安装 Node.js 和 npm..."
            sudo apt update && sudo apt upgrade -y
            curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
            sudo apt install -y nodejs
            echo "Node.js 和 npm 安装完成！"
            echo "Node.js 版本: $(node -v)"
            echo "npm 版本: $(npm -v)"
            echo "安装 PM2..."
            sudo npm install -g pm2
            echo "PM2 版本: $(pm2 -v)"
            read -p "按回车键继续..."
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
            read -p "按回车键继续..."
            ;;
        3)
            echo "添加地址..."
            read -p "请输入您的地址: " user_address
            if [[ -n "$user_address" ]]; then
                echo "地址已成功添加: $user_address"
            else
                echo "未输入地址，操作取消。"
            fi
            read -p "按回车键继续..."
            ;;
        4)
            echo "正在启动验证器..."
            pm2 start /root/cysic-verifier/start.sh --name cysic-verifier
            echo "验证器已启动！"
            read -p "按回车键继续..."
            ;;
        5)
            echo "退出脚本，再见！"
            exit 0
            ;;
        *)
            echo "输入错误，请输入 1-5 的数字。"
            read -p "按回车键继续..."
            ;;
    esac
done

