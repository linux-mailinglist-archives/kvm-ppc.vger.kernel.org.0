Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA4B68306
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 06:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfGOEqL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Jul 2019 00:46:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35479 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfGOEqL (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 15 Jul 2019 00:46:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45n9vy6tNVz9s3l;
        Mon, 15 Jul 2019 14:46:06 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: Re: [PATCH v4 3/8] KVM: PPC: Ultravisor: Add generic ultravisor call handler
In-Reply-To: <45cb74bc-442c-e1c5-6636-93e9ab7f323a@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-4-cclaudio@linux.ibm.com> <87lfx4g253.fsf@concordia.ellerman.id.au> <45cb74bc-442c-e1c5-6636-93e9ab7f323a@linux.ibm.com>
Date:   Mon, 15 Jul 2019 14:46:06 +1000
Message-ID: <875zo3aos1.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> On 7/11/19 9:57 AM, Michael Ellerman wrote:
>> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>>> From: Ram Pai <linuxram@us.ibm.com>
>>>
>>> Add the ucall() function, which can be used to make ultravisor calls
>>> with varied number of in and out arguments. Ultravisor calls can be made
>>> from the host or guests.
>>>
>>> This copies the implementation of plpar_hcall().
>> .. with quite a few changes?
>>
>> This is one of the things I'd like to see in a Documentation file, so
>> that people can review the implementation vs the specification.
>
> I will document this (and other things) in a file under Documentation/powerpc.

Thanks.

>>> +/* API functions */
>>> +#define UCALL_BUFSIZE 4
>> Please don't copy this design from the hcall code, it has led to bugs in
>> the past.
>>
>> See my (still unmerged) attempt to fix this for the hcall case:
>>   https://patchwork.ozlabs.org/patch/683577/
>>
>> Basically instead of asking callers nicely to define a certain sized
>> buffer, and them forgetting, define a proper type that has the right size.
>
> I will keep that in mind. For now I think we don't need that since the v5
> will have ucall_norets() instead.

OK.

>>> diff --git a/arch/powerpc/kernel/ultravisor.c b/arch/powerpc/kernel/ultravisor.c
>>> index dc6021f63c97..02ddf79a9522 100644
>>> --- a/arch/powerpc/kernel/ultravisor.c
>>> +++ b/arch/powerpc/kernel/ultravisor.c
>>> @@ -8,10 +8,14 @@
>>>  #include <linux/init.h>
>>>  #include <linux/printk.h>
>>>  #include <linux/string.h>
>>> +#include <linux/export.h>
>>>  
>>>  #include <asm/ultravisor.h>
>>>  #include <asm/firmware.h>
>>>  
>>> +/* in ucall.S */
>>> +EXPORT_SYMBOL_GPL(ucall);
>> This should be in ucall.S
>
> Here I'm following the same way that hypercall wrapper symbols are exported.

Yeah we used to not be able to export from .S but that was fixed a few
years ago.

> Last time I tried to export that in ucall.S the linker complained that the
> ucall
> symbol will not be versioned. Something like this:
> https://patchwork.kernel.org/patch/9452759/

I think you just need to include <asm/export.h> in the .S ?

cheers
