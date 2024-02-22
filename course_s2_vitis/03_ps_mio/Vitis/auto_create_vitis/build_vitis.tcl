set tclPath [pwd]
cd $tclPath
cd ..
set projpath [pwd]
puts "Current workspace is $projpath"
setws $projpath
getws
set xsaName design_1_wrapper
set app0Name ps_key
set app1Name ps_led
set app2Name xgpiops_polled_example_1


#Create a new platform
platform create -name $xsaName -hw $projpath/$xsaName.xsa -proc ps7_cortexa9_0 -os standalone -arch 32-bit -out $projpath
importprojects $projpath/$xsaName
platform active $xsaName
repo -add-platforms $xsaName
importsources -name $xsaName/zynq_fsbl -path $tclPath/src/fsbl -target-path ./

domain active
#Create a new application
app create -name $app0Name -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $app0Name -path $tclPath/src/$app0Name -linker-script
app create -name $app1Name -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $app1Name -path $tclPath/src/$app1Name -linker-script
app create -name $app2Name -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $app2Name -path $tclPath/src/$app2Name

#Build platform project
platform generate
#Build application project
append app0Name "_system"
sysproj build -name $app0Name
append app1Name "_system"
sysproj build -name $app1Name
append app2Name "_system"
sysproj build -name $app2Name






