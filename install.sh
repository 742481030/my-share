

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
echo "输入开机密码已安装myshare"

have_sudo_access

#环境检测
Cellars="/usr/local/Cellar"
if [ ! -d "$folder"]; then
 sudo mkdir "$Cellars"
  chmod 777 /usr/local/Cellar
fi




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






#安装fuse
isnsta-fust(){
cd ~/Downloads
curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@master/FUSE.pkg && sudo installer -pkg ./FUSE.pkg -target /
rm FUSE.pkg
echo "安装fuse成功"
}
install-my-share(){
cd ~/Downloads 
curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@master/my-share.zip && unzip my-share.zip
rm ./my-share.zip
rm -rf ./__MACOSX
sudo mkdir  /usr/local/Cellar/my-share
echo "移动bin文件到目录"
mv ./my-share  /usr/local/Cellar/my-share/my-share
echo "创建符号链接"
ln -s /usr/local/Cellar/my-share/my-share /usr/local/bin/my-share
sudo chmod 777 /usr/local/Cellar/my-share/my-share 
cd  /usr/local/Cellar/my-share
curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@0.6/rclone.conf
# curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@0.6/start-myshare

cat<<EOF > /usr/local/Cellar/my-share/start-myshare

export RCLONE_CONFIG="/usr/local/Cellar/my-share/rclone.conf"


     count=`ps -ef |grep /usr/local/Cellar/my-share/my-share |grep -v "grep" |wc -l` 
     if [ 0 == $count ];
     then 
 say "重启了"
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
cat<<EOF >~/Library/LaunchAgents/com.myshare.share.plist
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
#安装fuse
isnsta-fust
#安装my-share
install-my-share
#安装系统服务
install-servers

 

say "安装启动成功"
