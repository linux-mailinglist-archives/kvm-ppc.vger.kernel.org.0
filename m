Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECD5401A4C
	for <lists+kvm-ppc@lfdr.de>; Mon,  6 Sep 2021 13:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235607AbhIFLCX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 6 Sep 2021 07:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235072AbhIFLCV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 6 Sep 2021 07:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630926076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eNxNWW6ofdKTyY0muX6h95rIfheXNrr7plWK2DNQ3IQ=;
        b=h8j0XxFs7lRRCcgGTbQndI0g3YBLXN6FnKzuehm3gx+4DbbRqu03vnwCV6+dUp23HjKAfw
        /r6c1v8CDGqkk9eV9dSmFPzwe4s3amNgdRRnnqsCrz+5KpOHpo80Sra+8Q3w/UC5OumlBP
        1oIHSs6LCfsMxqyoHsDxri5thE8Cfzk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-jaLGHZcKO32fcaLhzyDwFA-1; Mon, 06 Sep 2021 07:01:15 -0400
X-MC-Unique: jaLGHZcKO32fcaLhzyDwFA-1
Received: by mail-ed1-f69.google.com with SMTP id g17-20020a056402425100b003cd5ba2852fso3521145edb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 06 Sep 2021 04:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eNxNWW6ofdKTyY0muX6h95rIfheXNrr7plWK2DNQ3IQ=;
        b=CUFYL634sz4X+L7cIGl+KP0xfniCHIBECi//WIaoJ404YnZqp9LxHeKbZ8AsT9NB2v
         jvxSKWHs3UuGrISdZPTvWrHQkQLV6GhjB8II430EfRmq2Z8x197TFyJLhWKNqwuHk7nH
         Ahtuva675mxMRTy9o2QQ9c/cq0MmmhxY+dBveYLyqeU2NW/oGaDEmkRhR2vWLQOE9IYF
         EUBARlq69JnrmDpaocnYu4zq5QabJPQcHzs2CZ1j1HCrue2tCIy/7tD43jgUYkfzbX2K
         IByYf2LApvC82QdyFJ2e62C/3FNBtVbRxI9ae2eoQ3/N6K4fvEjot71LFrqDWm7BQbCv
         +AjQ==
X-Gm-Message-State: AOAM533dsVp/NlBY26rvWGHkZF3p5Resp1gBspWm9zeDCH0h3ERs9gT7
        2OioUt364j51o3UJGae4uXhsWA56P4ErdTXDIh7+4dw33bvIMErv/lfWrxk07JAnwbCLVR1P9AL
        8I9o91+zcfVTPSH6rqA==
X-Received: by 2002:a17:906:f111:: with SMTP id gv17mr13016487ejb.315.1630926073563;
        Mon, 06 Sep 2021 04:01:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwK15z5c/E2D1thOBygdNrJtGO9DAle0e972HfdoN2MLeyeV73ugsIOUnA38Nb+5YYJxg7HUw==
X-Received: by 2002:a17:906:f111:: with SMTP id gv17mr13016442ejb.315.1630926073112;
        Mon, 06 Sep 2021 04:01:13 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id p5sm3673906eju.30.2021.09.06.04.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 04:01:12 -0700 (PDT)
Date:   Mon, 6 Sep 2021 13:01:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>, thuth@redhat.com,
        pbonzini@redhat.com, lvivier@redhat.com, kvm-ppc@vger.kernel.org,
        david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210906110111.zdra6afu7qdtnc7h@gator.home>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210712175219.132e22cc@slackpad.fritz.box>
 <c1f9ccbe-1d1c-cd06-0d46-ee493853672f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1f9ccbe-1d1c-cd06-0d46-ee493853672f@arm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 06, 2021 at 11:28:28AM +0100, Alexandru Elisei wrote:
