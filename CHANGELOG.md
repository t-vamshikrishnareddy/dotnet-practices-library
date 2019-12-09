# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [1.1.0-alpha.0](///compare/v1.0.1-alpha.1...v1.1.0-alpha.0) (2019-12-09)


### ⚠ BREAKING CHANGES

* **Practices.Library.Common.csproj:** 调整了 src/Practices.Library.Common/ExceptionExtensions.cs 扩展方法类型的命名空间为 System.

### DOCUMENTATIONS

* 添加了 Build.ps1 使用说明文档 docs/how-to-use-buildps1-script.md 586f4ad


### FEATURES

* **Practices.Library.Common.csproj:** 新增具体值的接口 src/Practices.Library.Common/Objects/IValue.cs 2e85c82
* **Practices.Library.Common.csproj:** 新增字符串类型的标识名称接口 src/Practices.Library.Common/Objects/IStringKey.cs eaffbd7
* **Practices.Library.Common.csproj:** 新增对象名称接口 src/Practices.Library.Common/Objects/IName.cs 680fcc6
* **Practices.Library.Common.csproj:** 新增性别枚举类型 src/Practices.Library.Common/Objects/Gender.cs 2186b59
* **Practices.Library.Common.csproj:** 新增标识名称和值的接口 src/Practices.Library.Common/Objects/IKeyValue.cs 09106b8
* **Practices.Library.Common.csproj:** 新增标识名称接口 src/Practices.Library.Common/Objects/IKey.cs f078a06
* **Practices.Library.Common.csproj:** 新增校验是否启用状态的接口 src/Practices.Library.Common/Objects/IEnabled.cs df9ae09


### BUG FIXES

* **Practices.Library.Common.csproj:** 调整了 ExceptionExtensions 扩展方法类的命名空间。 65f96b7

### [1.0.1-alpha.1](///compare/v1.0.1-alpha.0...v1.0.1-alpha.1) (2019-12-09)


### FEATURES

* 新增自动化构建脚本 Build.ps1。 71f53bb
* **Practices.Library.Common.csproj:** 新增一组值类型标识符接口。 209a2bc
* **Practices.Library.Common.csproj:** 新增应用类型标识符接口。 fcb160b
* **Practices.Library.Common.csproj:** 新增标识符接口 src/Practices.Library.Common/Objects/IIdentifier.cs 276c24a
* **Practices.Library.Common.csproj:** 新增类库系统集成接口 src/Practices.Library.Common/ILibraryIntegrationInterface.cs 2616d5b
* **Practices.Library.Common.csproj:** 新增类库默认选项类型 src/Practices.Library.Common/LibraryDefaults.cs 9297b1a
* **Practices.Library.Common.csproj:** 新增资源类型和异常扩展方法。 0133e6c
* 初始化 Practices.Library.Common.csproj 项目。 d4eb6d1
* 新增解决方案和 NuGet 配置。 d740180

### 1.0.1-alpha.0 (2019-12-05)


### FEATURES

* 初始化项目。 a24358a


### DOCUMENTATIONS

* 添加了 Gitlab 代码镜像信息。 7823dd2
