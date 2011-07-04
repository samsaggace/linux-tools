#!/bin/bash
shname=`echo "$0" | awk -F / '{print $NF}'`

if [ ${#} -ne 2 ]
then
   echo "--------------------------------------------------------------------------------"
   echo "Usage : $shname [sh4 dump tool] [obj file | obj directory]"
   echo "   Examples on OS21 : $shname sh4objdump drv_sagem/CLKRV/OBJ/clkrv.o"
   echo "                      $shname sh4objdump drv_sagem/CLKRV/OBJ"
   echo "                      $shname sh4objdump sagem_app/main_tt.out"
   echo "--------------------------------------------------------------------------------"
   exit 1
fi

objdumpbin=$1

get_alloc_size()
{
  size=0
  size_list=`$objdumpbin -h $1 | grep -B 1 ALLOC | grep -v ALLOC | awk '{print $3}' | xargs`
  for section_size in $size_list
  do
     size=$((size+16#$section_size))
  done
  echo $size
}

print_obj_size()
{
   obj_list=`find $1 -type f -iname "*.dbg" && find $1 -type f -iname "*.o" && find $1 -type f -iname "*.tco"`

   for item in $obj_list
   do
     printf "%10d %s\n" $(get_alloc_size $item) $item
   done
}

print_detailed_size()
{
   IFS="
"
   size_list=`$objdumpbin -h $1 | grep -B 1 ALLOC | grep -v ALLOC`
   for line in $size_list
   do
      size=$((16#`echo $line | awk '{print $3}'`))
      section=`echo $line | awk '{print $2}'`
      printf "%10d %s\n" $size $section
   done
}

print_symbol_size()
{
   IFS="
"
   symbol_list=`$objdumpbin -t $1 | grep -v "\*UND\*" | grep -v "$1"`
   for line in $symbol_list
   do
      section=`echo $line | awk '{print $4}'`
      symbol=`echo $line | awk '{print $6}'`
      if test "$symbol" != ""
      then
         size=$((16#`echo $line | awk '{print $5}'`))
         printf "%10d (%s) %s\n" $size $section $symbol
      fi
   done
}


unset IFS
if [ -f $2 ]
then
   printf "Allocated size for object $2 : %d bytes\n" $(get_alloc_size $2)
   printf "\nSections size (in bytes) :\n"
   print_detailed_size $2 | sort -b -n -k 1 -r
   printf "\nSymbol size (in bytes) :\n"
   print_symbol_size $2 | sort -b -n -k 1 -r
else
   echo "Allocated size (in bytes) for objects in $2 :"
   print_obj_size $2 | sort -b -n -k 1 -r
fi

