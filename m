Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB98209C24
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Jun 2020 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390531AbgFYJoL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Jun 2020 05:44:11 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:33002 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389894AbgFYJoK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Jun 2020 05:44:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1593078246;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:References:Cc:To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=U5hW8PSiYp6ibfmgdHJypypSFgg4FeKJydkPDRlhgnw=;
        b=RiWNhCuQzsuwdoYp+GyWer0LxAk+60riAA4RRw/7RsF/tk8PJNtTLTRcckxK07yvw2
        29x/+QzI0Q2Hu/9VBzgBRY0hmmIIoHkPZB38p4EaRzcPpWgtVnEtj1KoY75uMMyC+HI+
        VUizBJI+aKDu1NQ3ji4FMriRzU9OsKJNK9VItO5RQwIMsoOSjUx3tLWAgr7RDS1GvEC7
        WpjZoMIEdqa2UzfUWZlC1HJckjdkEJ1R/6NeZYKrj1l929jvCxoh/f52ZKYRhcqgWXV/
        /Cood7umYPzqVQGZX1pQ5tMeMhY0fklJMP2ReJmCG9ZIFKPNR33YaenHPh6R7CfmTvPZ
        5tjA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPhSI1Vi9hdbute3wuvmUTfEdg9AyQ=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:15f9:f3ba:c3bc:6875]
        by smtp.strato.de (RZmta 46.10.5 AUTH)
        with ESMTPSA id 60686ew5P9c15xE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 25 Jun 2020 11:38:01 +0200 (CEST)
Subject: Re: PowerPC KVM-PR issue
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
To:     Nicholas Piggin <npiggin@gmail.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        Christian Zigotzky <info@xenosoft.de>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>,
        mad skateman <madskateman@gmail.com>
References: <f7f1b233-6101-2316-7996-4654586b7d24@csgroup.eu>
 <067BBAB3-19B6-42C6-AA9F-B9F14314255C@xenosoft.de>
 <014e1268-dcce-61a3-8bcd-a06c43e0dfaf@csgroup.eu>
 <7bf97562-3c6d-de73-6dbd-ccca275edc7b@xenosoft.de>
 <87tuznq89p.fsf@linux.ibm.com>
 <f2706f5f-62b8-9c52-08f4-59f91da48fa6@xenosoft.de>
 <cf99a8c0-3bad-d089-de54-e02d3dba7f72@xenosoft.de>
 <7e859f68-9455-f98f-1fa3-071619fa1731@xenosoft.de>
 <54082b17-31bb-f529-2e9e-b84c5a5aa9ec@xenosoft.de>
 <fffeb817-35e0-2562-b3cf-2fd476948c76@xenosoft.de>
 <1592139127.g2951cl0h6.astroid@bobo.none>
 <e253e916-7f50-f1df-fed1-57d14baa38e6@xenosoft.de>
 <292cba7f-ca2b-efb0-db3d-ecd7ee5f1fad@xenosoft.de>
