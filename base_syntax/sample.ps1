### Chara code is Shift JIS

# PS C:\Users\atsus> $PSVersionTable
# Name                           Value
# ----                           -----
# PSVersion                      5.1.18362.752
# PSEdition                      Desktop
# PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
# BuildVersion                   10.0.18362.752
# CLRVersion                     4.0.30319.42000
# WSManStackVersion              3.0
# PSRemotingProtocolVersion      2.3
# SerializationVersion           1.1.0.1

### 自動変数 
$PSCommandPath  # C:\Users\...\powershell\base_syntax\sample.ps1
$PSScriptRoot   # C:\Users\...\powershell\base_syntax
$Error.Count
$Error.Clear()
$Error          # error 情報出力（中身は配列） $Error[0] が最新エラー情報


### Split-Path
Split-Path -Parent $PSCommandPath  # C:\Users\...\powershell\base_syntax
Split-Path -Leaf $PSCommandPath                # sample.ps1


### Get-date
Get-date -format "yyyyMMddHHmmss"              # 20200730182556
Get-date -format "yyyy-MM-dd HH:mm:ss"         # 2020-07-30 18:25:56
Get-date -format "yyyy年MM月dd日 HH時mm分ss秒"  # 2020年07月30日 18時25分56秒


### 文字列の分解 .Split
$PSCommandPath_Split = $PSCommandPath.Split(".")
$PSCommandPath_Split[0]  # C:\Users\...\powershell\base_syntax\sample
$PSCommandPath_Split[1]  # ps1


### 文字列の結合
$LOG_FILE = $PSCommandPath_Split[0] + ".log"   # 文字列に変換する場合は "" で囲む
$LOG_FILE  # C:\Users\...\powershell\base_syntax\sample.log
Get-ChildItem README.md  2>&1 | Out-File  -Append $LOG_FILE
Get-ChildItem aaaa       2>&1 | Out-File  -Append $LOG_FILE


### Out-File -Encoding default は UTF-16 LE
# Shift-Jis
Get-date -format "yyyyMMddHHmmss"  |  Out-File -Append $LOG_FILE
Get-date -format "yyyyMMddHHmmss"  |  Out-File -Append $LOG_FILE


### 配列
$Array += (1,3,5,7,9)
$Array.GetType()
# IsPublic IsSerial Name                                     BaseType
# -------- -------- ----                                     --------
# True     True     Object[]                                 System.Array
$Array[0]               # 1
$Array.GetValue(1)      # 3
$Array.Length           # 5


### if ディレクトリ・ファイル有無（どちらも指定可能）
if (Test-Path -Path $LOG_FILE ) {
    Write-Host "log file exists." -ForegroundColor white -BackgroundColor red
    Remove-Item $LOG_FILE
}

if ( -not (Test-Path -Path $LOG_FILE)) {
    New-Item $LOG_FILE -ItemType "file"
    Write-Output "make log file."  | Out-File -Append $LOG_FILE
}


### if 数値の比較
$count = 5
if ( $count -eq 5 ) {
    Write-Output "${count} は 5 です。"
} else {
    Write-Output "${count} は 5 ではありません。"
}
if ( $count -ne 5 ) {
    Write-Output "${count} は 5 ではありません。"
} else {
    Write-Output "${count} は 5 です。"
}
if ( $count -gt 5 ) {
    Write-Output "${count} は 5 より大きい。"
} else {
    Write-Output "${count} は 5 以下。"
}
if ( $count -ge 5 ) {
    Write-Output "${count} は 5 以上。"
} else {
    Write-Output "${count} は 5 より小さい。"
}
if ( $count -lt 5 ) {
    Write-Output "${count} は 5 より小さい。"
} else {
    Write-Output "${count} は 5 以上。"
}
if ( $count -le 5 ) {
    Write-Output "${count} は 5 以下。"
} else {
    Write-Output "${count} は 5 より大きい。"
}


### if 文字列の包含　～に含まれる
if ($fruit -in @('リンゴ', 'イチゴ', 'サクランボ')) {
    # もし `$fruit` がリンゴ、イチゴ、サクランボの中に含まれていれば
}


