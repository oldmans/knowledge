# scp

```sh
# 命令基本格式：scp [可选参数] file_source file_target

# 从本地到远程 复制文件
# scp local_file remote_username@remote_ip:remote_folder
# scp local_file remote_username@remote_ip:remote_file
# scp local_file remote_ip:remote_folder
# scp local_file remote_ip:remote_file

# 从本地到远程 复制目录
# scp local_folder remote_username@remote_ip:remote_folder
# scp local_folder remote_ip:remote_folder

# 从远程到本地交换位置即可

scp [-P 3166] [-i key_file] local_file remote_username@remote_ip:remote_file

-v 和大多数 linux 命令中的 -v 意思一样 , 用来显示进度 . 可以用来查看连接 , 认证 , 或是配置错误 . 
-C 使能压缩选项 . 
-P 选择端口 . 注意 -p 已经被 rcp 使用 . 
-4 强行使用 IPV4 地址 . 
-6 强行使用 IPV6 地址 .

usage: scp [-12346BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
           [-l limit] [-o ssh_option] [-P port] [-S program]
           [ [user@]host1: ]file1 ... [ [user@]host2: ]file2

scp -P 3166 -i key_name -vrp /path/to/file.tar.gz  root@ip:/path/to/dir
```
