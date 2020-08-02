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

### �����ϐ� 
$PSCommandPath  # C:\Users\...\powershell\base_syntax\sample.ps1
$PSScriptRoot   # C:\Users\...\powershell\base_syntax
$Error.Count
$Error.Clear()
$Error          # error ���o�́i���g�͔z��j $Error[0] ���ŐV�G���[���


### Split-Path
Split-Path -Parent $PSCommandPath  # C:\Users\...\powershell\base_syntax
Split-Path -Leaf $PSCommandPath                # sample.ps1


### Get-date
Get-date -format "yyyyMMddHHmmss"              # 20200730182556
Get-date -format "yyyy-MM-dd HH:mm:ss"         # 2020-07-30 18:25:56
Get-date -format "yyyy�NMM��dd�� HH��mm��ss�b"  # 2020�N07��30�� 18��25��56�b


### ������̕��� .Split
$PSCommandPath_Split = $PSCommandPath.Split(".")
$PSCommandPath_Split[0]  # C:\Users\...\powershell\base_syntax\sample
$PSCommandPath_Split[1]  # ps1


### ������̌���
$LOG_FILE = $PSCommandPath_Split[0] + ".log"   # ������ɕϊ�����ꍇ�� "" �ň͂�
$LOG_FILE  # C:\Users\...\powershell\base_syntax\sample.log
Get-ChildItem README.md  2>&1 | Out-File  -Append $LOG_FILE
Get-ChildItem aaaa       2>&1 | Out-File  -Append $LOG_FILE


### Out-File -Encoding default �� UTF-16 LE
# Shift-Jis
Get-date -format "yyyyMMddHHmmss"  |  Out-File -Append $LOG_FILE
Get-date -format "yyyyMMddHHmmss"  |  Out-File -Append $LOG_FILE


### �z��
$Array += (1,3,5,7,9)
$Array.GetType()
# IsPublic IsSerial Name                                     BaseType
# -------- -------- ----                                     --------
# True     True     Object[]                                 System.Array
$Array[0]               # 1
$Array.GetValue(1)      # 3
$Array.Length           # 5


### if �f�B���N�g���E�t�@�C���L���i�ǂ�����w��\�j
if (Test-Path -Path $LOG_FILE ) {
    Write-Host "log file exists." -ForegroundColor white -BackgroundColor red
    Remove-Item $LOG_FILE
}

if ( -not (Test-Path -Path $LOG_FILE)) {
    New-Item $LOG_FILE -ItemType "file"
    Write-Output "make log file."  | Out-File -Append $LOG_FILE
}


### if ���l�̔�r
$count = 5
if ( $count -eq 5 ) {
    Write-Output "${count} �� 5 �ł��B"
} else {
    Write-Output "${count} �� 5 �ł͂���܂���B"
}
if ( $count -ne 5 ) {
    Write-Output "${count} �� 5 �ł͂���܂���B"
} else {
    Write-Output "${count} �� 5 �ł��B"
}
if ( $count -gt 5 ) {
    Write-Output "${count} �� 5 ���傫���B"
} else {
    Write-Output "${count} �� 5 �ȉ��B"
}
if ( $count -ge 5 ) {
    Write-Output "${count} �� 5 �ȏ�B"
} else {
    Write-Output "${count} �� 5 ��菬�����B"
}
if ( $count -lt 5 ) {
    Write-Output "${count} �� 5 ��菬�����B"
} else {
    Write-Output "${count} �� 5 �ȏ�B"
}
if ( $count -le 5 ) {
    Write-Output "${count} �� 5 �ȉ��B"
} else {
    Write-Output "${count} �� 5 ���傫���B"
}


### if ������̕�܁@�`�Ɋ܂܂��
if ($fruit -in @('�����S', '�C�`�S', '�T�N�����{')) {
    # ���� `$fruit` �������S�A�C�`�S�A�T�N�����{�̒��Ɋ܂܂�Ă����
}


#3# if ������̕�܁@�`���܂�
# -Contains �͉E���ɕϐ������� $null �l��������
if (@('�����S', '�C�`�S', '�T�N�����{') -Contains $fruit) {
    # ���������S�A�C�`�S�A�T�N�����{��`$fruit`���܂�ł����
}


### function
function test_function1 {
    Write-Output $msg  | Out-File -Append $LOG_FILE
}
test_function1 "test_function1"


### parameter check �X�N���v�g�ɑ΂��Ă��g�p�\
function test_function2 {
    Param
          (
              # [parameter(Mandatory)] �̓p�����[�^�K�{
              # [parameter(Mandatory=$false)] �̓p�����[�^�K�{�ł͂Ȃ�
              # [ValidateNotNullOrEmpty()] Null Empty �͋����Ȃ�
              # [ValidateRange(0, 999999)] �͈͎w�� �p�����w��\
              # [ValidateLength(1,100)] string�^ �������w��
              # [ValidateSet('m', 'f')] �w�肵���l�̂݋���
              # [ValidatePattern()] ���K�\���@�ȉ�MSDN�Q��
              # https://docs.microsoft.com/ja-jp/dotnet/standard/base-types/regular-expression-language-quick-reference?redirectedfrom=MSDN
            [parameter(Mandatory)][ValidateNotNullOrEmpty()][ValidateRange(0, 999999)][int32]$Studentid,
            [parameter(Mandatory)][AllowNull()][ValidateLength(1,100)][string]$StudentName,
            [parameter(Mandatory)][AllowEmptyString()][string]$StudentAddress,
            [parameter(Mandatory)][ValidateSet('m', 'f')][string]$StudentSex,
            [parameter(Mandatory=$false)][ValidatePattern("\d{1,3}")]$StudentAge = 12   # default�l
          )
    # ���k�ԍ�100011��Litium����(m)�ł��B�Z���͂ŁA12�΂ł��B
    Write-Output ("���k�ԍ�" + $Studentid + "��" + $StudentName + "����(" + $StudentSex + ")�ł��B�Z����" + $StudentAddress + "�ŁA" + $StudentAge + "�΂ł��B")
}
$Studentid=100011
$StudentName="Litium"
$StudentSex="m"
test_function2 $Studentid $StudentName $StudentAddress $StudentSex 