#3# if 文字列の包含　～を含む
# -Contains は右側に変数が推奨 $null 値が扱える
if (@('リンゴ', 'イチゴ', 'サクランボ') -Contains $fruit) {
    # もしリンゴ、イチゴ、サクランボが`$fruit`を含んでいれば
}


### function
function test_function1 {
    Write-Output $msg  | Out-File -Append $LOG_FILE
}
test_function1 "test_function1"


### parameter check スクリプトに対しても使用可能
function test_function2 {
    Param
          (
              # [parameter(Mandatory)] はパラメータ必須
              # [parameter(Mandatory=$false)] はパラメータ必須ではない
              # [ValidateNotNullOrEmpty()] Null Empty は許さない
              # [ValidateRange(0, 999999)] 範囲指定 英数字指定可能
              # [ValidateLength(1,100)] string型 文字数指定
              # [ValidateSet('m', 'f')] 指定した値のみ許可
              # [ValidatePattern()] 正規表現　以下MSDN参照
              # https://docs.microsoft.com/ja-jp/dotnet/standard/base-types/regular-expression-language-quick-reference?redirectedfrom=MSDN
            [parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateRange(0, 999999)][int32]$Studentid,
            [parameter(Mandatory)][AllowNull()][ValidateLength(1,100)][string]$StudentName,
            [parameter(Mandatory)][AllowEmptyString()][string]$StudentAddress,
            [parameter(Mandatory)][ValidateSet('m', 'f')][string]$StudentSex,
            [parameter(Mandatory=$false)][ValidatePattern("\d{1,3}")]$StudentAge = 12   # default値
          )
    # 生徒番号100011はLitiumさん(m)です。住所はで、12歳です。
    Write-Output ("生徒番号" + $Studentid + "は" + $StudentName + "さん(" + $StudentSex + ")です。住所は" + $StudentAddress + "で、" + $StudentAge + "歳です。")
}
$Studentid=100011
$StudentName="Litium"
$StudentSex="m"
test_function2 $Studentid $StudentName $StudentAddress $StudentSex 


### エラーハンドリング $ErrorActionPreference
$ErrorActionPreference                       # Continue (default)
Write-Error -Message "Error World! 1"        # コンソールにエラーメッセージが出力　処理継続

$ErrorActionPreference = "SilentlyContinue"  # SilentlyContinue
Write-Error -Message "Error World! 2"        # コンソールにエラーメッセージが出力されない　処理継続

$ErrorActionPreference = "Stop"              # Stop
#Write-Error -Message "Hello World! 5"       # コンソールにエラーメッセージが出力　処理停止


### try catch finally
try
{
    Write-Error -Message "Error World! 3"   # Error catch 処理中止 コンソールメッセージなし
    Write-Error -Message "Error World! 4"   # 実行されない
}
catch    # 処理停止するエラー発生時に catch に回される
{
    Write-Output "エラーが発生しました"  | Out-File -Append $LOG_FILE  # 実行される
    $Error  | Out-File -Append $LOG_FILE  # $error をログに出力
}
finally  # 必ず実行される
{
    Write-Host "try end." -ForegroundColor white -BackgroundColor red
    $ErrorActionPreference = "Continue"     # Continue
}


### switch
# 基本
switch (2) {
    1 {"One."}
    2 {"Two."}
    3 {"Three."}
    default {"Not matched."}
}
# Two.

# 配列投入時、いずれにもマッチしないとき default
switch (2, 5) {
    1 {"One."}
    2 {"Two."}
    3 {"Three."}
    default {"Not matched."}
}
# Two.
# Not matched.

# break で制御
switch (2, 3) {
    1 {"One."}
    2 {"Two."; break}
    3 {"Three."}
    default {"Not matched."}
}
# Two.

# 文字列は大文字小文字の判定はしない
switch ("Banana") {
    "banana" {"小文字バナナ"}
    "Banana" {"最初だけ大文字バナナ"}
    "BANANA" {"大文字バナナ"}
    default {"Not matched."}
}
# 小文字バナナ
# 最初だけ大文字バナナ
# 大文字バナナ

# 条件式
switch (2) {
    {$_ -gt 2} {$_ }
    {$_ -eq 2} {$_ }
    {$_ -in (1, 2, 3)} {$_ }
    default {"Not matched."}
}
# 2である
# 1, 2, 3のどれかである。


