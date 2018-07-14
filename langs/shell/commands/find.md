# find

```sh
find path -option [ -print ] [ -exec -ok command ] {} \;

-pathname: find 命令所查找的目录路径。例如用.来表示当前目录，用/来表示系统根目录。
-print： find 命令将匹配的文件输出到标准输出。
-exec： find 命令对匹配的文件执行该参数所给出的shell命令。相应命令的形式为'command' { } \;，注意{ }和\；之间的空格。
-ok： 和-exec的作用相同，只不过以一种更为安全的模式来执行该参数所给出的shell命令，在执行每一个命令之前，都会给出提示，让用户来确定是否执行。
```

## 参数说明

```sh
  -name  filename                 # 查找名为filename的文件
  -perm                           # 按执行权限来查找
  -user  username                 # 按文件属主来查找
  -group groupname                # 按组来查找
  -mtime -n +n                    # 按文件更改时间来查找文件，-n指n天以内，+n指n天以前
  -atime -n +n                    # 按文件访问时间来查GIN: 0px">
  -ctime -n +n                    # 按文件创建时间来查找文件，-n指n天以内，+n指n天以前
  -nogroup                        # 查无有效属组的文件，即文件的属组在/etc/groups中不存在
  -nouser                         # 查无有效属主的文件，即文件的属主在/etc/passwd中不存
  -newer f1 !f2                   # 按新旧找文件，-n指n天以内，+n指n天以前 
  -type  b/d/c/p/l/f              # 查是块设备、目录、字符设备、管道、符号链接、普通文件
  -size  n[c]                     # 查长度为n块[或n字节]的文件
  -depth                          # 使查找在进入子目录前先行查找完本目录
  -fstype                         # 查更改时间比f1新但比f2旧的文件
  -mount                          # 查文件时不跨越文件系统mount点
  -follow                         # 如果遇到符号链接文件，就跟踪链接所指的文件
  -cpio %;                        # 查位于某一类型文件系统中的文件，这些文件系统类型通常可 在/etc/fstab中找到
  -prune                          # 忽略某个目录
```

## 使用示例

```sh
find ~     -name "*.txt"   -print
find .     -name "*.txt"   -print
find .     -name "[A-Z]*"  -print
find /etc  -name "host*"   -print                          # 查以host开头的文件
find .     -name "[a-z][a-z][0–9][0–9].txt"    -print      # 查以两个小写字母和两个数字开头的txt文件
find .     -perm 755   -print
find .     -perm -007   -exec ls -l {} \;                  # 查所有用户都可读写执行的文件同-perm 777
find .     -type d   -print
find .   ! -type d   -print 
find .     -type l   -print

find .     -size   +1000000c   -print                      # 查长度大于1Mb的文件
find .     -size   100c         -print                     # 查长度为100c的文件
find .     -size   +10   -print                            # 查长度超过期作废10块的文件（1块=512字节）

find /etc   home   apps -depth -print | cpio -ivcdC65536 -o /dev/rmt0
find /etc  -name "passwd*" -exec grep "cnscn" {} \; 
find .     -name "yao*"   | xargs file
find .     -name "yao*"   | xargs   echo    "" > /tmp/core.log
find .     -name "yao*"   | xargs   chmod   o-w
find -name  april*                                          # 在当前目录下查找以april开始的文件
find -name  april*   fprint file                            # 在当前目录下查找以april开始的文件，并把结果输出到file中
find -name  ap* -o -name may*                               # 查找以ap或may开头的文件
find /mnt   -name tom.txt   -ftype vfat                     # 在/mnt下查找名称为tom.txt且文件系统类型为vfat的文件
find /mnt   -name t.txt ! -ftype vfat                       # 在/mnt下查找名称为tom.txt且文件系统类型不为vfat的文件
find /tmp   -name wa* -type l                               # 在/tmp下查找名为wa开头且类型为符号链接的文件
find /home  -mtime   -2                                     # 在/home下查最近两天内改动过的文件
find /home  -atime -1                                       # 查1天之内被存取过的文件
find /home  -mmin   +60                                     # 在/home下查60分钟前改动过的文件
find /home  -amin   +30                                     # 查最近30分钟前被存取过的文件
find /home  -newer   tmp.txt                                # 在/home下查更新时间比tmp.txt近的文件或目录
find /home  -anewer  tmp.txt                                # 在/home下查存取时间比tmp.txt近的文件或目录
find /home  -used   -2                                      # 列出文件或目录被改动过之后，在2日内被存取过的文件或目录
find /home  -user cnscn                                     # 列出/home目录内属于用户cnscn的文件或目录
find /home  -uid   +501                                     # 列出/home目录内用户的识别码大于501的文件或目录
find /home  -group   cnscn                                  # 列出/home内组为cnscn的文件或目录
find /home  -gid 501                                        # 列出/home内组id为501的文件或目录
find /home  -nouser                                         # 列出/home内不属于本地用户的文件或目录
find /home  -nogroup                                        # 列出/home内不属于本地组的文件或目录
find /home  -name tmp.txt   -maxdepth   4                   # 列出/home内的tmp.txt 查时深度最多为3层
find /home  -name tmp.txt   -mindepth   3                   # 从第2层开始查
find /home  -empty                                          # 查找大小为0的文件或空目录
find /home  -size   +512k                                   # 查大于512k的文件
find /home  -size   -512k                                   # 查小于512k的文件
find /home  -links   +2                                     # 查硬连接数大于2的文件或目录
find /home  -perm   0700                                    # 查权限为700的文件或目录
find /tmp   -name tmp.txt   -exec cat {} \;
find /tmp   -name   tmp.txt   -ok   rm {} \;

find /   -amin    -10                                       # 查找在系统中最后10分钟访问的文件
find /   -atime   -2                                        # 查找在系统中最后48小时访问的文件
find /   -empty                                             # 查找在系统中为空的文件或者文件夹
find /   -group   cat                                       # 查找在系统中属于 groupcat的文件
find /   -mmin   -5                                         # 查找在系统中最后5分钟里修改过的文件
find /   -mtime   -1                                        # 查找在系统中最后24小时里修改过的文件
find /   -nouser                                            # 查找在系统中属于作废用户的文件
find /   -user    fred                                      # 查找在系统中属于FRED这个用户的文件
```
