<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-LocalAdministrator {
    param(
        $Name,
        $Password
    )

    $cn = [ADSI]"WinNT://$($env:COMPUTERNAME)"
    $user = $cn.Create("User", $Name)
    $user.SetPassword($Password)
    $user.setinfo()
    $user.description = "Local administrator"
    $user.SetInfo()

    $adminGroup = [ADSI]"WinNT://$($env:COMPUTERNAME)/administrators, group"
    $adminGroup.Add($user.Path)
}