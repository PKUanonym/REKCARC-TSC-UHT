#!/bin/sh

verbose=false
if [ "x$1" = "x-v" ]; then
    verbose=true
    out=/dev/stdout
    err=/dev/stderr
else
    out=/dev/null
    err=/dev/null
fi

## make & makeopts
if gmake --version > /dev/null 2>&1; then
    make=gmake;
else
    make=make;
fi

makeopts="--quiet --no-print-directory -j"

make_print() {
    echo `$make $makeopts print-$1`
}

## command tools
awk='awk'
bc='bc'
date='date'
grep='grep'
rm='rm -f'
sed='sed'

## symbol table
sym_table='obj/kernel.sym'

## gdb & gdbopts
gdb="$(make_print GDB)"
gdbport='1234'

gdb_in="$(make_print GRADE_GDB_IN)"

## qemu & qemuopts
qemu="$(make_print qemu)"

qemu_out="$(make_print GRADE_QEMU_OUT)"

if $qemu -nographic -help | grep -q '^-gdb'; then
    qemugdb="-gdb tcp::$gdbport"
else
    qemugdb="-s -p $gdbport"
fi

## default variables
default_timeout=30
default_pts=5

pts=5
part=0
part_pos=0
total=0
total_pos=0

## default functions
update_score() {
    total=`expr $total + $part`
    total_pos=`expr $total_pos + $part_pos`
    part=0
    part_pos=0
}

get_time() {
    echo `$date +%s.%N 2> /dev/null`
}

show_part() {
    echo "Part $1 Score: $part/$part_pos"
    echo
    update_score
}

show_final() {
    update_score
    echo "Total Score: $total/$total_pos"
    if [ $total -lt $total_pos ]; then
        exit 1
    fi
}

show_time() {
    t1=$(get_time)
    time=`echo "scale=1; ($t1-$t0)/1" | $sed 's/.N/.0/g' | $bc 2> /dev/null`
    echo "(${time}s)"
}

show_build_tag() {
    echo "$1:" | $awk '{printf "%-24s ", $0}'
}

show_check_tag() {
    echo "$1:" | $awk '{printf "  -%-40s  ", $0}'
}

