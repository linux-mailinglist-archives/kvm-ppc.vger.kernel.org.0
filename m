Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DCA331C99
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Mar 2021 02:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCIBxD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Mar 2021 20:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhCIBwj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Mar 2021 20:52:39 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C93C06174A
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Mar 2021 17:52:38 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DvdWR4MNjz9sW5;
        Tue,  9 Mar 2021 12:52:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1615254755;
        bh=K0RM5wdESUcmt7Xo/LZoVo0I5pD31McpVLcM77SacDo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Awj7pc16jSWWGO+pQ177zHJfolA2ilgqKdJZiiWwrLh/Ox02zaZz+YJ85dz5TJRQN
         8pbCc4SUYerG6NNvpIK8/4bLYu9S2QDXyu0Fw1f3ILRgYaW+abjEzRge6UBaectJ1s
         WYlue2ZHSkme3GkmJk93VRxz+Vqk1DTJpuJEgY6Ja1Y7ZE6aZ6sP/duu2jZ6f6E0zk
         hOjx/hoJt/+w3a3BRh5j+4KB6NsF0NyEIStyAxNyxCzIFgRtz56JCcafzMl9QNSoAn
         4XfxlvhoGfRVklzdKqeA1Qd+Yi/8xOi/VC7Q+5CKnwPzLISafUIpDMklXYHJGkoF3M
         tuXrnO5hzP0Pw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Do not expose HFSCR sanitisation
 to nested hypervisor
In-Reply-To: <87eegpn0un.fsf@linux.ibm.com>
References: <20210305231055.2913892-1-farosas@linux.ibm.com>
 <1615191200.1pjltfhe7o.astroid@bobo.none> <87eegpn0un.fsf@linux.ibm.com>
Date:   Tue, 09 Mar 2021 12:52:31 +1100
Message-ID: <87k0qhqejk.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fabiano Rosas <farosas@linux.ibm.com> writes:
> Nicholas Piggin <npiggin@gmail.com> writes:
>
>> Excerpts from Fabiano Rosas's message of March 6, 2021 9:10 am:
>>> As one of the arguments of the H_ENTER_NESTED hypercall, the nested
>>> hypervisor (L1) prepares a structure containing the values of various
>>> hypervisor-privileged registers with which it wants the nested guest
>>> (L2) to run. Since the nested HV runs in supervisor mode it needs the
>>> host to write to these registers.
>>> 
>>> To stop a nested HV manipulating this mechanism and using a nested
>>> guest as a proxy to access a facility that has been made unavailable
>>> to it, we have a routine that sanitises the values of the HV registers
>>> before copying them into the nested guest's vcpu struct.
>>> 
>>> However, when coming out of the guest the values are copied as they
>>> were back into L1 memory, which means that any sanitisation we did
>>> during guest entry will be exposed to L1 after H_ENTER_NESTED returns.
>>> 
>>> This is not a problem by itself, but in the case of the Hypervisor
>>> Facility Status and Control Register (HFSCR), we use the intersection
>>> between L2 hfscr bits and L1 hfscr bits. That means that L1 could use
>>> this to indirectly read the (hv-privileged) value from its vcpu
>>> struct.
>>> 
>>> This patch fixes this by making sure that L1 only gets back the bits
>>> that are necessary for regular functioning.
>>
>> The general idea of restricting exposure of HV privileged bits, but
>> for the case of HFSCR a guest can probe the HFCR anyway by testing which 
>> facilities are available (and presumably an HV may need some way to know
>> what features are available for it to advertise to its own guests), so
>> is this necessary? Perhaps a comment would be sufficient.
>
> Well, I'd be happy to force them through the arduous path then =); and
> there are features that are emulated by the HV which L1 would not be
> able to probe.
>
> I think we should implement a mechanism that stops all leaks now, rather
> than having to ponder about this every time we touch an hv_reg in that
> structure. I'm not too worried about HFSCR specifically.
>
> Let me think about this some more and see if I can make it more generic,
> I realise that sticking the saved_hfscr on the side is not the most
> elegant approach.

Yeah that would be good.

I don't really like the patch as it is, ie. having to pass *saved_hfscr
and so on.

But in general I agree that we should avoid leaking details across
boundaries, even if we don't think they are particularly sensitive.

cheers