> Hi Andre,
> 
> Thanks for having a look!
> 
> On 7/12/21 5:52 PM, Andre Przywara wrote:
> > On Fri,  2 Jul 2021 17:31:20 +0100
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >
> > Hi Alex,
> >
> >> Modify run_tests.sh to use kvmtool instead of qemu to run tests when
> >> kvm-unit-tests has been configured with --target=kvmtool.
> >>
> >> Example invocation:
> >>
> >> $ ./configure --target=kvmtool
> >> $ make clean && make
> >> $ ./run_scripts.sh
> >>
> >> A custom location for the kvmtool binary can be set using the environment
> >> variable KVMTOOL:
> >>
> >> $ KVMTOOL=/path/to/kvmtool/binary ./run_scripts.sh
> >>
> >> Standalone test support is absent, but will be added in subsequent patches.
> > So I skimmed over this, and it's at least better than what I had tried
> > a few years back ;-)
> > And while there might be other ways to sort out command line
> > differences between the two, this fixup_kvmtool_opts() looks like a
> > clever solution to the problem.
> >
> > The only problem with this patch is that it's rather big, I wonder if
> > this could be split up? For instance move any QEMU specific
> > functionality into separate functions first (like run_test_qemu()),
> > also use 'if [ "$TARGET" = "qemu" ]' in this first (or second?) patch.
> > Then later on just add the kvmtool specifics.
> 
> You're right, this patch looks very big and difficult to review, it needs to be
> split into smaller chunks for the next iteration.
> 
> Drew, did you manage to take a quick look at this patch? Do you think this is the
> right direction? I would prefer to hear your opinion about it before I start
> reworking it.

