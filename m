Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14081F6A43
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jun 2020 16:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgFKOrt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jun 2020 10:47:49 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:27720 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgFKOrs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 11 Jun 2020 10:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591886863;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=txqK7zLBPTnofgZtcBMl5enqBRDV39VE4i3BgE8pw6I=;
        b=GnQbj8UDdbSXfZY9Er2LUKZfCd5DlLhAlBnear/8gz4eXwcL+CyXjJ55DJq5xS2Jw/
        c/dOLFOrZQUDRra3vmbYIYSdKbrQHgmDWIKTieSKFDbg/L2JrTjlOHRJFe8qJpKqJp/a
        hdTPrbGEJ4xQ+WyAdWP1QScJSTspLqcq40y+gaqPjzluJEw5uXELYrms5eGx3RfLvAiw
        ABVD2Z7g5OIFf6i/71A3z0TmOQ71Ltrb4xsuYIhekUex58VuWZvij3Ko6rt7QdJ0XWFQ
        j4itMC5CMHB9okF2MlJQQSo3sAXHdQb9BqYpQPh++VO7MyAXkEWxEPle3w1Fv2afiJlK
        FZpQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSI1Vi9hdbute3wuvmUTfEdg9AyQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:15f9:f3ba:c3bc:6875]
        by smtp.strato.de (RZmta 46.10.4 AUTH)
        with ESMTPSA id m08564w5BElR020
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 11 Jun 2020 16:47:27 +0200 (CEST)
Subject: Re: PowerPC KVM-PR issue
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, npiggin@gmail.com,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>
Cc:     Christian Zigotzky <info@xenosoft.de>,
        Darren Stevens <darren@stevens-zone.net>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>
References: <f7f1b233-6101-2316-7996-4654586b7d24@csgroup.eu>
 <067BBAB3-19B6-42C6-AA9F-B9F14314255C@xenosoft.de>
 <014e1268-dcce-61a3-8bcd-a06c43e0dfaf@csgroup.eu>
 <7bf97562-3c6d-de73-6dbd-ccca275edc7b@xenosoft.de>
 <87tuznq89p.fsf@linux.ibm.com>
 <f2706f5f-62b8-9c52-08f4-59f91da48fa6@xenosoft.de>
 <cf99a8c0-3bad-d089-de54-e02d3dba7f72@xenosoft.de>
 <7e859f68-9455-f98f-1fa3-071619fa1731@xenosoft.de>
Message-ID: <54082b17-31bb-f529-2e9e-b84c5a5aa9ec@xenosoft.de>
Date:   Thu, 11 Jun 2020 16:47:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <7e859f68-9455-f98f-1fa3-071619fa1731@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 10 June 2020 at 01:23 pm, Christian Zigotzky wrote:
> On 10 June 2020 at 11:06 am, Christian Zigotzky wrote:
>> On 10 June 2020 at 00:18 am, Christian Zigotzky wrote:
>>> Hello,
>>>
>>> KVM-PR doesn't work anymore on my Nemo board [1]. I figured out that 
>>> the Git kernels and the kernel 5.7 are affected.
>>>
>>> Error message: Fienix kernel: kvmppc_exit_pr_progint: emulation at 
>>> 700 failed (00000000)
>>>
>>> I can boot virtual QEMU PowerPC machines with KVM-PR with the kernel 
>>> 5.6 without any problems on my Nemo board.
>>>
>>> I tested it with QEMU 2.5.0 and QEMU 5.0.0 today.
>>>
>>> Could you please check KVM-PR on your PowerPC machine?
>>>
>>> Thanks,
>>> Christian
>>>
>>> [1] https://en.wikipedia.org/wiki/AmigaOne_X1000
>>
>> I figured out that the PowerPC updates 5.7-1 [1] are responsible for 
>> the KVM-PR issue. Please test KVM-PR on your PowerPC machines and 
>> check the PowerPC updates 5.7-1 [1].
>>
>> Thanks
>>
>> [1] 
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d38c07afc356ddebaa3ed8ecb3f553340e05c969
>>
>>
> I tested the latest Git kernel with Mac-on-Linux/KVM-PR today. 
> Unfortunately I can't use KVM-PR with MoL anymore because of this 
> issue (see screenshots [1]). Please check the PowerPC updates 5.7-1.
>
> Thanks
>
> [1]
> - 
> https://i.pinimg.com/originals/0c/b3/64/0cb364a40241fa2b7f297d4272bbb8b7.png
> - 
> https://i.pinimg.com/originals/9a/61/d1/9a61d170b1c9f514f7a78a3014ffd18f.png
>
Hi All,

I bisected today because of the KVM-PR issue.

Result:

9600f261acaaabd476d7833cec2dd20f2919f1a0 is the first bad commit
commit 9600f261acaaabd476d7833cec2dd20f2919f1a0
Author: Nicholas Piggin <npiggin@gmail.com>
Date:   Wed Feb 26 03:35:21 2020 +1000

     powerpc/64s/exception: Move KVM test to common code

     This allows more code to be moved out of unrelocated regions. The
     system call KVMTEST is changed to be open-coded and remain in the
     tramp area to avoid having to move it to entry_64.S. The custom nature
     of the system call entry code means the hcall case can be made more
     streamlined than regular interrupt handlers.

     mpe: Incorporate fix from Nick:

     Moving KVM test to the common entry code missed the case of HMI and
     MCE, which do not do __GEN_COMMON_ENTRY (because they don't want to
     switch to virt mode).

     This means a MCE or HMI exception that is taken while KVM is running a
     guest context will not be switched out of that context, and KVM won't
     be notified. Found by running sigfuz in guest with patched host on
     POWER9 DD2.3, which causes some TM related HMI interrupts (which are
     expected and supposed to be handled by KVM).

     This fix adds a __GEN_REALMODE_COMMON_ENTRY for those handlers to add
     the KVM test. This makes them look a little more like other handlers
     that all use __GEN_COMMON_ENTRY.

     Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
     Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
     Link: 
https://lore.kernel.org/r/20200225173541.1549955-13-npiggin@gmail.com

:040000 040000 ec21cec22d165f8696d69532734cb2985d532cb0 
87dd49a9cd7202ec79350e8ca26cea01f1dbd93d M    arch

-----

The following commit is the problem: powerpc/64s/exception: Move KVM 
test to common code [1]

These changes were included in the PowerPC updates 5.7-1. [2]

Another test:

git checkout d38c07afc356ddebaa3ed8ecb3f553340e05c969 (PowerPC updates 
5.7-1 [2] ) -> KVM-PR doesn't work.

After that: git revert d38c07afc356ddebaa3ed8ecb3f553340e05c969 -m 1 -> 
KVM-PR works.

Could you please check the first bad commit? [1]

Thanks,
Christian


[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9600f261acaaabd476d7833cec2dd20f2919f1a0
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d38c07afc356ddebaa3ed8ecb3f553340e05c969