show_msg() {
    echo $1
    shift
    if [ $# -gt 0 ]; then
        echo -e "$@" | awk '{printf "   %s\n", $0}'
        echo
    fi
}

pass() {
    show_msg OK "$@"
    part=`expr $part + $pts`
    part_pos=`expr $part_pos + $pts`
}

fail() {
    show_msg WRONG "$@"
    part_pos=`expr $part_pos + $pts`
}

run_qemu() {
    # Run qemu with serial output redirected to $qemu_out. If $brkfun is non-empty,
    # wait until $brkfun is reached or $timeout expires, then kill QEMU
    qemuextra=
    if [ "$brkfun" ]; then
        qemuextra="-S $qemugdb"
    fi

    if [ -z "$timeout" ] || [ $timeout -le 0 ]; then
        timeout=$default_timeout;
    fi

    t0=$(get_time)
    (
        ulimit -t $timeout
        exec $qemu -nographic $qemuopts -serial file:$qemu_out -monitor null -no-reboot $qemuextra
    ) > $out 2> $err &
    pid=$!

    # wait for QEMU to start
    sleep 1

    if [ -n "$brkfun" ]; then
        # find the address of the kernel $brkfun function
        brkaddr=`$grep " $brkfun\$" $sym_table | $sed -e's/ .*$//g'`
        brkaddr_phys=`echo $brkaddr | sed "s/^c0/00/g"`
        (
            echo "target remote localhost:$gdbport"
            echo "break *0x$brkaddr"
            if [ "$brkaddr" != "$brkaddr_phys" ]; then
                echo "break *0x$brkaddr_phys"
            fi
            echo "continue"
        ) > $gdb_in

        $gdb -batch -nx -x $gdb_in > /dev/null 2>&1

        # make sure that QEMU is dead
        # on OS X, exiting gdb doesn't always exit qemu
        kill $pid > /dev/null 2>&1
    fi
}

build_run() {
    # usage: build_run <tag> <args>
    show_build_tag "$1"
    shift

    if $verbose; then
        echo "$make $@ ..."
    fi
    $make $makeopts $@ 'DEFS+=-DDEBUG_GRADE' > $out 2> $err

    if [ $? -ne 0 ]; then
        echo $make $@ failed
        exit 1
    fi

    # now run qemu and save the output
    run_qemu

    show_time

    cp $qemu_out .`echo $tag | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g'`.log
}

check_result() {
    # usage: check_result <tag> <check> <check args...>
    show_check_tag "$1"
    shift

    # give qemu some time to run (for asynchronous mode)
    if [ ! -s $qemu_out ]; then
        sleep 4
    fi

    if [ ! -s $qemu_out ]; then
        fail > /dev/null
        echo 'no $qemu_out'
    else
        check=$1
        shift
        $check "$@"
    fi
}

check_regexps() {
    okay=yes
    not=0
    reg=0
    error=
    for i do
        if [ "x$i" = "x!" ]; then
            not=1
        elif [ "x$i" = "x-" ]; then
            reg=1
        else
            if [ $reg -ne 0 ]; then
                $grep '-E' "^$i\$" $qemu_out > /dev/null
            else
                $grep '-F' "$i" $qemu_out > /dev/null
            fi
            found=$(($? == 0))
            if [ $found -eq $not ]; then
                if [ $found -eq 0 ]; then
                    msg="!! error: missing '$i'"
                else
                    msg="!! error: got unexpected line '$i'"
                fi
                okay=no
                if [ -z "$error" ]; then
                    error="$msg"
                else
                    error="$error\n$msg"
                fi
            fi
            not=0
            reg=0
        fi
    done
    if [ "$okay" = "yes" ]; then
        pass
    else
        fail "$error"
        if $verbose; then
            exit 1
        fi
    fi
}

run_test() {
    # usage: run_test [-tag <tag>] [-prog <prog>] [-Ddef...] [-check <check>] checkargs ...
    tag=
    prog=
    check=check_regexps
    while true; do
        select=
        case $1 in
            -tag|-prog)
                select=`expr substr $1 2 ${#1}`
                eval $select='$2'
                ;;
        esac
        if [ -z "$select" ]; then
            break
        fi
        shift
        shift
    done
    defs=
    while expr "x$1" : "x-D.*" > /dev/null; do
        defs="DEFS+='$1' $defs"
        shift
    done
    if [ "x$1" = "x-check" ]; then
        check=$2
        shift
        shift
    fi

    if [ -z "$prog" ]; then
        $make $makeopts touch > /dev/null 2>&1
        args="$defs"
    else
        if [ -z "$tag" ]; then
            tag="$prog"
        fi
        args="build-$prog $defs"
    fi

    build_run "$tag" "$args"

    check_result 'check result' "$check" "$@"
}

quick_run() {
    # usage: quick_run <tag> [-Ddef...]
    tag="$1"
    shift
    defs=
    while expr "x$1" : "x-D.*" > /dev/null; do
        defs="DEFS+='$1' $defs"
        shift
    done

    $make $makeopts touch > /dev/null 2>&1
    build_run "$tag" "$defs"
}

quick_check() {
    # usage: quick_check <tag> checkargs ...
    tag="$1"
    shift
    check_result "$tag" check_regexps "$@"
}

## kernel image
osimg=$(make_print ucoreimg)

## sfs image
sfsimg=$(make_print sfsimg)

## swap image
swapimg=$(make_print swapimg)

## set default qemu-options
qemuopts="-hda $osimg -drive file=$swapimg,media=disk,cache=writeback -drive file=$sfsimg,media=disk,cache=writeback"

## set break-function, default is readline
brkfun=readline

