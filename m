Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE15D66703
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 08:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbfGLG3F (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Jul 2019 02:29:05 -0400
Received: from ozlabs.org ([203.11.71.1]:41101 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbfGLG3E (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 12 Jul 2019 02:29:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lNL629bjz9s4Y;
        Fri, 12 Jul 2019 16:29:02 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        linuxppc-dev@ozlabs.org
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/8] KVM: PPC: Ultravisor: Introduce the MSR_S bit
In-Reply-To: <1562892336.boqkwvamhq.astroid@bobo.none>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-2-cclaudio@linux.ibm.com> <1562892336.boqkwvamhq.astroid@bobo.none>
Date:   Fri, 12 Jul 2019 16:29:01 +1000
Message-ID: <87zhljepg2.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Claudio Carvalho's on June 29, 2019 6:08 am:
>> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> 
>> The ultravisor processor mode is introduced in POWER platforms that
>> supports the Protected Execution Facility (PEF). Ultravisor is higher
>> privileged than hypervisor mode.
>> 
>> In PEF enabled platforms, the MSR_S bit is used to indicate if the
>> thread is in secure state. With the MSR_S bit, the privilege state of
>> the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:
>> 
>> S   HV  PR
>> -----------------------
>> 0   x   1   problem
>> 1   0   1   problem
>> x   x   0   privileged
>> x   1   0   hypervisor
>> 1   1   0   ultravisor
>> 1   1   1   reserved
>
> What does this table mean? I thought 'x' meant either, but in that
> case there are several states that can apply to the same
> combination of bits.
>
> Would it be clearer to rearrange the table so the columns are the HV
> and PR bits we know and love, plus the effect of S=1 on each of them?
>
>       HV  PR  S=0         S=1
>       ---------------------------------------------
>       0   0   privileged  privileged (secure guest kernel)
>       0   1   problem     problem (secure guest userspace)
>       1   0   hypervisor  ultravisor
>       1   1   problem     reserved
>
> Is that accurate?

I like that format.

cheers
