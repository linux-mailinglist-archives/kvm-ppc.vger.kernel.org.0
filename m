Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C824B443203
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Nov 2021 16:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhKBPvS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Nov 2021 11:51:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57664 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbhKBPvM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Nov 2021 11:51:12 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 08C8221639;
        Tue,  2 Nov 2021 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635868117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oei/Vl5aP6rLS5lpkscnCj7v3fQPmBAplgA77ous6I0=;
        b=fG+fkNhe+opTnWtTwExBlRfQQ5FwT4IL1gPoGT003O+Znid881GXyGqNs5Cb/ragtUjOTi
        i5h6K7N2uD5ltOsceWk0PNAQEEWpk8WwA2aR/GN5VNEhVSqVo4DZqbxmB1/wiXPnD2Ln4m
        01YVaHoZz75c7R7AqFSWuqhnZbOsgrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635868117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oei/Vl5aP6rLS5lpkscnCj7v3fQPmBAplgA77ous6I0=;
        b=4YYLRJWXJ2hzMXIMmn16h4unrWb0o+SGJ4x9td4PVUBwPshf1IevATEyDey2PO9rT736kj
        oF0RmhpOBpaBasCA==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DED99A3B8D;
        Tue,  2 Nov 2021 15:48:36 +0000 (UTC)
Date:   Tue, 2 Nov 2021 16:48:35 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, ro@suse.de,
        kvm-ppc@vger.kernel.org
