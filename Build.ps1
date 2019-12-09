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


# SIG # Begin signature block
# MIIbkQYJKoZIhvcNAQcCoIIbgjCCG34CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAOeruX9D37ipPW
# LznMV9UvLY3pKuTcYMqoPn3rMD0ZCqCCE0AwggQUMIIC/KADAgECAgsEAAAAAAEv
# TuFS1zANBgkqhkiG9w0BAQUFADBXMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
# YmFsU2lnbiBudi1zYTEQMA4GA1UECxMHUm9vdCBDQTEbMBkGA1UEAxMSR2xvYmFs
# U2lnbiBSb290IENBMB4XDTExMDQxMzEwMDAwMFoXDTI4MDEyODEyMDAwMFowUjEL
# MAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMT
# H0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzIwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQCU72X4tVefoFMNNAbrCR+3Rxhqy/Bb5P8npTTR94ka
# v56xzRJBbmbUgaCFi2RaRi+ZoI13seK8XN0i12pn0LvoynTei08NsFLlkFvrRw7x
# 55+cC5BlPheWMEVybTmhFzbKuaCMG08IGfaBMa1hFqRi5rRAnsP8+5X2+7UulYGY
# 4O/F69gCWXh396rjUmtQkSnF/PfNk2XSYGEi8gb7Mt0WUfoO/Yow8BcJp7vzBK6r
# kOds33qp9O/EYidfb5ltOHSqEYva38cUTOmFsuzCfUomj+dWuqbgz5JTgHT0A+xo
# smC8hCAAgxuh7rR0BcEpjmLQR7H68FPMGPkuO/lwfrQlAgMBAAGjgeUwgeIwDgYD
# VR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFEbYPv/c
# 477/g+b0hZuw3WrWFKnBMEcGA1UdIARAMD4wPAYEVR0gADA0MDIGCCsGAQUFBwIB
# FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAzBgNVHR8E
# LDAqMCigJqAkhiJodHRwOi8vY3JsLmdsb2JhbHNpZ24ubmV0L3Jvb3QuY3JsMB8G
# A1UdIwQYMBaAFGB7ZhpFDZfKiVAvfQTNNKj//P1LMA0GCSqGSIb3DQEBBQUAA4IB
# AQBOXlaQHka02Ukx87sXOSgbwhbd/UHcCQUEm2+yoprWmS5AmQBVteo/pSB204Y0
# 1BfMVTrHgu7vqLq82AafFVDfzRZ7UjoC1xka/a/weFzgS8UY3zokHtqsuKlYBAIH
# MNuwEl7+Mb7wBEj08HD4Ol5Wg889+w289MXtl5251NulJ4TjOJuLpzWGRCCkO22k
# aguhg/0o69rvKPbMiF37CjsAq+Ah6+IvNWwPjjRFl+ui95kzNX7Lmoq7RU3nP5/C
# 2Yr6ZbJux35l/+iS4SwxovewJzZIjyZvO+5Ndh95w+V/ljW8LQ7MAbCOf/9RgICn
# ktSzREZkjIdPFmMHMUtjsN/zMIIEnzCCA4egAwIBAgISESHWmadklz7x+EJ+6RnM
# U0EUMA0GCSqGSIb3DQEBBQUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
# YWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBD
# QSAtIEcyMB4XDTE2MDUyNDAwMDAwMFoXDTI3MDYyNDAwMDAwMFowYDELMAkGA1UE
# BhMCU0cxHzAdBgNVBAoTFkdNTyBHbG9iYWxTaWduIFB0ZSBMdGQxMDAuBgNVBAMT
# J0dsb2JhbFNpZ24gVFNBIGZvciBNUyBBdXRoZW50aWNvZGUgLSBHMjCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBALAXrqLTtgQwVh5YD7HtVaTWVMvY9nM6
# 7F1eqyX9NqX6hMNhQMVGtVlSO0KiLl8TYhCpW+Zz1pIlsX0j4wazhzoOQ/DXAIlT
# ohExUihuXUByPPIJd6dJkpfUbJCgdqf9uNyznfIHYCxPWJgAa9MVVOD63f+ALF8Y
# ppj/1KvsoUVZsi5vYl3g2Rmsi1ecqCYr2RelENJHCBpwLDOLf2iAKrWhXWvdjQIC
# KQOqfDe7uylOPVOTs6b6j9JYkxVMuS2rgKOjJfuv9whksHpED1wQ119hN6pOa9PS
# UyWdgnP6LPlysKkZOSpQ+qnQPDrK6Fvv9V9R9PkK2Zc13mqF5iMEQq8CAwEAAaOC
# AV8wggFbMA4GA1UdDwEB/wQEAwIHgDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBHjA0
# MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0
# b3J5LzAJBgNVHRMEAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMEIGA1UdHwQ7
# MDkwN6A1oDOGMWh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3MvZ3N0aW1lc3Rh
# bXBpbmdnMi5jcmwwVAYIKwYBBQUHAQEESDBGMEQGCCsGAQUFBzAChjhodHRwOi8v
# c2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3RpbWVzdGFtcGluZ2cyLmNy
# dDAdBgNVHQ4EFgQU1KKESjhaGH+6TzBQvZ3VeofWCfcwHwYDVR0jBBgwFoAURtg+
# /9zjvv+D5vSFm7DdatYUqcEwDQYJKoZIhvcNAQEFBQADggEBAI+pGpFtBKY3IA6D
# lt4j02tuH27dZD1oISK1+Ec2aY7hpUXHJKIitykJzFRarsa8zWOOsz1QSOW0zK7N
# ko2eKIsTShGqvaPv07I2/LShcr9tl2N5jES8cC9+87zdglOrGvbr+hyXvLY3nKQc
# MLyrvC1HNt+SIAPoccZY9nUFmjTwC1lagkQ0qoDkL4T2R12WybbKyp23prrkUNPU
# N7i6IA7Q05IqW8RZu6Ft2zzORJ3BOCqt4429zQl3GhC+ZwoCNmSIubMbJu7nnmDE
# Rqi8YTNsz065nLlq8J83/rU9T5rTTf/eII5Ol6b9nwm8TcoYdsmwTYVQ8oDSHQb1
# WAQHsRgwggqBMIIGaaADAgECAgggFvtbd3ziMDANBgkqhkiG9w0BAQsFADB7MQsw
# CQYDVQQGEwJDTjEQMA4GA1UECBMHQmVpSmluZzEQMA4GA1UEBxMHSGFpRGlhbjEQ
# MA4GA1UEChMHTmV0T3dsczELMAkGA1UECxMCSVQxKTAnBgkqhkiG9w0BCQEWGm5l
# dG93bHMtc3R1ZGlvQG91dGxvb2suY29tMB4XDTE5MTIwNjA3MjAwMFoXDTIxMTIw
# NjA3MjAwMFowezELMAkGA1UEBhMCQ04xEDAOBgNVBAgTB0JlaUppbmcxEDAOBgNV
# BAcTB0hhaURpYW4xEDAOBgNVBAoTB05ldE93bHMxCzAJBgNVBAsTAklUMSkwJwYJ
# KoZIhvcNAQkBFhpuZXRvd2xzLXN0dWRpb0BvdXRsb29rLmNvbTCCBCIwDQYJKoZI
# hvcNAQEBBQADggQPADCCBAoCggQBAKhUtJQL+fnMZ/SUROzkztXL/u+s/vmtGK1C
# qhSdScYTadTUEVd7vZdxKjaJszGvnRfurim7VCmjFphiuiLf3sKEjWjdlFShWNFz
# dFdGTZsdoUDcgyS+JesNVemTQStSh4+Req+8VnR9WdgCycxPsRBZLnCB+f7++eWx
# YCp+eg5UF89ZgYTyas41uS/itwboPXwutOT3shMhEyUZyJ4WtsP4suRFgNnkyb71
# nzf/B0aGMaEESmwlbt2zM+keIjY0cxh8TGXtq38KrLCBgyrfzHbVDhf8Yrf0ORXk
# Hgf+cMVpgQKVvnp3i2RfwhJJlXYuaYAWI/9TIMCy+SUre33VSJpiEUi7xEk0W8ZE
# Qp9vII1cwgHy5+Je4Gs8sflL57EgVAMjewk92OTEYRvpUzdH5xWM9WjGetD9/1jn
# CDfnKnGHn7dlM+ensTyrT74aEFQlAWoKIHfPZG+IhQZBsMiu3RVZDLesZ7fl9P71
# 73mtpKPfDjgx1vF3E2L4klAwuW2iU1692ed4GUX8ymiz4pLfMAom9lQfsUkHR2Oz
# qmy2scQRMV0ScIaCchM5Wb3N3p9Ss5wLeiz+IEPakzStVLGT8ZoKUci+I8tdnxDu
# mou7NJB12rioKYQuE3NtR1mr9w5A2DOXeRDcKT3G1JH/3nqb+gYBsa+JaLpwweG5
# DJV5QIgcqrfQJ6QTYstOcAKkboQ6iN8Wn9SLh8XT8wHznvs0zXZ/2/Px2VaXdSTN
# egQ44+WM9inhmNJZo7UG5h2fZDJyR2KL1dQsMJLjKnOEWrmxY+AdqRJSSkhZIrRI
# m3IBs0RUv6h2DN8Cr64Dgqo1h6y6jlSs/zoQ14vq9dZxW0gOmea50xY4Yr8xv8qK
# 9V4CFwfo3jPMB+pqgdCDGUnEv6Ia8uj0QtdnvSbpaLLesVQ2haUXsD9trB42WmaV
# JXnKcBZtDUuVkg8FsEEJIl5DlXh3H33c3q/iP2C8s4WuvRmrHClZpXmuftIK5IYK
# Q7RK1mVXdt22aS4CWdJinT409eWUiKniDNgsNNogFY+S01KlL5v1PpEf9gp6MZ3G
# Gdb+WkHllAfUk8ZCSBeyiOHhRPNC3lFt20N8N2Bf4uQTBMDyRQq9F0+E7AEJXpBP
# i2Na//5U9RtwlOeqFm2FApqPp9uCAmt90Tp5ALHFrm2BlFo7AQt/8Jny3pjZX8I5
# +a2eM6mXZfyXMQEtjWbZ5RdfaVlHMKr6BCoYMXjSaqmjIwEtIZvvLCftpSpuZNMu
# TtFZ46wVoZMtL3TlTSlNnvIMIrGnqUbKZyLU6MaRkKFPQSsZ1SiYT5OOZKT5vp04
# lSrrakb0h3SGNjU9RlUvObFKaz4i0K+FL7FRXL3P38T0yyS20UcCAwEAAaOCAQcw
# ggEDMA8GA1UdDwEB/wQFAwMH/4Awge8GA1UdJQEB/wSB5DCB4QYIKwYBBQUHAwEG
# CCsGAQUFBwMCBggrBgEFBQcDAwYIKwYBBQUHAwQGCCsGAQUFBwMIBgorBgEEAYI3
# AgEVBgorBgEEAYI3AgEWBgorBgEEAYI3CgMBBgorBgEEAYI3CgMDBgorBgEEAYI3
# CgMEBglghkgBhvhCBAEGCysGAQQBgjcKAwQBBggrBgEFBQcDBQYIKwYBBQUHAwYG
# CCsGAQUFBwMHBggrBgEFBQgCAgYKKwYBBAGCNxQCAgYIKwYBBQUHAwkGCCsGAQUF
# BwMNBggrBgEFBQcDDgYHKwYBBQIDBTANBgkqhkiG9w0BAQsFAAOCBAEATNyYvw1w
# mvnuxAYyVcrXFgyCtru8yOayGudN4bM1AAyXdK2mBt4Ztk2r/mrzStZbUuwltfu0
# TWwgMcfGJ8RWrRBnXeMLWltW2SoS96ZZA+vmaI7NKnfBNQeW0Ofm438mjcYkmfYV
# 1DYMl42yBUstmbkqUO5H33R4/FlX7cAqYmli1HjJDgMFwMVHCr1rcYnf5xUGXLVH
# DaJ92tNwQtVJHKN20r7EMKbmNRply3KTkvHXzbksnl02Fwswoq0cT0Z0oYlCNZLb
# x2tahJC5jVe+4V/5q0mBs/1cXq3VEyOuxPn+ckdt31Y4RaRCxQ6YStZ/JPavmeDF
# Uz9xf01xlWB2t+ttxRIspd/f3eonWkSaiGLdUU+RqTBe54hhS/MCxPAyQx2okoJQ
# DRn4/fpj1ZBIe1Aufpq6dDZYh23N1K1XLQ6cY4SduFDtswJRg+1fFkOV+x/LgHYJ
# /pogrKpy3OISxOsK+zVtcmt1/siU3UUWeQp1D89+hVikHZZHtg6eFHKB0M5q1FBJ
# E6tYXvXNK83BnPZrcpc8T4/TJNtnyWPIA4kSQTPxayk0+d9Yl+nT9VXdyRXnrAim
# fz4eP7rqweIVOIsM2w/55wV01q0td20pSIsJ8SOlN/rsXgCGE+RhVF4RIL1TN5pn
# 64Yn80UTSGz5Dt0+X9f35de01LzOkHCyv9CFEzP++CeNoPN2OiHoyoUVLEDkn7QZ
# M6zQCV8FOWtwCF9R+b3r08PU8TiY+SpN+fZxQyxVsG2RBZ2h4liyPkCe5bp/54Zw
# ZTe/z6pnp9BzF870kEpqopPHPEUGdVp0PquRoVMufuofgvDW/78dlTqbXyl/TuxP
# AU8No6AmjogdGeJuErHERJ0+xen3n1Xp8pXh+OkVc4MMd6fLvRm1d0hVaJjhknF2
# J9JZZAqHCaUn77m7ULLGeBemq85xkAZOjmECdy6R0sChnFYOX++tPzap9jKy61Cm
# EJtQ5DcieFNl4AnmiEkhkqT4oqrItVjCfJMgZHRJb2uhQWCjmrx968J4Ks+5bPIo
# kgkc4G5Tdr5tNtJ05v5EhAOd2AtKFhhgBaQgSkjGd1/tj6fkOAWhm7HEkbekYKgo
# d7yXrj9DV9aNqnugujaZL7Kz608dbBVw47jopdusT/EoPcz2cziXBq+oICq1N8+q
# ukXq0snBwGYcsXSf+mEedle0m9ghyHEGHyTZZSbOsnVhO4IsITAXciXMnNF+/C+a
# FcfvCD44KDcEE2XXnPNF1nFRemg3re12oXwlYxJt3enB0UZfJc0w2VSN4OxXMjO4
# q+D33iDxzzr0r5hBBn0FBqARYK+QSVGVNjaY2zRX/h5xMrdCiXUpGcACkGWLmyfQ
# uvEZyxvmMjod3TGCB6cwggejAgEBMIGHMHsxCzAJBgNVBAYTAkNOMRAwDgYDVQQI
# EwdCZWlKaW5nMRAwDgYDVQQHEwdIYWlEaWFuMRAwDgYDVQQKEwdOZXRPd2xzMQsw
# CQYDVQQLEwJJVDEpMCcGCSqGSIb3DQEJARYabmV0b3dscy1zdHVkaW9Ab3V0bG9v
# ay5jb20CCCAW+1t3fOIwMA0GCWCGSAFlAwQCAQUAoEwwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwLwYJKoZIhvcNAQkEMSIEIPX/WYGMk/rIEzGEzFIEJ2ureTC+
# V+uHdGPv3op88YrmMA0GCSqGSIb3DQEBAQUABIIEAJHdafqbR1CBOi0to5T6gi+/
# oLCKJtP4otCeUE+KCK9J0sEZWJDJS10tST2qdDGNAW4nWFbECv0SmnHOGRLPdknq
# G88A09bpaRQTHGj1lz+Sp4GxL+omE4fEJWD4dKZilrhU1K7H15xn3wetI/K75d7L
# TDo94dcpq0H5Cw3yX4jh1tllzjDXcM11UnrmHWwf77Nwpf7EfM1NBnSgb73SeT5V
# y9EdPVDrYpT8Zcoq+Ld7qpwQXOu/Dwh8zuIA3keuwBuOaDIb4djb5JKZWxd2Vpdx
# ENm7i2nPpR8wzdkJ21tCiGytmEloFvVZs7/FNka0ZWIA3eHUA4bFIhZR5OPv2TvT
# jdxOBaXYqFdD2U2HdYu3FHx9aV01gO9GXIQen8Ihs0XNA6O+sRiGGzNsZg/XDz5j
# NBH5IkBa7ZR/U0fWRCGnserXTOS6/ooyAmgteNeP/a9EoqkVNO8YXft1+HdWlE8z
# 0BSYyn5DXnqoTWimJipQDQ9OqdQ1TvjDwHd2p8JgnAgudMfNhois/hijrDbltErZ
# 8rAWtOPTcLlbZ+L9O51tF41I3l9ZJEDmWRxnD2uy1ZRAAKxqcgEpkLkh1DEC8c33
# v6vtUDlpyUyWmG4ublNZpHnoLNyvKPYfY813iWjow4cUfH/xxvekJpeVjVhdkTYZ
# WgWre8aBYV9l1Q1p/o3WuNEQYNX19qOYHGfF/uDZ3UrLglfYc8KtzTrCeLmasVBQ
# LbaXaFVmLYsKZ5qPG0R/LX+MgRkYgt6ZqxlBe0OmIPOrsDBTVnrf4cUJjXucz0Um
# yqGVBc/mUItCo8DsTQWpFRm94ZEG/v7dd6cSOnydK3x53luey3mMh+HKqifHsug2
# 4vkbmNnB8/4NvCf7l1oIgKhAFyBgC41YUqPBB7dthgYMjWzMVPpF+hTTSJ2pO4DO
# Q7NgmJAaRdtoHa4zRzaD/SF8M9/ujfpkLle82nCYHK308S4adm5ba71ke0459sxa
# tSNeHZ7aBi3iUfixBwr6PBb6qzjha8b0CjNJK71l8oQTPEatb++Yu9gKJN5bpA0y
# zRWs/+JBU+cMGrtYZiZTbK7+hvVwg5BcxXYVE6M28ZYjqH2IXhUXYbyjyNLZn+55
# qhJRvavXrPQrHxJnCwgoNlvc5WUTLgjt41j2USaG24KrLLAg6efBQXUkrfQ3uFXo
# uYNwpnPzoPOQmVmowIvTyAKd4fQ4YQD9cxEQ2h8qZwMQ1ofPNZMf+Q0mQ7ylL0gE
# HyCgJk09xpAJblbiTsdFgZUqTMjL5omsyTTkhTMaaw0KMXjqDTZDpMpfvrKYT09E
# UVpNf/oOXa/XfKAMQ3yziTacoRGg0/5M0wbEa8LYi2O1j9A5GBx9L2E/eIXOex+h
# ggKiMIICngYJKoZIhvcNAQkGMYICjzCCAosCAQEwaDBSMQswCQYDVQQGEwJCRTEZ
# MBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBU
# aW1lc3RhbXBpbmcgQ0EgLSBHMgISESHWmadklz7x+EJ+6RnMU0EUMAkGBSsOAwIa
# BQCggf0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
# MTkxMjA5MDQzNDUyWjAjBgkqhkiG9w0BCQQxFgQU0B0znrWMgAUWUdGunyoIJ9dV
# Ax4wgZ0GCyqGSIb3DQEJEAIMMYGNMIGKMIGHMIGEBBRjuC+rYfWDkJaVBQsAJJxQ
# KTPseTBsMFakVDBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBu
# di1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMgIS
# ESHWmadklz7x+EJ+6RnMU0EUMA0GCSqGSIb3DQEBAQUABIIBAAA2NHa7a0LCURD4
# 6Nf+eZ5bZuJhPappvEOayFgRZa/s2V7DQ7Q76qFTndcehzi5Cb4Sci6U2e4+d5yl
# Jm9xgVGmIl5FQPoXW+1K88nN6qjANxCNZZmSofDFG2bsXrrdQPGh+yDE2CeuJDHj
# 5nloo8m8XGqM55NXn3p8Dm1MAR9/SgSTYnJFU661s3nZ1qbh8yIGVI9/Y/uKpSC0
# osOovNmY+LqqYOXotUYAG/E3v55n8IBp0g7rLWOTXptwUcmxt88pKODy6lGGKs/l
# Dxo91gLXLwNE7skWFpqWYqGrHY4G1ujAHutDZAzI+kq5mxVCVhnpy7R29EsKkKNF
# ll3voWc=
# SIG # End signature block