default_check() {
    pts=7
    check_regexps "$@"

    pts=3
    quick_check 'check output'                                  \
    'memory management: default_pmm_manager'                      \
    'check_alloc_page() succeeded!'                             \
    'check_pgdir() succeeded!'                                  \
    'check_boot_pgdir() succeeded!'				\
    'PDE(0e0) c0000000-f8000000 38000000 urw'                   \
    '  |-- PTE(38000) c0000000-f8000000 38000000 -rw'           \
    'PDE(001) fac00000-fb000000 00400000 -rw'                   \
    '  |-- PTE(000e0) faf00000-fafe0000 000e0000 urw'           \
    '  |-- PTE(00001) fafeb000-fafec000 00001000 -rw'		\
    'check_vma_struct() succeeded!'                             \
    'page fault at 0x00000100: K/W [no page found].'            \
    'check_pgfault() succeeded!'                                \
    'check_vmm() succeeded.'					\
    'page fault at 0x00001000: K/W [no page found].'            \
    'page fault at 0x00002000: K/W [no page found].'            \
    'page fault at 0x00003000: K/W [no page found].'            \
    'page fault at 0x00004000: K/W [no page found].'            \
    'write Virt Page e in fifo_check_swap'			\
    'page fault at 0x00005000: K/W [no page found].'		\
    'page fault at 0x00001000: K/W [no page found]'		\
    'page fault at 0x00002000: K/W [no page found].'		\
    'page fault at 0x00003000: K/W [no page found].'		\
    'page fault at 0x00004000: K/W [no page found].'		\
    'check_swap() succeeded!'					\
    '++ setup timer interrupts'
}

## check now!!

run_test -prog 'badsegment' -check default_check                \
      - 'kernel_execve: pid = ., name = "badsegment".*'          \
      - 'trapframe at 0xc.......'                               \
        'trap 0x0000000d General Protection'                    \
        '  err  0x00000028'                                     \
      - '  eip  0x008.....'                                     \
      - '  esp  0xaff.....'                                     \
        '  cs   0x----001b'                                     \
        '  ss   0x----0023'                                     \
    ! - 'user panic at .*'

run_test -prog 'divzero' -check default_check                   \
      - 'kernel_execve: pid = ., name = "divzero".*'             \
      - 'trapframe at 0xc.......'                               \
        'trap 0x00000000 Divide error'                          \
      - '  eip  0x008.....'                                     \
      - '  esp  0xaff.....'                                     \
        '  cs   0x----001b'                                     \
        '  ss   0x----0023'                                     \
    ! - 'user panic at .*'

run_test -prog 'softint' -check default_check                   \
      - 'kernel_execve: pid = ., name = "softint".*'             \
      - 'trapframe at 0xc.......'                               \
        'trap 0x0000000d General Protection'                    \
        '  err  0x00000072'                                     \
      - '  eip  0x008.....'                                     \
      - '  esp  0xaff.....'                                     \
        '  cs   0x----001b'                                     \
        '  ss   0x----0023'                                     \
    ! - 'user panic at .*'

pts=10

run_test -prog 'faultread'  -check default_check                                     \
      - 'kernel_execve: pid = ., name = "faultread".*'           \
      - 'trapframe at 0xc.......'                               \
        'trap 0x0000000e Page Fault'                            \
        '  err  0x00000004'                                     \
      - '  eip  0x008.....'                                     \
    ! - 'user panic at .*'

run_test -prog 'faultreadkernel' -check default_check                                \
      - 'kernel_execve: pid = ., name = "faultreadkernel".*'     \
      - 'trapframe at 0xc.......'                               \
        'trap 0x0000000e Page Fault'                            \
        '  err  0x00000005'                                     \
      - '  eip  0x008.....'                                     \
    ! - 'user panic at .*'

run_test -prog 'hello' -check default_check                                          \
      - 'kernel_execve: pid = ., name = "hello".*'               \
        'Hello world!!.'                                        \
      - 'I am process .*'                                       \
        'hello pass.'

run_test -prog 'testbss' -check default_check                                        \
      - 'kernel_execve: pid = ., name = "testbss".*'             \
        'Making sure bss works right...'                        \
        'Yes, good.  Now doing a wild write off the end...'     \
        'testbss may pass.'                                     \
      - 'trapframe at 0xc.......'                               \
        'trap 0x0000000e Page Fault'                            \
        '  err  0x00000006'                                     \
      - '  eip  0x008.....'                                     \
        'killed by kernel.'                                     \
    ! - 'user panic at .*'

