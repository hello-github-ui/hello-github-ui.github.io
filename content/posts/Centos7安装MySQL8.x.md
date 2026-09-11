---
title: Centos7安装MySQL8.x
date: 2021-11-16T14:41:43+08:00
draft: false
description: Centos7安装MySQL8.x
featureImage: "configuration-system.png"
tags:
  - MySQL
  - Linux
  - Centos
categories:
  - 笔记
  - IT
---

# **上传安装包到Linux**

下载 MySQL server 包：++[链接](https://pan.baidu.com/s/14y8C5SdgiNtjNlvE9Kow7A)++ 提取码: `4aqx`

也可以从++[官网](https://dev.mysql.com/downloads/mysql/)++下载。

> 个人习惯，所有的压缩包，都上传到 linux `/opt/tools/` 目录下；解压缩安装在 `/opt/apps/` 目录下

# **解压缩**

```
tar xvf mysql-8.0.27-linux-glibc2.12-x86_64.tar.xz  -C /opt/apps/
```

# **重命名**

```
mv mysql-8.0.27-linux-glibc2.12-x86_64/   mysql
```

# **修改配置文件**

vim /etc/my.cnf

> 直接清空里面所有内容，输入下面的内容

```
[client]
port=3306
socket=/var/lib/mysql/mysql.sock

[mysqld]
port=3306
user=mysql
socket=/var/lib/mysql/mysql.sock
basedir=/opt/apps/mysql
datadir=/opt/apps/mysql/data
```

# **创建组与用户**

```
groupadd mysql

useradd -g mysql mysql
```

# **初始化mysql**

```
/opt/apps/mysql/bin/mysqld --initialize  --user=mysql  --basedir=/opt/apps/mysql/  --datadir=/opt/apps/mysql/data/

```

# **复制临时密码**

找个记事本，保存一下生成的临时密码

# **创建sock文件夹与命令链接**

```
mkdir -p /var/lib/mysql ;

chown -R mysql:mysql /var/lib/mysql

ln -s /opt/apps/mysql/bin/mysql  /usr/bin
```

# **启动服务**

```
/opt/apps/mysql/support-files/mysql.server  start
```

# **修改密码**

```
mysql -uroot  -p

ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
```

# **开启远程访问**

```
use mysql;

update user set host='%' where user='root';

flush privileges;
```

# **关闭防火墙**

```
systemctl stop firewalld.service #停止firewall

systemctl disable firewalld.service #禁止firewall开机启动
```

# **配置成服务并开机启动**

```
cp /opt/apps/mysql/support-files/mysql.server  /etc/init.d/mysql

chkconfig mysql on

chkconfig --add mysql
```

> 这样配置之后 ，可以使用命令：`service mysql start` 来开启 mysql 服务，`service mysql stop` 停止mysql服务。

# **远程客户端测试链接**

# **彻底卸载 MySQL**

```
find  /  -name  mysql
```

然后一条一条执行 rm -rf，或者写一个shell命令，一次性删除。