Afraid not. I'll prioritize finishing my review of this series though and
try to do it today or tomorrow.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> > Cheers,
> > Andre
> >
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  scripts/arch-run.bash   |  48 ++++++++++++++++--
> >>  scripts/runtime.bash    |  94 ++++++++++++++++++++++++++++------
> >>  scripts/mkstandalone.sh |   5 ++
> >>  arm/run                 | 110 ++++++++++++++++++++++++----------------
> >>  run_tests.sh            |  11 +++-
> >>  5 files changed, 204 insertions(+), 64 deletions(-)
> >>
> >> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> >> index 8ceed53ed7f8..b916b0e79aca 100644
> >> --- a/scripts/arch-run.bash
> >> +++ b/scripts/arch-run.bash
> >> @@ -69,16 +69,39 @@ run_qemu ()
> >>  	return $ret
> >>  }
> >>  
> >> +run_kvmtool()
> >> +{
> >> +	local stdout errors ret sig
> >> +
> >> +	# kvmtool doesn't allow an initrd argument with --firmware, but configure
> >> +	# sets CONFIG_ERRATA_FORCE in lib/config.h for the kvmtool target.
> >> +
> >> +	# stdout to {stdout}, stderr to $errors and stderr
> >> +	exec {stdout}>&1
> >> +	errors=$("${@}" </dev/null 2> >(tee /dev/stderr) > /dev/fd/$stdout)
> >> +	ret=$?
> >> +	exec {stdout}>&-
> >> +
> >> +	# ret=0 success, everything else is failure.
> >> +	return $ret
> >> +}
> >> +
> >>  run_test_status ()
> >>  {
> >> -	local stdout ret
> >> +	local stdout ret exit_status
> >>  
> >>  	exec {stdout}>&1
> >> -	lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
> >> +	if [ "$TARGET" = "kvmtool" ]; then
> >> +		lines=$(run_kvmtool "$@" > >(tee /dev/fd/$stdout))
> >> +		exit_status=0
> >> +	else
> >> +		lines=$(run_qemu "$@" > >(tee /dev/fd/$stdout))
> >> +		exit_status=1
> >> +	fi
> >>  	ret=$?
> >>  	exec {stdout}>&-
> >>  
> >> -	if [ $ret -eq 1 ]; then
> >> +	if [ $ret -eq $exit_status ]; then
> >>  		testret=$(grep '^EXIT: ' <<<"$lines" | sed 's/.*STATUS=\([0-9][0-9]*\).*/\1/')
> >>  		if [ "$testret" ]; then
> >>  			if [ $testret -eq 1 ]; then
> >> @@ -193,6 +216,25 @@ search_qemu_binary ()
> >>  	export PATH=$save_path
> >>  }
> >>  
> >> +search_kvmtool_binary ()
> >> +{
> >> +	local lkvm kvmtool
> >> +
> >> +	for lkvm in ${KVMTOOL:-lkvm vm lkvm-static}; do
> >> +		if $lkvm --help 2>/dev/null | grep -q 'The most commonly used'; then
> >> +			kvmtool="$lkvm"
> >> +			break
> >> +		fi
> >> +	done
> >> +
> >> +	if [ -z "$kvmtool" ]; then
> >> +		echo "A kvmtool binary was not found." >&2
> >> +		echo "You can set a custom location by using the KVMTOOL=<path> environment variable." >&2
> >> +		return 2
> >> +	fi
> >> +	command -v $kvmtool
> >> +}
> >> +
> >>  initrd_create ()
> >>  {
> >>  	if [ "$ENVIRON_DEFAULT" = "yes" ]; then
> >> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> >> index 132389c7dd59..23b238a6ab6f 100644
> >> --- a/scripts/runtime.bash
> >> +++ b/scripts/runtime.bash
> >> @@ -12,14 +12,19 @@ extract_summary()
> >>      tail -3 | grep '^SUMMARY: ' | sed 's/^SUMMARY: /(/;s/'"$cr"'\{0,1\}$/)/'
> >>  }
> >>  
> >> -# We assume that QEMU is going to work if it tried to load the kernel
> >> +# We assume that QEMU/kvmtool is going to work if it tried to load the kernel
> >>  premature_failure()
> >>  {
> >>      local log="$(eval $(get_cmdline _NO_FILE_4Uhere_) 2>&1)"
> >>  
> >> -    echo "$log" | grep "_NO_FILE_4Uhere_" |
> >> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> >> -        return 1
> >> +    if [ "$TARGET" = "kvmtool" ]; then
> >> +        echo "$log" | grep "Fatal: unable to load firmware image _NO_FILE_4Uhere_" &&
> >> +            return 1
> >> +    else
> >> +        echo "$log" | grep "_NO_FILE_4Uhere_" |
> >> +            grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> >> +            return 1
> >> +    fi
> >>  
> >>      RUNTIME_log_stderr <<< "$log"
> >>  
> >> @@ -30,7 +35,14 @@ premature_failure()
> >>  get_cmdline()
> >>  {
> >>      local kernel=$1
> >> -    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> >> +    local smp_param
> >> +
> >> +    if [ "$TARGET" = "kvmtool" ]; then
> >> +        smp_param="--cpus $smp"
> >> +    else
> >> +        smp_param="-smp $smp"
> >> +    fi
> >> +    echo "TESTNAME=$testname TIMEOUT=$timeout ACCEL=$accel $RUNTIME_arch_run $kernel $smp_param $opts"
> >>  }
> >>  
> >>  skip_nodefault()
> >> @@ -70,6 +82,35 @@ function find_word()
> >>      grep -Fq " $1 " <<< " $2 "
> >>  }
> >>  
> >> +fixup_kvmtool_opts()
> >> +{
> >> +    local opts=$1
> >> +    local groups=$2
> >> +    local gic
> >> +    local gic_version
> >> +
> >> +    if find_word "pmu" $groups; then
> >> +        opts+=" --pmu"
> >> +    fi
> >> +
> >> +    if find_word "its" $groups; then
> >> +        gic_version=3
> >> +        gic="gicv3-its"
> >> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> >> +        gic_version="${BASH_REMATCH[1]}"
> >> +        gic="gicv$gic_version"
> >> +    fi
> >> +
> >> +    if [ -n "$gic" ]; then
> >> +        opts=${opts/-machine gic-version=$gic_version/}
> >> +        opts+=" --irqchip=$gic"
> >> +    fi
> >> +
> >> +    opts=${opts/-append/--params}
> >> +
> >> +    echo "$opts"
> >> +}
> >> +
> >>  function run()
> >>  {
> >>      local testname="$1"
> >> @@ -105,7 +146,12 @@ function run()
> >>          return 2
> >>      fi
> >>  
> >> -    if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> >> +    if [ "$TARGET" = "kvmtool" ]; then
> >> +        if [ -n "$accel" ] && [ "$accel" != "kvm" ]; then
> >> +            print_result "SKIP" $testname "" "$accel not supported by kvmtool"
> >> +            return 2
> >> +        fi
> >> +    elif [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" != "$ACCEL" ]; then
> >>          print_result "SKIP" $testname "" "$accel only, but ACCEL=$ACCEL"
> >>          return 2
> >>      elif [ -n "$ACCEL" ]; then
> >> @@ -126,6 +172,10 @@ function run()
> >>          done
> >>      fi
> >>  
> >> +    if [ "$TARGET" = "kvmtool" ]; then
> >> +        opts=$(fixup_kvmtool_opts "$opts" "$groups")
> >> +    fi
> >> +
> >>      last_line=$(premature_failure > >(tail -1)) && {
> >>          print_result "SKIP" $testname "" "$last_line"
> >>          return 77
> >> @@ -165,13 +215,25 @@ function run()
> >>  #
> >>  # Probe for MAX_SMP, in case it's less than the number of host cpus.
> >>  #
> >> -# This probing currently only works for ARM, as x86 bails on another
> >> -# error first. Also, this probing isn't necessary for any ARM hosts
> >> -# running kernels later than v4.3, i.e. those including ef748917b52
> >> -# "arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'". So, at some
> >> -# point when maintaining the while loop gets too tiresome, we can
> >> -# just remove it...
> >> -while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> >> -		|& grep -qi 'exceeds max CPUs'; do
> >> -	MAX_SMP=$((MAX_SMP >> 1))
> >> -done
> >> +# This probing currently only works for ARM, as x86 bails on another error
> >> +# first. Also, this probing isn't necessary for any ARM hosts running kernels
> >> +# later than v4.3, i.e. those including ef748917b52 "arm/arm64: KVM: Remove
> >> +# 'config KVM_ARM_MAX_VCPUS'". So, at some point when maintaining the while loop
> >> +# gets too tiresome, we can just remove it...
> >> +#
> >> +# We don't need this check for kvmtool, as kvmtool will automatically limit the
> >> +# number of VCPUs to what the host supports instead of exiting with an error.
> >> +# kvmtool prints a message when that happens, but it's harmless and the chance
> >> +# of running a kernel so old that the number of VCPUs is smaller than the number
> >> +# of physical CPUs is vanishingly small.
> >> +#
> >> +# For qemu this check is still needed. For qemu-system-aarch64 version 6.0.0,
> >> +# using TCG, the maximum number of VCPUs that mach-virt supports is 8. If a test
> >> +# is running on a recent x86 machine, there's a fairly good chance that more
> >> +# than 8 logical CPUs are available.
> >> +if [ "$TARGET" = "qemu" ]; then
> >> +    while $RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP \
> >> +            |& grep -qi 'exceeds max CPUs'; do
> >> +        MAX_SMP=$((MAX_SMP >> 1))
> >> +    done
> >> +fi
> >> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> >> index cefdec30cb33..16f461c06842 100755
> >> --- a/scripts/mkstandalone.sh
> >> +++ b/scripts/mkstandalone.sh
> >> @@ -95,6 +95,11 @@ function mkstandalone()
> >>  	echo Written $standalone.
> >>  }
> >>  
> >> +if [ "$TARGET" = "kvmtool" ]; then
> >> +	echo "Standalone tests not supported with kvmtool"
> >> +	exit 2
> >> +fi
> >> +
> >>  if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ] && [ ! -f "$ERRATATXT" ]; then
> >>  	echo "$ERRATATXT not found. (ERRATATXT=$ERRATATXT)" >&2
> >>  	exit 2
> >> diff --git a/arm/run b/arm/run
> >> index a390ca5ae0ba..cc5890e7fec4 100755
> >> --- a/arm/run
> >> +++ b/arm/run
> >> @@ -8,59 +8,81 @@ if [ -z "$STANDALONE" ]; then
> >>  	source config.mak
> >>  	source scripts/arch-run.bash
> >>  fi
> >> -processor="$PROCESSOR"
> >>  
> >> -ACCEL=$(get_qemu_accelerator) ||
> >> -	exit $?
> >> +run_test_qemu()
> >> +{
> >> +    processor="$PROCESSOR"
> >>  
> >> -qemu=$(search_qemu_binary) ||
> >> -	exit $?
> >> +    ACCEL=$(get_qemu_accelerator) ||
> >> +        exit $?
> >>  
> >> -if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> >> -	echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> >> -	exit 2
> >> -fi
> >> +    qemu=$(search_qemu_binary) ||
> >> +        exit $?
> >>  
> >> -M='-machine virt'
> >> +    if ! $qemu -machine '?' 2>&1 | grep 'ARM Virtual Machine' > /dev/null; then
> >> +        echo "$qemu doesn't support mach-virt ('-machine virt'). Exiting."
> >> +        exit 2
> >> +    fi
> >>  
> >> -if [ "$ACCEL" = "kvm" ]; then
> >> -	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
> >> -		M+=',gic-version=host'
> >> -	fi
> >> -	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> >> -		processor="host"
> >> -		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> >> -			processor+=",aarch64=off"
> >> -		fi
> >> -	fi
> >> -fi
> >> +    M='-machine virt'
> >>  
> >> -if [ "$ARCH" = "arm" ]; then
> >> -	M+=",highmem=off"
> >> -fi
> >> +    if [ "$ACCEL" = "kvm" ]; then
> >> +        if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
> >> +            M+=',gic-version=host'
> >> +        fi
> >> +        if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
> >> +            processor="host"
> >> +            if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> >> +                processor+=",aarch64=off"
> >> +            fi
> >> +        fi
> >> +    fi
> >>  
> >> -if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> >> -	echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> >> -	exit 2
> >> -fi
> >> +    if [ "$ARCH" = "arm" ]; then
> >> +        M+=",highmem=off"
> >> +    fi
> >>  
> >> -if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
> >> -		| grep backend > /dev/null; then
> >> -	echo "$qemu doesn't support chr-testdev. Exiting."
> >> -	exit 2
> >> -fi
> >> +    if ! $qemu $M -device '?' 2>&1 | grep virtconsole > /dev/null; then
> >> +        echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
> >> +        exit 2
> >> +    fi
> >>  
> >> -chr_testdev='-device virtio-serial-device'
> >> -chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> >> +    if $qemu $M -chardev testdev,id=id -initrd . 2>&1 \
> >> +            | grep backend > /dev/null; then
> >> +        echo "$qemu doesn't support chr-testdev. Exiting."
> >> +        exit 2
> >> +    fi
> >>  
> >> -pci_testdev=
> >> -if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
> >> -	pci_testdev="-device pci-testdev"
> >> -fi
> >> +    chr_testdev='-device virtio-serial-device'
> >> +    chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
> >> +
> >> +    pci_testdev=
> >> +    if $qemu $M -device '?' 2>&1 | grep pci-testdev > /dev/null; then
> >> +        pci_testdev="-device pci-testdev"
> >> +    fi
> >> +
> >> +    M+=",accel=$ACCEL"
> >> +    command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
> >> +    command+=" -display none -serial stdio -kernel"
> >> +    command="$(migration_cmd) $(timeout_cmd) $command"
> >> +
> >> +    run_qemu $command "$@"
> >> +}
> >> +
> >> +run_test_kvmtool()
> >> +{
> >> +    kvmtool=$(search_kvmtool_binary) ||
> >> +        exit $?
> >>  
> >> -M+=",accel=$ACCEL"
> >> -command="$qemu -nodefaults $M -cpu $processor $chr_testdev $pci_testdev"
> >> -command+=" -display none -serial stdio -kernel"
> >> -command="$(migration_cmd) $(timeout_cmd) $command"
> >> +    local command="$(timeout_cmd) $kvmtool run --firmware "
> >> +    run_test_status $command "$@"
> >> +}
> >>  
> >> -run_qemu $command "$@"
> >> +case "$TARGET" in
> >> +    "qemu")
> >> +        run_test_qemu "$@"
> >> +        ;;
> >> +    "kvmtool")
> >> +        run_test_kvmtool "$@"
> >> +        ;;
> >> +esac
> >> diff --git a/run_tests.sh b/run_tests.sh
> >> index 65108e73a2c0..b010ee3ab348 100755
> >> --- a/run_tests.sh
> >> +++ b/run_tests.sh
> >> @@ -26,7 +26,9 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
> >>      -t, --tap13     Output test results in TAP format
> >>  
> >>  Set the environment variable QEMU=/path/to/qemu-system-ARCH to
> >> -specify the appropriate qemu binary for ARCH-run.
> >> +specify the appropriate qemu binary for ARCH-run. For arm/arm64, kvmtool
> >> +is also supported and the environment variable KVMTOOL=/path/to/kvmtool
> >> +can be used to specify a custom location for the kvmtool binary.
> >>  
> >>  EOF
> >>  }
> >> @@ -41,6 +43,13 @@ if [ $? -ne 4 ]; then
> >>      exit 1
> >>  fi
> >>  
> >> +if [ "$TARGET" = "kvmtool" ]; then
> >> +    if [ -n "$ACCEL" ] && [ "$ACCEL" != "kvm" ]; then
> >> +        echo "kvmtool supports only the kvm accelerator"
> >> +        exit 1
> >> +    fi
> >> +fi
> >> +
> >>  only_tests=""
> >>  args=`getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbose -- $*`
> >>  [ $? -ne 0 ] && exit 2;
> 

