![Build.ps1](../assets/powershell.png)

# 如何使用 Build.ps1 脚本进行构建？



```powershell
Microsoft PowerShell

> .\Build.ps1 -DownloadDotNetSdk -Configuration Release -ApiKey YourNuGetApiKey -SourceUri https://api.nuget.org/v3/index.json
```

- 参数说明

| 参数名称          | 数据类型         | 描述信息                                      | 是否必选 | 默认值                                       | 备注                                            |
| ----------------- | ---------------- | --------------------------------------------- | -------- | -------------------------------------------- | ----------------------------------------------- |
| DownloadDotNetSdk | Switch (Boolean) | 是否从微软官方网站下载 .NET Core SDK Zip 包。 | 否       | false                                        | 此参数仅用于主机没有安装 .NET Core SDK 的情况。 |
| Configuration     | String           | MSBuild 配置信息。                            | 否       | Debug                                        | 此参数提供两个默认选项：Debug/Release。         |
| ApiKey            | String           | 用来推送包到 NuGet 中的 NuGet.org 的 ApiKey   | 否       | 我的 [ApiKey](../src/NuGet/nuget-apikey.txt) |                                                 |
| SourceUri         | String           | 要推送的 NuGet 服务地址。                     | 否       | NuGet.org                                    |                                                 |

