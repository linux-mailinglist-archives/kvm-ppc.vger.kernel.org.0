Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC388682C8
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 06:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfGOEKL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Jul 2019 00:10:11 -0400
Received: from ozlabs.org ([203.11.71.1]:34911 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfGOEKK (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 15 Jul 2019 00:10:10 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45n96S4xBdz9s7T;
        Mon, 15 Jul 2019 14:10:08 +1000 (AEST)
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
Subject: Re: [PATCH v4 2/8] powerpc: Introduce FW_FEATURE_ULTRAVISOR
In-Reply-To: <4da093e5-14ea-963b-9e8d-a6ba2aa4678f@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-3-cclaudio@linux.ibm.com> <87k1cog250.fsf@concordia.ellerman.id.au> <4da093e5-14ea-963b-9e8d-a6ba2aa4678f@linux.ibm.com>
Date:   Mon, 15 Jul 2019 14:10:08 +1000
Message-ID: <878st09bvj.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> On 7/11/19 9:57 AM, Michael Ellerman wrote:
>> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>>> diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
>>> new file mode 100644
>>> index 000000000000..e5009b0d84ea
>>> --- /dev/null
>>> +++ b/arch/powerpc/include/asm/ultravisor.h
>>> @@ -0,0 +1,15 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Ultravisor definitions
>>> + *
>>> + * Copyright 2019, IBM Corporation.
>>> + *
>>> + */
>>> +#ifndef _ASM_POWERPC_ULTRAVISOR_H
>>> +#define _ASM_POWERPC_ULTRAVISOR_H
>>> +
>>> +/* Internal functions */
>>> +extern int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
>>> +					 int depth, void *data);
>> Please don't use extern in new headers.
>>
>>> diff --git a/arch/powerpc/kernel/ultravisor.c b/arch/powerpc/kernel/ultravisor.c
>>> new file mode 100644
>>> index 000000000000..dc6021f63c97
>>> --- /dev/null
>>> +++ b/arch/powerpc/kernel/ultravisor.c
>> Is there a reason this (and other later files) aren't in platforms/powernv ?
>
> Yes, there is.
> https://www.spinics.net/lists/kvm-ppc/msg14998.html
>
> We also need to do ucalls from a secure guest and its kernel may not
> have CONFIG_PPC_POWERNV=y. I can make it clear in the commit message.

OK, sorry I missed Paul's comment. Yeah that is obviously a valid reason :)

>>> @@ -0,0 +1,24 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Ultravisor high level interfaces
>>> + *
>>> + * Copyright 2019, IBM Corporation.
>>> + *
>>> + */
>>> +#include <linux/init.h>
>>> +#include <linux/printk.h>
>>> +#include <linux/string.h>
>>> +
>>> +#include <asm/ultravisor.h>
>>> +#include <asm/firmware.h>
>>> +
>>> +int __init early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
>>> +					 int depth, void *data)
>>> +{
>>> +	if (depth != 1 || strcmp(uname, "ibm,ultravisor") != 0)
>>> +		return 0;
>> I know you're following the example of OPAL, but this is not the best
>> way to search for the ultravisor node.
>>
>> It makes the location and name of the node part of the ABI, when there's
>> no need for it to be.
>>
>> If instead you just scan the tree for a node that is *compatible* with
>> "ibm,ultravisor" (or whatever compatible string) then the node can be
>> placed any where in the tree and have any name, which gives us the most
>> flexibility in future to change the location of the device tree node.
>
> I will do that in the next version.

Excellent, thanks.

cheers