run_test -prog 'pgdir' -check default_check                                          \
      - 'kernel_execve: pid = ., name = "pgdir".*'               \
      - 'I am .*'                                  \
        'PDE(001) 00800000-00c00000 00400000 urw'               \
        '  |-- PTE(00002) 00800000-00802000 00002000 ur-'       \
        '  |-- PTE(00001) 00802000-00803000 00001000 urw'       \
        'PDE(001) afc00000-b0000000 00400000 urw'               \
        '  |-- PTE(00004) afffc000-b0000000 00004000 urw'       \
        'PDE(0e0) c0000000-f8000000 38000000 urw'               \
        '  |-- PTE(38000) c0000000-f8000000 38000000 -rw'       \
        'pgdir pass.'

run_test -prog 'yield' -check default_check                                          \
      - 'kernel_execve: pid = ., name = "yield".*'               \
        'Hello, I am process 2.'                                \
      - 'Back in process ., iteration 0.'                       \
      - 'Back in process ., iteration 1.'                       \
      - 'Back in process ., iteration 2.'                       \
      - 'Back in process ., iteration 3.'                       \
      - 'Back in process ., iteration 4.'                       \
      - 'All done in process .*'                                \
        'yield pass.'


run_test -prog 'badarg' -check default_check                    \
      - 'kernel_execve: pid = ., name = "badarg".*'              \
        'fork ok.'                                              \
        'badarg pass.'                                          \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

pts=10

run_test -prog 'exit'  -check default_check                                          \
      - 'kernel_execve: pid = ., name = "exit".*'                \
        'I am the parent. Forking the child...'                 \
        'I am the parent, waiting now..'                        \
        'I am the child.'                                       \
      - 'waitpid [0-9]+ ok\.'                                   \
        'exit pass.'                                            \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

run_test -prog 'spin'  -check default_check                                          \
      - 'kernel_execve: pid = ., name = "spin".*'                \
        'I am the parent. Forking the child...'                 \
        'I am the parent. Running the child...'                 \
        'I am the child. spinning ...'                          \
        'I am the parent.  Killing the child...'                \
        'kill returns 0'                                        \
        'wait returns 0'                                        \
        'spin may pass.'                                        \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

run_test -prog 'waitkill'  -check default_check                                      \
      - 'kernel_execve: pid = ., name = "waitkill".*'            \
        'wait child 1.'                                         \
        'child 2.'                                              \
        'child 1.'                                              \
        'kill parent ok.'                                       \
        'kill child1 ok.'                                       \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

pts=15

run_test -prog 'forktest'   -check default_check                                     \
      - 'kernel_execve: pid = ., name = "forktest".*'            \
        'I am child 31'                                         \
        'I am child 19'                                         \
        'I am child 13'                                         \
        'I am child 0'                                          \
        'forktest pass.'                                        \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'fork claimed to work [0-9]+ times!'                    \
    !   'wait stopped early'                                    \
    !   'wait got too many'                                     \
    ! - 'user panic at .*'

