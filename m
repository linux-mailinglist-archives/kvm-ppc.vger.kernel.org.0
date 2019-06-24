Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8CF509EA
	for <lists+kvm-ppc@lfdr.de>; Mon, 24 Jun 2019 13:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfFXLjU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 Jun 2019 07:39:20 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58197 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfFXLjU (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 24 Jun 2019 07:39:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45XS4Q1yBzz9s6w;
        Mon, 24 Jun 2019 21:39:18 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Segher Boessenkool <segher@kernel.crashing.org>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/2] powerpc/64s: Rename PPC_INVALIDATE_ERAT to PPC_ARCH_300_INVALIDATE_ERAT
In-Reply-To: <1561297021.pyb7y0yjt7.astroid@bobo.none>
References: <20190623104152.13173-1-npiggin@gmail.com> <20190623120332.GA7313@gate.crashing.org> <1561297021.pyb7y0yjt7.astroid@bobo.none>
Date:   Mon, 24 Jun 2019 21:39:17 +1000
Message-ID: <87wohb8b6i.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> Segher Boessenkool's on June 23, 2019 10:03 pm:
>> On Sun, Jun 23, 2019 at 08:41:51PM +1000, Nicholas Piggin wrote:
>>> This makes it clear to the caller that it can only be used on POWER9
>>> and later CPUs.
>> 
>>> -#define PPC_INVALIDATE_ERAT	PPC_SLBIA(7)
>>> +#define PPC_ARCH_300_INVALIDATE_ERAT	PPC_SLBIA(7)
>> 
>> The architecture version is 3.0 (or 3.0B), not "300".  This will work on
>> implementations of later architecture versions as well, so maybe the name
>> isn't so great anyway?
>
> Yeah... this is kernel convention for better or worse. ISA v3.0B
> feature support is called CPU_FTR_ARCH_300, and later architectures
> will advertise that support. For the most part we can use architected
> features (incompatible changes would require additional code).

I'd rather we used 3_0B or something inside the kernel, but I'm not sure
it's worth the churn to rename the existing feature everywhere. And we
can't rename the user visible feature.

But if you're adding a new usage then I'd prefer: PPC_ISA_3_0B_INVALIDATE_ERAT

I dislike "300" because it implies we support ISA v3.0 but we actually
don't, we only support v3.0B.

cheers
