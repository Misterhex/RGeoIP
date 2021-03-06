function CreateNuPack() {
    remove-item .\NuPack -force -recurse -erroraction silentlycontinue
    mkdir NuPack
    mkdir NuPack\lib
    mkdir NuPack\lib\net40
    mkdir NuPack\tools
    mkdir NuPack\content
    
    Copy-Item .\Build\RGeoIP*.* .\NuPack\lib\net40    
    Remove-Item .\NuPack\lib\net40\*Tests.*
      
    $version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo((ls .\NuPack\lib\net40\*.dll).FullName).FileVersion
    $nupack = [xml](get-content .\RGeoIP.nuspec)
    $nupack.package.metadata.version = $version
    
    $writerSettings = new-object System.Xml.XmlWriterSettings
    $writerSettings.OmitXmlDeclaration = $true
    $writerSettings.NewLineOnAttributes = $true
    $writerSettings.Indent = $true
    
    $base_dir  = resolve-path .
    
    $writer = [System.Xml.XmlWriter]::Create("$base_dir\Nupack\RGeoIP.nuspec", $writerSettings)

    $nupack.WriteTo($writer)
    $writer.Flush()
    $writer.Close()
      
    ./.nuget/nuget.exe pack .\NuPack\RGeoIP.nuspec
}

function BuildSolution() {
    remove-item .\Build -force -recurse -erroraction silentlycontinue
    
    $v4_net_version = (ls "$env:windir\Microsoft.NET\Framework\v4.0*").Name    
    
    &"C:\Windows\Microsoft.NET\Framework\$v4_net_version\MSBuild.exe" ".\RGeoIP.sln" /p:OutDir="..\Build\" /p:Configuration=Release
}

function Clean() {
    remove-item .\NuPack -force -recurse -erroraction silentlycontinue
    remove-item .\Build -force -recurse -erroraction silentlycontinue
}

BuildSolution
CreateNuPack
Clean
