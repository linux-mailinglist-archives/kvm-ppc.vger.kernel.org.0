Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479542F618B
	for <lists+kvm-ppc@lfdr.de>; Thu, 14 Jan 2021 14:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbhANNIv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 14 Jan 2021 08:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbhANNIu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 14 Jan 2021 08:08:50 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DDCC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 14 Jan 2021 05:08:10 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i5so3767781pgo.1
        for <kvm-ppc@vger.kernel.org>; Thu, 14 Jan 2021 05:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=V5mBBcc1pjGGwRJQjUnzrQlgeQFUaJGngHzEvAldn7U=;
        b=OmBR1Bn//cDynJ9MsHrhy3y38bHmg/GCtKYjoJjulMbCGTLrRVg0O0b3HcDMJ8dSq5
         5INUgnMfVCphKArsaBelMVM0qpgULZMsdtCbGwBNaWRNbsXcIn4uskoxlVs0HTSm0VtM
         eCWydJwGwOxaC7UDQKSjTgWRltnCC1dNut6WF4URpkQ+qxaqHnSHMMrxReFlg2ILMQ7U
         MXGFIOMReR/Wa+aTB3BnCSZ1WuIU0TjuwKo2Cqh4RCyjgo4gxFbKVWsTElERh7+tU/VA
         U6+3BNZGlALxhN6MGl5cFGxHEw/y51B79N7ViRT+uCK0xodY+oUdHf0WO0QV/p7zy7lu
         lwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=V5mBBcc1pjGGwRJQjUnzrQlgeQFUaJGngHzEvAldn7U=;
        b=AAOGwodfws3FoyfoBlXZ8SUyKkcgSHl7wQnSLLjEzrbdPb9RLEpI8g9n+BlYGKG9kI
         R9OJAlriIVdPLJ+sam0YsF4FUVSXt8ikxqlkwqi2496bq02n+uxeNtx3TUfCcolWtJ2R
         eJqcPVvL+kHvHzoHCZ0HqLjtCxlqKfNW5cqWW9GNxLw1a8Y+9Na9pNS0cwQhW/FEQUd8
         ukRhXNRLRw2oyFe2HjH7a3zq4IasqQX5htzUHWS1yfqC5JudrjGxQiYNIzg7Kwz1bxiO
         PUCHyA5xuuPZDhszfYRZVAIJFqy86gp/KBoy/iHiKQJjhgHz8YegcL+sEzxQOMjVvgAy
         HWfQ==
X-Gm-Message-State: AOAM533iystQtnsjZo1LssAZBafFpTKUnIy86m+bi9FXHqSxjEXvrInK
        sxMKpAIXY65XRBj9s5bInJNdio8CVbc=
X-Google-Smtp-Source: ABdhPJyDX52tq0NAghsdIbcddA+MMQdCV7v35i+R9Oe/DuK0f5Gcx0ag83mEIH33ZEYlsO6KRu2Xfw==
X-Received: by 2002:a62:e906:0:b029:1ae:6d80:1338 with SMTP id j6-20020a62e9060000b02901ae6d801338mr7263852pfh.24.1610629689858;
        Thu, 14 Jan 2021 05:08:09 -0800 (PST)
