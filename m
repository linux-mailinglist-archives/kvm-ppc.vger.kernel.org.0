Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0993C9C7E3
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Aug 2019 05:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfHZDV0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Aug 2019 23:21:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39057 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbfHZDV0 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 25 Aug 2019 23:21:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46Gy2q45Bxz9sDB;
        Mon, 26 Aug 2019 13:21:23 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: Re: [PATCH v2] powerpc/powernv: Add ultravisor message log interface
In-Reply-To: <4e577a36-4ce1-410b-3ceb-d31bbf564b3d@linux.ibm.com>
References: <20190823060654.28842-1-cclaudio@linux.ibm.com> <87o90g3v5o.fsf@concordia.ellerman.id.au> <4e577a36-4ce1-410b-3ceb-d31bbf564b3d@linux.ibm.com>
Date:   Mon, 26 Aug 2019 13:21:20 +1000
Message-ID: <87lfvg4nnz.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> On 8/23/19 9:48 AM, Michael Ellerman wrote:
>> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>>> Ultravisor (UV) provides an in-memory console which follows the OPAL
>>> in-memory console structure.
>>>
>>> This patch extends the OPAL msglog code to also initialize the UV memory
>>> console and provide a sysfs interface (uv_msglog) for userspace to view
>>> the UV message log.
>>>
>>> CC: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>>> CC: Oliver O'Halloran <oohall@gmail.com>
>>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>>> ---
>>> This patch depends on the "kvmppc: Paravirtualize KVM to support
>>> ultravisor" patchset submitted by Claudio Carvalho.
>>> ---
>>>  arch/powerpc/platforms/powernv/opal-msglog.c | 99 ++++++++++++++------
>>>  1 file changed, 72 insertions(+), 27 deletions(-)
>> I think the code changes look mostly OK here.
>>
>> But I'm not sure about the end result in sysfs.
>>
>> If I'm reading it right this will create:
>>
>>  /sys/firmware/opal/uv_msglog
>>
>> Which I think is a little weird, because the UV is not OPAL.
>>
>> So I guess I wonder if the file should be created elsewhere to avoid any
>> confusion and keep things nicely separated.
>>
>> Possibly /sys/firmware/ultravisor/msglog ?
>
>
> Yes, makes sense. I will do that.

Thanks.

> Currently, the ultravisor memory console DT property is in
> /ibm,opal/ibm,opal-uv-memcons. I think we should move it to
> /ibm,ultravisor/ibm,uv-firmware/ibm,uv-memcons. What do you think?

Yes that looks better.

As an aside, you don't really need to namespace every node and property
under ibm,ultravisor, the top-level ibm,ultravisor is already a
namespace of sorts.

ie. it could just be: /ibm,ultravisor/firmware/memcons

But if it's too late to change those paths it doesn't really matter.

cheers
