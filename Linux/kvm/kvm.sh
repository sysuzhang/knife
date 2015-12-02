#!/bin/sh

function_create()
{
	echo "============================="
	echo "# Create Virtual Machine"
	isofile=""
	read -p "Please select OS Filename with path:" isofile
	imgfile="./image.qcow"
	read -p "Please Input the Image Disk Filename(Default: ./image.qcow):" imgfile
	if [ "$imgfile" = "" ]; then
	     imgfile="./image.qcow"
	fi
	echo "The image file is : $imgfile";
	filesize=2
	read -p "Please Input the Image Disk Size:(G)(Default:2G)" filesize
	if [ "$filesize" = "" ] || [ $filesize -lt 0 ] || [ $filesize -eq 0] ; then
	  filesize=2
	fi; 
	qemu-img create -f qcow2 $imgfile $filesize."G"

	vname=""
	read -p "Please Input the Virsual Machine Name(Default: VM_Rongjie):" vname
	if [ "$vname" = "" ]; then
	    vname="VM_Rongjie"
	fi
	vram=1024
	read -p "Please set the VM Ram size(M) (Default: 1024M):" vram
	if [ "$vram" = "" ] || [ $vram -lt 0 ]; then
	   vram=1024 
	fi
	echo "VM Ram Size Is: $vram."

	vcpus=1
	read -p "Please set VM cpu core number(Default:2):" vcpus
	if [ "$vcpus" = "" ] || [ $vcpus -lt 0 ]; then
	    vcpus=1;
	fi

	vncport=5903
	read -p "Please Input the VNC Viewer Port Number(Default:5903):" vncport
	if [ "$vncport" = "" ] || [ $vncport -lt 0 ]; then
	     vncport=5903
	fi

	echo "Begin to Install OS System:"
	virt-install --connect qemu:///system \
	--name $vname \
	--ram  $vram \
	--vcpus=$vcpus \
	--disk path=$imgfile,device=disk,format=qcow2,bus=ide,cache=writeback,size=15 \
	--cdrom  $isofile \
	--hvm \
	--network network=default \
	--graphics vnc,listen=0.0.0.0,port=$vncport \
	--virt-type=kvm \
	--noautoconsole
}

function_start()
{
       echo "Starting $1....."
       virsh -c qemu:///system start $1
}

case "$1" in
     create)
           function_create
           ;;
     start)
           function_start $2
           ;;
     *)
          printf "Usage:kvm{create|start|stop}\n"
esac