Subject: Re: KVM on POWER8 host lock up since 10d91611f426 ("powerpc/64s:
 Reimplement book3s idle code in C")
Message-ID: <20211102154835.GQ11195@kunlun.suse.cz>
References: <20200830201145.GA29521@kitsune.suse.cz>
 <1598835313.5688ngko4f.astroid@bobo.none>
 <20200831091523.GC29521@kitsune.suse.cz>
 <87y2lv1430.fsf@mpe.ellerman.id.au>
 <1599484062.vgmycu6q5i.astroid@bobo.none>
 <20201016201410.GH29778@kitsune.suse.cz>
 <1603066878.gtbyofrzyo.astroid@bobo.none>
 <1603082970.5545yt7raj.astroid@bobo.none>
 <20210114124023.GL6564@kitsune.suse.cz>
 <1610628922.o1ihbt98xg.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1610628922.o1ihbt98xg.astroid@bobo.none>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jan 14, 2021 at 11:08:03PM +1000, Nicholas Piggin wrote:
> Excerpts from Michal Such�nek's message of January 14, 2021 10:40 pm:
> > On Mon, Oct 19, 2020 at 02:50:51PM +1000, Nicholas Piggin wrote:
> >> Excerpts from Nicholas Piggin's message of October 19, 2020 11:00 am:
> >> > Excerpts from Michal Such�nek's message of October 17, 2020 6:14 am:
> >> >> On Mon, Sep 07, 2020 at 11:13:47PM +1000, Nicholas Piggin wrote:
> >> >>> Excerpts from Michael Ellerman's message of August 31, 2020 8:50 pm:
> >> >>> > Michal Such�nek <msuchanek@suse.de> writes:
> >> >>> >> On Mon, Aug 31, 2020 at 11:14:18AM +1000, Nicholas Piggin wrote:
> >> >>> >>> Excerpts from Michal Such�nek's message of August 31, 2020 6:11 am:
> >> >>> >>> > Hello,
> >> >>> >>> > 
> >> >>> >>> > on POWER8 KVM hosts lock up since commit 10d91611f426 ("powerpc/64s:
> >> >>> >>> > Reimplement book3s idle code in C").
> >> >>> >>> > 
> >> >>> >>> > The symptom is host locking up completely after some hours of KVM
> >> >>> >>> > workload with messages like
> >> >>> >>> > 
> >> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't grab cpu 47
> >> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't grab cpu 71
> >> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't grab cpu 47
> >> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't grab cpu 71
> >> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't grab cpu 47
> >> >>> >>> > 
> >> >>> >>> > printed before the host locks up.
> >> >>> >>> > 
> >> >>> >>> > The machines run sandboxed builds which is a mixed workload resulting in
> >> >>> >>> > IO/single core/mutiple core load over time and there are periods of no
> >> >>> >>> > activity and no VMS runnig as well. The VMs are shortlived so VM
> >> >>> >>> > setup/terdown is somewhat excercised as well.
> >> >>> >>> > 
> >> >>> >>> > POWER9 with the new guest entry fast path does not seem to be affected.
> >> >>> >>> > 
> >> >>> >>> > Reverted the patch and the followup idle fixes on top of 5.2.14 and
> >> >>> >>> > re-applied commit a3f3072db6ca ("powerpc/powernv/idle: Restore IAMR
> >> >>> >>> > after idle") which gives same idle code as 5.1.16 and the kernel seems
> >> >>> >>> > stable.
> >> >>> >>> > 
> >> >>> >>> > Config is attached.
> >> >>> >>> > 
> >> >>> >>> > I cannot easily revert this commit, especially if I want to use the same
> >> >>> >>> > kernel on POWER8 and POWER9 - many of the POWER9 fixes are applicable
> >> >>> >>> > only to the new idle code.
> >> >>> >>> > 
> >> >>> >>> > Any idea what can be the problem?
> >> >>> >>> 
> >> >>> >>> So hwthread_state is never getting back to to HWTHREAD_IN_IDLE on
> >> >>> >>> those threads. I wonder what they are doing. POWER8 doesn't have a good
> >> >>> >>> NMI IPI and I don't know if it supports pdbg dumping registers from the
> >> >>> >>> BMC unfortunately.
> >> >>> >>
> >> >>> >> It may be possible to set up fadump with a later kernel version that
> >> >>> >> supports it on powernv and dump the whole kernel.
> >> >>> > 
> >> >>> > Your firmware won't support it AFAIK.
> >> >>> > 
> >> >>> > You could try kdump, but if we have CPUs stuck in KVM then there's a
> >> >>> > good chance it won't work :/
> >> >>> 
> >> >>> I haven't had any luck yet reproducing this still. Testing with sub 
> >> >>> cores of various different combinations, etc. I'll keep trying though.
> >> >> 
> >> >> Hello,
> >> >> 
> >> >> I tried running some KVM guests to simulate the workload and what I get
> >> >> is guests failing to start with a rcu stall. Tried both 5.3 and 5.9
> >> >> kernel and qemu 4.2.1 and 5.1.0
> >> >> 
> >> >> To start some guests I run
> >> >> 
> >> >> for i in $(seq 0 9) ; do /opt/qemu/bin/qemu-system-ppc64 -m 2048 -accel kvm -smp 8 -kernel /boot/vmlinux -initrd /boot/initrd -nodefaults -nographic -serial mon:telnet::444$i,server,wait & done
> >> >> 
> >> >> To simulate some workload I run
> >> >> 
> >> >> xz -zc9T0 < /dev/zero > /dev/null &
> >> >> while true; do
> >> >>     killall -STOP xz; sleep 1; killall -CONT xz; sleep 1;
> >> >> done &
> >> >> 
> >> >> on the host and add a job that executes this to the ramdisk. However, most
> >> >> guests never get to the point where the job is executed.
> >> >> 
> >> >> Any idea what might be the problem?
> >> > 
> >> > I would say try without pv queued spin locks (but if the same thing is 
> >> > happening with 5.3 then it must be something else I guess). 
> >> > 
> >> > I'll try to test a similar setup on a POWER8 here.
> >> 
> >> Couldn't reproduce the guest hang, they seem to run fine even with 
> >> queued spinlocks. Might have a different .config.
> >> 
> >> I might have got a lockup in the host (although different symptoms than 
> >> the original report). I'll look into that a bit further.
> > 
> > Hello,
> > 
> > any progress on this?
> 
> No progress, I still wasn't able to reproduce, and it fell off the 
> radar sorry.
> 
> I expect hwthred_state must be getting corrupted somewhere or a
> secondary thread getting stuck but I couldn't see where. I try pick
> it up again thanks for the reminder.

Hello,

the fixes pointed out in
https://lore.kernel.org/linuxppc-dev/87pmrtbbdt.fsf@mpe.ellerman.id.au/T/#u
resolve the problem.

Thanks

Michal