### while
$i = 0
while ($i -lt 3)
{
    Write-Output ('$i:' + $i) | Out-File -Append $LOG_FILE
    $i++
}

# do while
$i = 0
do
{
    Write-Output ('$i:' + $i) | Out-File -Append $LOG_FILE
    $i++
}
while ($i -lt 3)

### for
for ( $i = 0; $i -lt 3; $i++ )
{
    Write-Output ('$i:' + $i) | Out-File -Append $LOG_FILE
}

### foreach
$aaa = "1,2,3"
$bbb = $aaa.Split(",")
foreach ($ccc in $bbb)
{
    Write-Output ('$ccc:' + $ccc) | Out-File -Append $LOG_FILE
}

### continue break
$ddd = "1,2,3,4,5"
$eee = $ddd.Split(",")
foreach ($fff in $eee)
{
    if($fff -eq "1"){
        continue
    }
    if($fff -eq "3"){
        break
    }
    Write-Output ('$fff:' + $fff) | Out-File -Append $LOG_FILE
}
# $fff:2


### テキスト1行ごとの処理
$i=1
foreach ($l in Get-Content $PSScriptRoot\sample.txt) {
    Write-Output ("$i" + " : " + $l) | Out-File -Append $LOG_FILE
    $i++
}
# 1 : aaaaaaaa
# 2 : bbbbbbbb
# 3 : cccccccc


### オブジェクト操作
# PS C:\Users\atsus> Get-Process
# Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
# -------  ------    -----      -----     ------     --  -- -----------
#     201      15     2988       2144             13236   0 aesm_service
#     430      27    18460      17348       6.50  25264   4 ApplicationFrameHost
#     157       8     1744       1084             20908   0 AppVShNotify
#     146       9     1852       1140              4236   0 armsvc
#     320      18     5408      20544       0.20  38616   4 backgroundTaskHost
#     311      17    35980      54984       7.02   6212   4 chrome
#     541      31   129096     116176     206.45   8120   4 chrome
Get-Process | Select-Object -property Id,ProcessName -first 5 | Out-File -Append $LOG_FILE    # 特定列を参照
Get-Process | Where-Object -filterScript {$_.Handles -gt 1000}  | Out-File -Append $LOG_FILE  # $_ はパイプラインに渡されたオブジェクトを表す変数
Get-Process | Where-Object {$_.ProcessName -eq "AppVShNotify"} | ForEach-Object {Write-Output $_.ProcessName} | Out-File -Append $LOG_FILE  # ForEach-Object 配列処理


### ユーザー定義オブジェクト作成　New-Object
$arr = @()
$arr += New-Object PSObject -Property @{index=0; name="あいうえお"; age=30}
$arr += New-Object PSObject -Property @{index=1; name="かきくけこ"; age=18}
$arr += New-Object PSObject -Property @{index=2; name="さしすせそ"; age=99}
$arr  | Out-File -Append $LOG_FILE


### ユーザー定義オブジェクト作成　[PSCustomObject]
$ary = @()
$ary = @(("Name","Country","State"),("koizumi","jap","Tokyo"),("moromizato","jap","Okinawa"),("Mike","US","NY"))

# 1つ目の配列を key にしたオブジェクトを作成
$myObject = @()
$myObject = [PSCustomObject]@{
    $ary[0][0] = $ary[1][0]
    $ary[0][1] = $ary[1][1]
    $ary[0][2] = $ary[1][2]
}
$myObject
# Name    : koizumi
# Country : jap
# State   : Tokyo

### 2次元配列からユーザー定義オブジェクト（key = Value）に変換
$myObject = @()
$inner_ary = @()
for($i = 1; $i -lt $ary.Count; $i ++){

    $inner_ary = $ary[$i];
 
    $myObject += [PSCustomObject]@{
        $ary[0][0] = $inner_ary[0]
        $ary[0][1] = $inner_ary[1]
        $ary[0][2] = $inner_ary[2]
    }
}
$myObject.Name | Out-File -Append $LOG_FILE
# koizumi
# moromizato
# Mike
$myObject.Country | Out-File -Append $LOG_FILE
# jap
# jap
# US
$myObject.State | Out-File -Append $LOG_FILE
# Tokyo
# Okinawa
# NY