pts=10
run_test -prog 'forktree'    -check default_check               \
      - 'kernel_execve: pid = ., name = "forktree".*'            \
      - '....: I am '\'''\'                                     \
      - '....: I am '\''0'\'                                    \
      - '....: I am '\'''\'                                     \
      - '....: I am '\''1'\'                                    \
      - '....: I am '\''0'\'                                    \
      - '....: I am '\''01'\'                                   \
      - '....: I am '\''00'\'                                   \
      - '....: I am '\''11'\'                                   \
      - '....: I am '\''10'\'                                   \
      - '....: I am '\''101'\'                                  \
      - '....: I am '\''100'\'                                  \
      - '....: I am '\''111'\'                                  \
      - '....: I am '\''110'\'                                  \
      - '....: I am '\''001'\'                                  \
      - '....: I am '\''000'\'                                  \
      - '....: I am '\''011'\'                                  \
      - '....: I am '\''010'\'                                  \
      - '....: I am '\''0101'\'                                 \
      - '....: I am '\''0100'\'                                 \
      - '....: I am '\''0111'\'                                 \
      - '....: I am '\''0110'\'                                 \
      - '....: I am '\''0001'\'                                 \
      - '....: I am '\''0000'\'                                 \
      - '....: I am '\''0011'\'                                 \
      - '....: I am '\''0010'\'                                 \
      - '....: I am '\''1101'\'                                 \
      - '....: I am '\''1100'\'                                 \
      - '....: I am '\''1111'\'                                 \
      - '....: I am '\''1110'\'                                 \
      - '....: I am '\''1001'\'                                 \
      - '....: I am '\''1000'\'                                 \
      - '....: I am '\''1011'\'                                 \
      - '....: I am '\''1010'\'                                 \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'

pts=20
timeout=150
run_test -prog 'priority'      -check default_check             \
	'sched class: stride_scheduler'                         \
      - 'kernel_execve: pid = ., name = "priority".*'            \
        'main: fork ok,now need to wait pids.'                  \
        'stride sched correct result: 1 2 3 4 5'                \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

pts=20
timeout=240

run_test -prog 'sleep'         -check default_check             \
      - 'kernel_execve: pid = ., name = "sleep".*'               \
        'sleep 1 x 100 slices.'                                 \
        'sleep 3 x 100 slices.'                                 \
        'sleep 7 x 100 slices.'                                 \
        'sleep 10 x 100 slices.'                                \
      - 'use 1... msecs.'                                       \
        'sleep pass.'                                           \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    !   '  trap 0x0000000e Page Fault'                          \
    !   'killed by kernel.'                                     \
    ! - 'user panic at .*'

pts=20
timeout=240
run_test -prog 'sleepkill'   -check default_check               \
      - 'kernel_execve: pid = ., name = "sleepkill".*'           \
        'sleepkill pass.'                                       \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

pts=40
timeout=500
run_test -prog 'matrix'     -check default_check                \
        'Iter 1, No.0 philosopher_sema is thinking'                  \
        'Iter 1, No.1 philosopher_sema is thinking'                  \
        'Iter 1, No.2 philosopher_sema is thinking'                  \
        'Iter 1, No.3 philosopher_sema is thinking'                  \
        'Iter 1, No.4 philosopher_sema is thinking'                  \
        'Iter 1, No.0 philosopher_sema is eating'                  \
        'Iter 1, No.1 philosopher_sema is eating'                  \
        'Iter 1, No.2 philosopher_sema is eating'                  \
        'Iter 1, No.3 philosopher_sema is eating'                  \
        'Iter 1, No.4 philosopher_sema is eating'                  \
        'No.0 philosopher_sema quit'                                \
        'No.1 philosopher_sema quit'                                \
        'No.2 philosopher_sema quit'                                \
        'No.3 philosopher_sema quit'                                \
        'No.4 philosopher_sema quit'                                \
        'Iter 1, No.0 philosopher_condvar is thinking'                  \
        'Iter 1, No.1 philosopher_condvar is thinking'                  \
        'Iter 1, No.2 philosopher_condvar is thinking'                  \
        'Iter 1, No.3 philosopher_condvar is thinking'                  \
        'Iter 1, No.4 philosopher_condvar is thinking'                  \
        'Iter 1, No.0 philosopher_condvar is eating'                  \
        'Iter 1, No.1 philosopher_condvar is eating'                  \
        'Iter 1, No.2 philosopher_condvar is eating'                  \
        'Iter 1, No.3 philosopher_condvar is eating'                  \
        'Iter 1, No.4 philosopher_condvar is eating'                  \
        'No.0 philosopher_condvar quit'                                \
        'No.1 philosopher_condvar quit'                                \
        'No.2 philosopher_condvar quit'                                \
        'No.3 philosopher_condvar quit'                                \
        'No.4 philosopher_condvar quit'                                \
      - 'kernel_execve: pid = ., name = "matrix".*'              \
        'fork ok.'                                              \
        'pid 13 done!.'                                         \
        'pid 17 done!.'                                         \
        'pid 23 done!.'                                         \
        'matrix pass.'                                          \
        'all user-mode processes have quit.'                    \
        'init check memory pass.'                               \
    ! - 'user panic at .*'

## print final-score
show_final
