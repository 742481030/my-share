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
say "输输入开机密码已安装myshare"
have_sudo_access





cd ~/Downloads

#安装fuse
curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@master/FUSE.pkg && sudo installer -pkg ./FUSE.pkg -target /
rm FUSE.pkg
#安装my-share
mkdir /usr/local/Cellar/my-share
cd /usr/local/Cellar/my-share
curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@master/my-share.zip && unzip my-share.zip
 chmod 777 ./my-share
 rm ./my-share.zip
rm -rf ./__MACOSX
#创建符号链接
ln-s /usr/local/Cellar/my-share/my-share /usr/local/bin/my-share
#下载配置文件

curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@0.5/rclone.conf
 curl -O https://cdn.jsdelivr.net/gh/742481030/my-share@0.5/start-myshare
 chmod 777 ./start-myshare
mkdir share













 #./start-myshare
 
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
	<string>/.myshare/</string>
</dict>
</plist>
EOF
sudo chown root:wheel ~/Library/LaunchAgents/com.myshare.share.plist 
sudo  launchctl load -w ~/Library/LaunchAgents/com.myshare.share.plist 
say "安装启动成功"
