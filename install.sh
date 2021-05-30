

have_sudo_access() {
  if [[ -z "${HAVE_SUDO_ACCESS-}" ]]; then
    /usr/bin/sudo -l mkdir &>/dev/null
    HAVE_SUDO_ACCESS="$?"
  fi

  if [[ "$HAVE_SUDO_ACCESS" -ne 0 ]]; then
    echo "\033[1;31m开机密码输入错误，获取权限失败!\033[0m"
  fi

  return "$HAVE_SUDO_ACCESS"
}




check_file(){
echo "环境检测"
if [ ! -d "/usr/local/Cellar" ]; then
echo  "brew文件夹不存在创建中"
 sudo mkdir /usr/local/Cellar
 sudo chmod 777 /usr/local/Cellar

else
echo  "/usr/local/Cellar文件夹存在"
fi

if [ ! -d "/usr/local/Cellar/my-share" ]; then
echo "创建应用目录"
 sudo mkdir /usr/local/Cellar/my-share
 sudo chmod 777 /usr/local/Cellar/my-share

else
echo  "应用存在,卸载中"
sudo rm -rf  /usr/local/Cellar/my-share
sudo mkdir /usr/local/Cellar/my-share
sudo chmod 777 /usr/local/Cellar/my-share
fi


}




downloadres(){
  cd ~/Downloads
curl -sSO https://cdn.jsdelivr.net/gh/742481030/my-share@master/FUSE.pkg && echo "下载fuse成功"
 curl -sSO  https://new.cy/https://github.com/rclone/rclone/releases/download/v1.55.1/rclone-v1.55.1-osx-amd64.zip && echo "下载myshare成功"
curl -sSO https://cdn.jsdelivr.net/gh/742481030/my-share@master/rclone.conf && echo "下载配置文件成功"
ls




}









#安装fuse
isnsta-fust(){
cd ~/Downloads
sudo installer -pkg ./FUSE.pkg -target /
rm FUSE.pkg
echo "安装fuse成功"
}

install-my-share(){
cd ~/Downloads/ 
 unzip rclone-v1.55.1-osx-amd64.zip
 cd rclone-v1.55.1-osx-amd64
 mv rclone-v1.55.1-osx-amd64 my-share




 
echo "移动bin文件到目录"
 sudo mv ~/Downloads/my-share  /usr/local/Cellar/my-share/my-share
sudo mv ~/Downloads/rclone.conf  /usr/local/Cellar/my-share/rclone.conf
echo "创建符号链接"
sudo  ln -s /usr/local/Cellar/my-share/my-share /usr/local/bin/my-share
sudo   ln -s /usr/local/Cellar/my-share/share  ~/Dwsktop/share
cd  /usr/local/Cellar/my-share

sudo cat<<'EOF' > /usr/local/Cellar/my-share/start-myshare

export RCLONE_CONFIG="/usr/local/Cellar/my-share/rclone.conf"


     count=`ps -ef |grep /usr/local/Cellar/my-share/my-share |grep -v "grep" |wc -l` 
     if [ 0 == $count ];
     then 

     nohup /usr/local/Cellar/my-share/my-share mount share: /usr/local/Cellar/my-share/share --copy-links --no-gzip-encoding --no-check-certificate --allow-other --allow-non-empty --umask 000 &

     fi 

     

while true
do
        let "j=j+1"
        sleep 60
       echo "done" $j
/usr/local/Cellar/my-share/start-myshare
      
done

EOF

 chmod 777 ./start-myshare
mkdir ~/Desktop/share

}

install-servers(){
sudo cat<<EOF >~/Library/LaunchAgents/com.myshare.share.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>KeepAlive</key>
	<false/>
	<key>Label</key>
	<string>com.myshare.share.plist</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/Cellar/my-share/start-myshare</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>StandardErrorPath</key>
	<string>/tmp/my-share.err</string>
	<key>StandardOutPath</key>
	<string>/tmp/my-share.out</string>
	<key>WorkingDirectory</key>
	<string>/usr/local/Cellar/my-share/</string>
</dict>
</plist>
EOF
sudo chown root:wheel ~/Library/LaunchAgents/com.myshare.share.plist 
sudo  launchctl load -w ~/Library/LaunchAgents/com.myshare.share.plist 

}


echo "输入开机密码已安装myshare"
#判断权限
have_sudo_access
#校验环境
check_file
#下载文件
downloadres
#安装fuse
isnsta-fust
#安装my-share
install-my-share
#安装系统服务
install-servers

 

say "安装启动成功,访达设置桌面显示链接的服务器就可以查看"
