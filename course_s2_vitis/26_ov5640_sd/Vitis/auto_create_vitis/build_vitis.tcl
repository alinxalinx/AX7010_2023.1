set tclPath [pwd]
cd $tclPath
cd ..
set projpath [pwd]
puts "Current workspace is $projpath"
setws $projpath
getws
set xsaName design_1_wrapper
set appName ov5640_sd

#Create a new platform
platform create -name $xsaName -hw $projpath/$xsaName.xsa -proc ps7_cortexa9_0 -os standalone -arch 32-bit -out $projpath
importprojects $projpath/$xsaName
platform active $xsaName
repo -add-platforms $xsaName
importsources -name $xsaName/zynq_fsbl -path $tclPath/src/fsbl -target-path ./
domain active
#Create a new application
app create -name $appName -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $appName -path $tclPath/src/$appName
bsp setlib -name xilffs -ver 5.0
bsp regenerate
#Build platform project
platform generate
#Build application project
append appName "_system"
sysproj build -name $appName