### �G���[�n���h�����O $ErrorActionPreference
$ErrorActionPreference                       # Continue (default)
Write-Error -Message "Error World! 1"        # �R���\�[���ɃG���[���b�Z�[�W���o�́@�����p��

$ErrorActionPreference = "SilentlyContinue"  # SilentlyContinue
Write-Error -Message "Error World! 2"        # �R���\�[���ɃG���[���b�Z�[�W���o�͂���Ȃ��@�����p��

$ErrorActionPreference = "Stop"              # Stop
#Write-Error -Message "Hello World! 5"       # �R���\�[���ɃG���[���b�Z�[�W���o�́@������~


### try catch finally
try
{
    Write-Error -Message "Error World! 3"   # Error catch �������~ �R���\�[�����b�Z�[�W�Ȃ�
    Write-Error -Message "Error World! 4"   # ���s����Ȃ�
}
catch    # ������~����G���[�������� catch �ɉ񂳂��
{
    Write-Output "�G���[���������܂���"  | Out-File -Append $LOG_FILE  # ���s�����
    $Error  | Out-File -Append $LOG_FILE  # $error �����O�ɏo��
}
finally  # �K�����s�����
{
    Write-Host "try end." -ForegroundColor white -BackgroundColor red
    $ErrorActionPreference = "Continue"     # Continue
}


### switch
# ��{
switch (2) {
    1 {"One."}
    2 {"Two."}
    3 {"Three."}
    default {"Not matched."}
}
# Two.

# �z�񓊓����A������ɂ��}�b�`���Ȃ��Ƃ� default
switch (2, 5) {
    1 {"One."}
    2 {"Two."}
    3 {"Three."}
    default {"Not matched."}
}
# Two.
# Not matched.

# break �Ő���
switch (2, 3) {
    1 {"One."}
    2 {"Two."; break}
    3 {"Three."}
    default {"Not matched."}
}
# Two.

# ������͑啶���������̔���͂��Ȃ�
switch ("Banana") {
    "banana" {"�������o�i�i"}
    "Banana" {"�ŏ������啶���o�i�i"}
    "BANANA" {"�啶���o�i�i"}
    default {"Not matched."}
}
# �������o�i�i
# �ŏ������啶���o�i�i
# �啶���o�i�i

# ������
switch (2) {
    {$_ -gt 2} {$_ }
    {$_ -eq 2} {$_ }
    {$_ -in (1, 2, 3)} {$_ }
    default {"Not matched."}
}
# 2�ł���
# 1, 2, 3�̂ǂꂩ�ł���B


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


### �e�L�X�g1�s���Ƃ̏���
$i=1
foreach ($l in Get-Content $PSScriptRoot\sample.txt) {
    Write-Output ("$i" + " : " + $l) | Out-File -Append $LOG_FILE
    $i++
}
# 1 : aaaaaaaa
# 2 : bbbbbbbb
# 3 : cccccccc


### �I�u�W�F�N�g����
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
Get-Process | Select-Object -property Id,ProcessName -first 5 | Out-File -Append $LOG_FILE    # �������Q��
Get-Process | Where-Object -filterScript {$_.Handles -gt 1000}  | Out-File -Append $LOG_FILE  # $_ �̓p�C�v���C���ɓn���ꂽ�I�u�W�F�N�g��\���ϐ�
Get-Process | Where-Object {$_.ProcessName -eq "AppVShNotify"} | ForEach-Object {Write-Output $_.ProcessName} | Out-File -Append $LOG_FILE  # ForEach-Object �z�񏈗�


### ���[�U�[��`�I�u�W�F�N�g�쐬�@New-Object
$arr = @()
$arr += New-Object PSObject -Property @{index=0; name="����������"; age=30}
$arr += New-Object PSObject -Property @{index=1; name="����������"; age=18}
$arr += New-Object PSObject -Property @{index=2; name="����������"; age=99}
$arr  | Out-File -Append $LOG_FILE


### ���[�U�[��`�I�u�W�F�N�g�쐬�@[PSCustomObject]
$ary = @()
$ary = @(("Name","Country","State"),("koizumi","jap","Tokyo"),("moromizato","jap","Okinawa"),("Mike","US","NY"))

# 1�ڂ̔z��� key �ɂ����I�u�W�F�N�g���쐬
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

### 2�����z�񂩂烆�[�U�[��`�I�u�W�F�N�g�ikey = Value�j�ɕϊ�
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
