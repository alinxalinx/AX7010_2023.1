set tclPath [pwd]
cd $tclPath
cd ..
set projpath [pwd]
puts "Current workspace is $projpath"
setws $projpath
getws
set xsaName design_1_wrapper
set app0Name lwip_tcp_update
set app1Name lwip_udp_update

#Create a new platform
platform create -name $xsaName -hw $projpath/$xsaName.xsa -proc ps7_cortexa9_0 -os standalone -arch 32-bit -out $projpath
importprojects $projpath/$xsaName
platform active $xsaName
repo -add-platforms $xsaName
importsources -name $xsaName/zynq_fsbl -path $tclPath/src/fsbl -target-path ./
domain active
#Create a new application
app create -name $app0Name -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $app0Name -path $tclPath/src/$app0Name
app create -name $app1Name -platform $xsaName -domain standalone_domain -template "Empty Application"
importsources -name $app1Name -path $tclPath/src/$app1Name
bsp setlib -name lwip213 -ver 1.0
bsp config dhcp_does_arp_check true
bsp config lwip_dhcp true
bsp config mem_size 134217728
bsp config memp_n_pbuf 4096
bsp config memp_n_tcp_pcb 1024
bsp config memp_n_tcp_seg 1024
bsp config pbuf_pool_bufsize 2000
bsp config pbuf_pool_size 4096
bsp config tcp_snd_buf 65535
bsp config tcp_wnd 65535
bsp regenerate
#Build platform project
platform generate
#Build application project
append app0Name "_system"
sysproj build -name $app0Name
append app1Name "_system"
sysproj build -name $app1Name






