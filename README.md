# KumaDocCenter.github.io

文档中心管理库（组织站点）

----

## 目录配置说明

### 目录列表

```
│  README.md
│  RepoList.md
│  
├─data
│  └─SubRepo
│      ├─conf
│      │  ├─ok
│      │  │      Ajax.20181213190958.add
│      │  │      Ajax.20181213190951.del
│      │  │      Ajax.20181213190951.update
│      │  │      Ajax.20181213190951.init
│      │  │      Ajax.20181213190958.Repoadd
│      │  │      
│      │  └─staged
│      └─init
└─Script
    ├─hook
    └─sh
            outRepoList.bat
            Search_.bak_CreateRepoDir.bat
```



### 列表说明

* `README.md`  ： 本文件。
* `RepoList.md` ： 仓库列表文件。
* `data`   ： 数据根目录。
  * `SubRepo` ： 子仓库目录。
    * `conf` ： 子仓库作为子模块的配置文件存储目录。
      * `*.add` `*.init` `*.del` `*.update` ： 子模块配置文件。
      * `*.Repoadd`  `*.Repodel` `*.Repoupdate` ： 子仓库配置文件。用于异地检出仓库。
    * `init` ： 子仓库初始化日志存储目录。

* `Script`  ： 脚本根目录。
  * `hook` ： 钩子目录。
  * `sh`  ： 脚本目录(.bat：Windows专用)。
    * `outRepoList.bat` ： 生成`RepoList.md` 文件的脚本。
    * `Search_.bak_CreateRepoDir.bat`  ： 在另一位置创建子仓库的空目录。
      * 用于检出子仓库的其它分支。

    
