#!/bin/bash

function print_green() {
  case "$#" in
  1) echo -e "\033[32m$1\033[0m\n";;
  2) echo -e "$1 \033[32m$2\033[0m\n";;
  *) echo -e "\033[32m$1\033[0m\n";;
  esac
}

function print_red() {
  case "$#" in
  1) echo -e "\033[31m$1\033[0m\n" ;;
  2) echo -e "$1 \033[31m$2\033[0m\n" ;;
  *) echo -e "\033[31m$1\033[0m\n" ;;
  esac
}

function print_yellow() {
  case "$#" in
  1) echo -e "\033[33m$1\033[0m" ;;
  2) echo -e "$1 \033[33m$2\033[0m" ;;
  *) echo -e "\033[33m$1\033[0m" ;;
  esac
}

os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ $os_name == *"mingw"* ]]; then
  os_name="windows"
else
  print_red "Unsupported os：" "$os_name"
  exit 1
fi

raw_hw_name=$(uname -m)
case "$raw_hw_name" in
"amd64")
  hw_name="amd64"
  ;;
"x86_64")
  hw_name="amd64"
  ;;
"arm64")
  hw_name="arm64"
  ;;
"aarch64")
  hw_name="arm64"
  ;;
"i686")
  hw_name="386"
  ;;
"armv7l")
  hw_name="arm"
  ;;
*)
  print_red "Unsupported hardware：" "$raw_hw_name"
  exit 1
  ;;
esac

print_green "当前系统为：" "${os_name}_${hw_name}"

url="https://ghp.ci/https://github.com/xiaoxuan6/jetbra-activate/releases/download/v1.0.0"

function download() {
  echo "安装完成！自动运行; 下次可直接输入 ./jetbra.exe 并回车来运行程序"
  echo "运行后如果360等杀毒软件误报木马，添加信任后，重新输入./jetbra.exe 并回车来运行程序"
  echo

  local num=0
  while true; do
    if [ -f ${USERPROFILE}/Desktop/jetbra.exe ]; then
      rm -f ${USERPROFILE}/Desktop/jetbra.exe
    fi

    curl -sSLko ${USERPROFILE}/Desktop/jetbra.exe ${url}/jetbra.exe
    chmod +x ${USERPROFILE}/Desktop/jetbra.exe
    ${USERPROFILE}/Desktop/jetbra.exe 2>/dev/null

    if [ $? -eq 0 ]; then
      rm -f ${USERPROFILE}/Desktop/jetbra.exe
      break
    else
      num=$((num + 1))
      if [ "$num" -eq 5 ]; then
        print_green "循环执行超过5次，请手动执行" "${USERPROFILE}/Desktop/jetbra.exe"
        print_red "如果执行 jetbra.exe 报错：" "此应用无法在你的电脑上运行"
        print_green "请手动执行并执行" "$url/jetbra.exe"
        break
      fi
    fi
  done
}

function device() {
  local num=0
  while true; do
      if [ -f ${USERPROFILE}/Desktop/device.exe ];then
        rm -f ${USERPROFILE}/Desktop/device.exe
      fi

      curl -sSLko ${USERPROFILE}/Desktop/device.exe ${url}/device.exe
      chmod +x ${USERPROFILE}/Desktop/device.exe
      ${USERPROFILE}/Desktop/device.exe 2>/dev/null

      if [ $? -eq 0 ]; then
        rm -f ${USERPROFILE}/Desktop/device.exe
        break
      else
        num=$((num + 1))
        if [ "$num" -eq 5 ]; then
          print_green "循环执行超过5次，请手动执行" "${USERPROFILE}/Desktop/device.exe"
          break
        fi
      fi
  done
}

case "$1" in
"code")
  download
  ;;
"device")
  device
  ;;
*)
  print_yellow "请选择一个选项："
  options=("生成 jetbra code 码" "打印设备码")
  for i in "${!options[@]}"; do
    echo "$((i+1)). ${options[i]}"
  done

  echo
  while true; do
  read -p "请输入选项编号 (1-${#options[@]}): " choice

  if [[ "$choice" =~ ^[1-${#options[@]}]$ ]]; then
    case "$choice" in
      1)
        download
        break
        ;;
      2)
        device
        break
        ;;
      *)
        print_red "无效的选项编号: $choice"
        ;;
    esac
  else
    print_red "无效的选项编号: $choice"
  fi
  done
esac

