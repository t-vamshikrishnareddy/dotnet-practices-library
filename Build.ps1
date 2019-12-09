## *******************************************************************************************************************************************************
## 用于构建 Practices.Library 项目
## 王 玉才
## netowls-studio@outlook.com
## Copyright © 2006 - 2019 Wang Yucai. All rights reserved.
## *******************************************************************************************************************************************************

<#
	.SYNOPSIS
		用于构建 Practices.Library 项目。
	
	.DESCRIPTION
		用于构建 Practices.Library 项目。
	
	.PARAMETER DownloadDotNetSdk
		是否从微软官方网站重新下载 .NET Core SDK 进行构建。
	
	.PARAMETER Configuration
		MSBuild 构建配置 Release/Debug。
	
	.PARAMETER ApiKey
		发布到 NuGet 的 ApiKey 值。
	
	.PARAMETER SourceUri
		发布到 NuGet 的源地址。
	
	.EXAMPLE
		PS C:\> .\Build.ps1
	
	.NOTES
		Additional information about the file.
#>
param
(
	[Parameter(HelpMessage = '是否从微软官方网站重新下载 .NET Core SDK 进行构建。')]
	[switch]$DownloadDotNetSdk,
	[Parameter(Mandatory = $false,
			   HelpMessage = 'MSBuild 构建配置 Release/Debug。')]
	[ValidateSet('Debug', 'Release', IgnoreCase = $true)]
	[string]$Configuration = 'Debug',
	[Parameter(Mandatory = $false,
			   HelpMessage = '发布到 NuGet 的 ApiKey 值。')]
	[ValidateNotNullOrEmpty()]
	[string]$ApiKey = 'oy2dzmejvvlfc4x4tenqpbwhy6v66e5u7hzzy3ocggkqhe',
	[Parameter(HelpMessage = '发布到 NuGet 的源地址。')]
	[string]$SourceUri = 'https://api.nuget.org/v3/index.json'
)

# .NET Core SDK Binaries 压缩包下载地址。
$private:DotNetSdkUri = 'https://download.visualstudio.microsoft.com/download/pr/28a2c4ff-6154-473b-bd51-c62c76171551/ea47eab2219f323596c039b3b679c3d6/dotnet-sdk-3.1.100-win-x64.zip'

# 构建脚本 Root 目录
$private:RootDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
# 构建结果 Root 目录
$private:BuildRootDir = New-Object System.IO.DirectoryInfo -ArgumentList ([System.IO.Path]::Combine($private:RootDir, ".build"))
# .NET Core SDK 下载目录
$private:DotNetSdkDownloadTempDir = New-Object System.IO.DirectoryInfo -ArgumentList ([System.IO.Path]::Combine($private:BuildRootDir.FullName, ".dotnet-sdk-dl"))
$private:DotNetSdkDir = New-Object System.IO.DirectoryInfo -ArgumentList ([System.IO.Path]::Combine($private:BuildRootDir.FullName, ".dotnet-sdk"))
# 构建结果目录
$private:BuildResultDir = New-Object System.IO.DirectoryInfo -ArgumentList ([System.IO.Path]::Combine($private:BuildRootDir.FullName, "dist"))

# .NET Core 命令行构建命令
$private:DotNetBuildCommandLine = "dotnet"

# 创建构建目录
if ($private:BuildRootDir.Exists)
{
	Write-Host -Object ("[WARN]: The folder '{0}' was exists! We will delete it!" -f $private:BuildRootDir.Name) -ForegroundColor Yellow
	Remove-Item -Path $private:BuildRootDir.FullName -Recurse -Force
}
Write-Host -Object ("[INFO]: The folder '{0}' will be create!" -f $private:BuildRootDir.Name) -ForegroundColor White
$private:BuildRootDir.Create()
Write-Host -Object ("[INFO]: The folder '{0}' will be create!" -f $private:DotNetSdkDir.Name) -ForegroundColor White
$private:DotNetSdkDir.Create()
Write-Host -Object ("[INFO]: The folder '{0}' will be create!" -f $private:BuildResultDir.Name) -ForegroundColor White
$private:BuildResultDir.Create()

[System.IO.Path]::PathSeparator

# 用于校验是否需要重新下载 .NET Core SDK。
if ($DownloadDotNetSdk.ToBool())
{
	Write-Host -Object ("[INFO]: The folder '{0}' will be create!" -f $private:DotNetSdkDownloadTempDir.Name) -ForegroundColor White
	# 创建下载临时目录。
	$private:DotNetSdkDownloadTempDir.Create()
	# CD 到下载临时目录
	Set-Location -Path $private:DotNetSdkDownloadTempDir.FullName
	# 调用 cURL 命令行工具下载
	Write-Host -Object ("[WARN]: We will download 'Microsoft .NET Core SDK' from {0}!" -f $private:DotNetSdkUri) -ForegroundColor Yellow
	. "../../tools/curl/curl.exe" $private:DotNetSdkUri -O --remote-name
	Write-Host -Object "[WARN]: We will decompress 'Microsoft .NET Core SDK'!" -ForegroundColor Yellow
	# 调用 7Zip 命令行工具解压缩
	. "../../tools/7zip/7za.exe" "x" "dotnet-sdk-3.1.100-win-x64.zip" ("-o{0}" -f $private:DotNetSdkDir.FullName)
	$private:DotNetBuildCommandLine = ("{0}{1}dotnet.exe" -f $private:DotNetSdkDir.FullName, "/")
	Set-Location -Path "../../"
}

Write-Host -Object ("[WARN]: We will use command '{0}' to build 'Practices.Library'! Please hold-on......" -f $private:DotNetBuildCommandLine) -ForegroundColor Yellow

. $private:DotNetBuildCommandLine "restore"
. $private:DotNetBuildCommandLine "build" "-o" $private:BuildResultDir.FullName "-c" $Configuration
. $private:DotNetBuildCommandLine "pack" "-o" $private:BuildResultDir.FullName "-c" $Configuration

$private:NuPackages = $private:BuildResultDir.GetFiles("*.nupkg")
foreach ($pkg in $private:NuPackages)
{
	Write-Host -Object ("[INFO]: We will push '{0}' to 'NuGet.org'!" -f $pkg.FullName) -ForegroundColor White
	. $private:DotNetBuildCommandLine "nuget" "push" $pkg.FullName "-k" $ApiKey "-s" $SourceUri "--skip-duplicate"
}