Received: from localhost ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id x23sm5440617pgk.14.2021.01.14.05.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 05:08:08 -0800 (PST)
Date:   Thu, 14 Jan 2021 23:08:03 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: KVM on POWER8 host lock up since 10d91611f426 ("powerpc/64s:
 Reimplement book3s idle code in C")
To:     Michal =?iso-8859-1?q?Such=E1nek?= <msuchanek@suse.de>
Cc:     Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, ro@suse.de,
        kvm-ppc@vger.kernel.org
References: <20200830201145.GA29521@kitsune.suse.cz>
        <1598835313.5688ngko4f.astroid@bobo.none>
        <20200831091523.GC29521@kitsune.suse.cz> <87y2lv1430.fsf@mpe.ellerman.id.au>
        <1599484062.vgmycu6q5i.astroid@bobo.none>
        <20201016201410.GH29778@kitsune.suse.cz>
        <1603066878.gtbyofrzyo.astroid@bobo.none>
        <1603082970.5545yt7raj.astroid@bobo.none>
        <20210114124023.GL6564@kitsune.suse.cz>
In-Reply-To: <20210114124023.GL6564@kitsune.suse.cz>
MIME-Version: 1.0
Message-Id: <1610628922.o1ihbt98xg.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Michal Such=C3=A1nek's message of January 14, 2021 10:40 pm:
> On Mon, Oct 19, 2020 at 02:50:51PM +1000, Nicholas Piggin wrote:
>> Excerpts from Nicholas Piggin's message of October 19, 2020 11:00 am:
>> > Excerpts from Michal Such=C3=A1nek's message of October 17, 2020 6:14 =
am:
>> >> On Mon, Sep 07, 2020 at 11:13:47PM +1000, Nicholas Piggin wrote:
>> >>> Excerpts from Michael Ellerman's message of August 31, 2020 8:50 pm:
>> >>> > Michal Such=C3=A1nek <msuchanek@suse.de> writes:
>> >>> >> On Mon, Aug 31, 2020 at 11:14:18AM +1000, Nicholas Piggin wrote:
>> >>> >>> Excerpts from Michal Such=C3=A1nek's message of August 31, 2020 =
6:11 am:
>> >>> >>> > Hello,
>> >>> >>> >=20
>> >>> >>> > on POWER8 KVM hosts lock up since commit 10d91611f426 ("powerp=
c/64s:
>> >>> >>> > Reimplement book3s idle code in C").
>> >>> >>> >=20
>> >>> >>> > The symptom is host locking up completely after some hours of =
KVM
>> >>> >>> > workload with messages like
>> >>> >>> >=20
>> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't =
grab cpu 47
>> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't =
grab cpu 71
>> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't =
grab cpu 47
>> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't =
grab cpu 71
>> >>> >>> > 2020-08-30T10:51:31+00:00 obs-power8-01 kernel: KVM: couldn't =
grab cpu 47
>> >>> >>> >=20
>> >>> >>> > printed before the host locks up.
>> >>> >>> >=20
>> >>> >>> > The machines run sandboxed builds which is a mixed workload re=
sulting in
>> >>> >>> > IO/single core/mutiple core load over time and there are perio=
ds of no
>> >>> >>> > activity and no VMS runnig as well. The VMs are shortlived so =
VM
>> >>> >>> > setup/terdown is somewhat excercised as well.
>> >>> >>> >=20
>> >>> >>> > POWER9 with the new guest entry fast path does not seem to be =
affected.
>> >>> >>> >=20
>> >>> >>> > Reverted the patch and the followup idle fixes on top of 5.2.1=
4 and
>> >>> >>> > re-applied commit a3f3072db6ca ("powerpc/powernv/idle: Restore=
 IAMR
>> >>> >>> > after idle") which gives same idle code as 5.1.16 and the kern=
el seems
>> >>> >>> > stable.
>> >>> >>> >=20
>> >>> >>> > Config is attached.
>> >>> >>> >=20
>> >>> >>> > I cannot easily revert this commit, especially if I want to us=
e the same
>> >>> >>> > kernel on POWER8 and POWER9 - many of the POWER9 fixes are app=
licable
>> >>> >>> > only to the new idle code.
>> >>> >>> >=20
>> >>> >>> > Any idea what can be the problem?
>> >>> >>>=20
>> >>> >>> So hwthread_state is never getting back to to HWTHREAD_IN_IDLE o=
n
>> >>> >>> those threads. I wonder what they are doing. POWER8 doesn't have=
 a good
>> >>> >>> NMI IPI and I don't know if it supports pdbg dumping registers f=
rom the
>> >>> >>> BMC unfortunately.
>> >>> >>
>> >>> >> It may be possible to set up fadump with a later kernel version t=
hat
>> >>> >> supports it on powernv and dump the whole kernel.
>> >>> >=20
>> >>> > Your firmware won't support it AFAIK.
>> >>> >=20
>> >>> > You could try kdump, but if we have CPUs stuck in KVM then there's=
 a
>> >>> > good chance it won't work :/
>> >>>=20
>> >>> I haven't had any luck yet reproducing this still. Testing with sub=20
>> >>> cores of various different combinations, etc. I'll keep trying thoug=
h.
>> >>=20
>> >> Hello,
>> >>=20
>> >> I tried running some KVM guests to simulate the workload and what I g=
et
>> >> is guests failing to start with a rcu stall. Tried both 5.3 and 5.9
>> >> kernel and qemu 4.2.1 and 5.1.0
>> >>=20
>> >> To start some guests I run
>> >>=20
>> >> for i in $(seq 0 9) ; do /opt/qemu/bin/qemu-system-ppc64 -m 2048 -acc=
el kvm -smp 8 -kernel /boot/vmlinux -initrd /boot/initrd -nodefaults -nogra=
phic -serial mon:telnet::444$i,server,wait & done
>> >>=20
>> >> To simulate some workload I run
>> >>=20
>> >> xz -zc9T0 < /dev/zero > /dev/null &
>> >> while true; do
>> >>     killall -STOP xz; sleep 1; killall -CONT xz; sleep 1;
>> >> done &
>> >>=20
>> >> on the host and add a job that executes this to the ramdisk. However,=
 most
>> >> guests never get to the point where the job is executed.
>> >>=20
>> >> Any idea what might be the problem?
>> >=20
>> > I would say try without pv queued spin locks (but if the same thing is=
=20
>> > happening with 5.3 then it must be something else I guess).=20
>> >=20
>> > I'll try to test a similar setup on a POWER8 here.
>>=20
>> Couldn't reproduce the guest hang, they seem to run fine even with=20
>> queued spinlocks. Might have a different .config.
>>=20
>> I might have got a lockup in the host (although different symptoms than=20
>> the original report). I'll look into that a bit further.
>=20
> Hello,
>=20
> any progress on this?

No progress, I still wasn't able to reproduce, and it fell off the=20
radar sorry.

I expect hwthred_state must be getting corrupted somewhere or a
secondary thread getting stuck but I couldn't see where. I try pick
it up again thanks for the reminder.

Thanks,
Nick