Message-ID: <370689a0-5434-f480-21db-b8927ed35ae1@xenosoft.de>
Date:   Thu, 25 Jun 2020 11:38:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <292cba7f-ca2b-efb0-db3d-ecd7ee5f1fad@xenosoft.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 15 June 2020 at 01:39 pm, Christian Zigotzky wrote:
> On 14 June 2020 at 04:52 pm, Christian Zigotzky wrote:
>> On 14 June 2020 at 02:53 pm, Nicholas Piggin wrote:
>>> Excerpts from Christian Zigotzky's message of June 12, 2020 11:01 pm:
>>>> On 11 June 2020 at 04:47 pm, Christian Zigotzky wrote:
>>>>> On 10 June 2020 at 01:23 pm, Christian Zigotzky wrote:
>>>>>> On 10 June 2020 at 11:06 am, Christian Zigotzky wrote:
>>>>>>> On 10 June 2020 at 00:18 am, Christian Zigotzky wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> KVM-PR doesn't work anymore on my Nemo board [1]. I figured out
>>>>>>>> that the Git kernels and the kernel 5.7 are affected.
>>>>>>>>
>>>>>>>> Error message: Fienix kernel: kvmppc_exit_pr_progint: emulation at
>>>>>>>> 700 failed (00000000)
>>>>>>>>
>>>>>>>> I can boot virtual QEMU PowerPC machines with KVM-PR with the
>>>>>>>> kernel 5.6 without any problems on my Nemo board.
>>>>>>>>
>>>>>>>> I tested it with QEMU 2.5.0 and QEMU 5.0.0 today.
>>>>>>>>
>>>>>>>> Could you please check KVM-PR on your PowerPC machine?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Christian
>>>>>>>>
>>>>>>>> [1] https://en.wikipedia.org/wiki/AmigaOne_X1000
>>>>>>> I figured out that the PowerPC updates 5.7-1 [1] are responsible 
>>>>>>> for
>>>>>>> the KVM-PR issue. Please test KVM-PR on your PowerPC machines and
>>>>>>> check the PowerPC updates 5.7-1 [1].
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>> [1]
>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d38c07afc356ddebaa3ed8ecb3f553340e05c969 
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>> I tested the latest Git kernel with Mac-on-Linux/KVM-PR today.
>>>>>> Unfortunately I can't use KVM-PR with MoL anymore because of this
>>>>>> issue (see screenshots [1]). Please check the PowerPC updates 5.7-1.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> [1]
>>>>>> -
>>>>>> https://i.pinimg.com/originals/0c/b3/64/0cb364a40241fa2b7f297d4272bbb8b7.png 
>>>>>>
>>>>>> -
>>>>>> https://i.pinimg.com/originals/9a/61/d1/9a61d170b1c9f514f7a78a3014ffd18f.png 
>>>>>>
>>>>>>
>>>>> Hi All,
>>>>>
>>>>> I bisected today because of the KVM-PR issue.
>>>>>
>>>>> Result:
>>>>>
>>>>> 9600f261acaaabd476d7833cec2dd20f2919f1a0 is the first bad commit
>>>>> commit 9600f261acaaabd476d7833cec2dd20f2919f1a0
>>>>> Author: Nicholas Piggin <npiggin@gmail.com>
>>>>> Date:   Wed Feb 26 03:35:21 2020 +1000
>>>>>
>>>>>      powerpc/64s/exception: Move KVM test to common code
>>>>>
>>>>>      This allows more code to be moved out of unrelocated regions. 
>>>>> The
>>>>>      system call KVMTEST is changed to be open-coded and remain in 
>>>>> the
>>>>>      tramp area to avoid having to move it to entry_64.S. The custom
>>>>> nature
>>>>>      of the system call entry code means the hcall case can be 
>>>>> made more
>>>>>      streamlined than regular interrupt handlers.
>>>>>
>>>>>      mpe: Incorporate fix from Nick:
>>>>>
>>>>>      Moving KVM test to the common entry code missed the case of 
>>>>> HMI and
>>>>>      MCE, which do not do __GEN_COMMON_ENTRY (because they don't 
>>>>> want to
>>>>>      switch to virt mode).
>>>>>
>>>>>      This means a MCE or HMI exception that is taken while KVM is
>>>>> running a
>>>>>      guest context will not be switched out of that context, and 
>>>>> KVM won't
>>>>>      be notified. Found by running sigfuz in guest with patched 
>>>>> host on
>>>>>      POWER9 DD2.3, which causes some TM related HMI interrupts 
>>>>> (which are
>>>>>      expected and supposed to be handled by KVM).
>>>>>
>>>>>      This fix adds a __GEN_REALMODE_COMMON_ENTRY for those 
>>>>> handlers to add
>>>>>      the KVM test. This makes them look a little more like other 
>>>>> handlers
>>>>>      that all use __GEN_COMMON_ENTRY.
>>>>>
>>>>>      Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>>>>      Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>>>>      Link:
>>>>> https://lore.kernel.org/r/20200225173541.1549955-13-npiggin@gmail.com
>>>>>
>>>>> :040000 040000 ec21cec22d165f8696d69532734cb2985d532cb0
>>>>> 87dd49a9cd7202ec79350e8ca26cea01f1dbd93d M    arch
>>>>>
>>>>> -----
>>>>>
>>>>> The following commit is the problem: powerpc/64s/exception: Move KVM
>>>>> test to common code [1]
>>>>>
>>>>> These changes were included in the PowerPC updates 5.7-1. [2]
>>>>>
>>>>> Another test:
>>>>>
>>>>> git checkout d38c07afc356ddebaa3ed8ecb3f553340e05c969 (PowerPC 
>>>>> updates
>>>>> 5.7-1 [2] ) -> KVM-PR doesn't work.
>>>>>
>>>>> After that: git revert d38c07afc356ddebaa3ed8ecb3f553340e05c969 -m 1
>>>>> -> KVM-PR works.
>>>>>
>>>>> Could you please check the first bad commit? [1]
>>>>>
>>>>> Thanks,
>>>>> Christian
>>>>>
>>>>>
>>>>> [1]
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9600f261acaaabd476d7833cec2dd20f2919f1a0 
>>>>>
>>>>> [2]
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d38c07afc356ddebaa3ed8ecb3f553340e05c969 
>>>>>
>>>> Hi All,
>>>>
>>>> I tried to revert the __GEN_REALMODE_COMMON_ENTRY fix for the 
>>>> latest Git
>>>> kernel and for the stable kernel 5.7.2 but without any success. There
>>>> was lot of restructuring work during the kernel 5.7 development 
>>>> time in
>>>> the PowerPC area so it isn't possible reactivate the old code. That
>>>> means we have lost the whole KVM-PR support. I also reported this 
>>>> issue
>>>> to Alexander Graf two days ago. He wrote: "Howdy :). It looks pretty
>>>> broken. Have you ever made a bisect to see where the problem comes 
>>>> from?"
>>>>
>>>> Please check the KVM-PR code.
>>> Does this patch fix it for you?
>>>
>>> The CTR register reload in the KVM interrupt path used the wrong save
>>> area for SLB (and NMI) interrupts.
>>>
>>> Fixes: 9600f261acaaa ("powerpc/64s/exception: Move KVM test to 
>>> common code")
>>> Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>   arch/powerpc/kernel/exceptions-64s.S | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kernel/exceptions-64s.S 
>>> b/arch/powerpc/kernel/exceptions-64s.S
>>> index e70ebb5c318c..fa080694e581 100644
>>> --- a/arch/powerpc/kernel/exceptions-64s.S
>>> +++ b/arch/powerpc/kernel/exceptions-64s.S
>>> @@ -270,7 +270,7 @@ BEGIN_FTR_SECTION
>>>   END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
>>>       .endif
>>>   -    ld    r10,PACA_EXGEN+EX_CTR(r13)
>>> +    ld    r10,IAREA+EX_CTR(r13)
>>>       mtctr    r10
>>>   BEGIN_FTR_SECTION
>>>       ld    r10,IAREA+EX_PPR(r13)
>>> @@ -298,7 +298,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>>>         .if IKVM_SKIP
>>>   89:    mtocrf    0x80,r9
>>> -    ld    r10,PACA_EXGEN+EX_CTR(r13)
>>> +    ld    r10,IAREA+EX_CTR(r13)
>>>       mtctr    r10
>>>       ld    r9,IAREA+EX_R9(r13)
>>>       ld    r10,IAREA+EX_R10(r13)
>> Many thanks for the fix! I will test it with the RC1 tomorrow.
>>
>> -- Christian
>
> It works! :-) Thanks a lot! Screenshot: 
> https://i.pinimg.com/originals/5d/5f/e5/5d5fe584db474dc88bcc641450b2a7e0.png
>
> -- Christian

Just for info: I successfully tested KVM-PR with the stable kernel 5.7.6 
and with the RC2 of kernel 5.8 today. Thanks a lot for fixing the issue.

-- Christian
