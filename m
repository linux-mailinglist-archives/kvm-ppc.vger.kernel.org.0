Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB146822E
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 04:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfGOCXr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 14 Jul 2019 22:23:47 -0400
Received: from ozlabs.org ([203.11.71.1]:46563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbfGOCXr (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 14 Jul 2019 22:23:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45n6lh4LPgz9sP0;
        Mon, 15 Jul 2019 12:23:44 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, david@gibson.dropbear.id.au
Subject: Re: [PATCH] powerpc: mm: Limit rma_size to 1TB when running without HV mode
In-Reply-To: <1563155904.2145.1.camel@gmail.com>
References: <20190710052018.14628-1-sjitindarsingh@gmail.com> <87o91ze6wx.fsf@concordia.ellerman.id.au> <1563155904.2145.1.camel@gmail.com>
Date:   Mon, 15 Jul 2019 12:23:44 +1000
Message-ID: <87d0ic9gsv.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> On Fri, 2019-07-12 at 23:09 +1000, Michael Ellerman wrote:
>> Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
>> > The virtual real mode addressing (VRMA) mechanism is used when a
>> > partition is using HPT (Hash Page Table) translation and performs
>> > real mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this
>> > mode effective address bits 0:23 are treated as zero (i.e. the
>> > access
>> > is aliased to 0) and the access is performed using an implicit 1TB
>> > SLB
>> > entry.
>> > 
>> > The size of the RMA (Real Memory Area) is communicated to the guest
>> > as
>> > the size of the first memory region in the device tree. And because
>> > of
>> > the mechanism described above can be expected to not exceed 1TB. In
>> > the
>> > event that the host erroneously represents the RMA as being larger
>> > than
>> > 1TB, guest accesses in real mode to memory addresses above 1TB will
>> > be
>> > aliased down to below 1TB. This means that a memory access
>> > performed in
>> > real mode may differ to one performed in virtual mode for the same
>> > memory
>> > address, which would likely have unintended consequences.
>> > 
>> > To avoid this outcome have the guest explicitly limit the size of
>> > the
>> > RMA to the current maximum, which is 1TB. This means that even if
>> > the
>> > first memory block is larger than 1TB, only the first 1TB should be
>> > accessed in real mode.
>> > 
>> > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
>> 
>> I added:
>> 
>> Fixes: c3ab300ea555 ("powerpc: Add POWER9 cputable entry")
>> Cc: stable@vger.kernel.org # v4.6+
>> 
>> 
>> Which is not exactly correct, but probably good enough?
>
> I think we actually want:
> Fixes: c610d65c0ad0 ("powerpc/pseries: lift RTAS limit for hash")
>
> Which is what actually caused it to break and for the issue to present
> itself.

Thanks, I used that instead.

cheers
