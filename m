Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25D16821E
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 03:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfGOB6b (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 14 Jul 2019 21:58:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33204 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfGOB6b (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 14 Jul 2019 21:58:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so6674172pfq.0
        for <kvm-ppc@vger.kernel.org>; Sun, 14 Jul 2019 18:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g0zyhxh4ks1ak56xEA2lEhz+tyGZV7cQskN34O5j4OQ=;
        b=nE0METqhxjmhBEfyXwCVsWIUJOj6dIweZWcGREMFX59UaGPo3X9fR6Emdyb7AlPd2U
         sXg3TtOYP14V48gYKEvYE4BkmvCoKPcAYEvKcbeZT+pGzWwrnzAmFEuYKv1QvC+wCj9m
         UwI1lAxz8DyAhoNXfj+HU2jvfELg/sTEheZSuePhBRNXbTAvBEhuUTkTGVEITaQ1fXSV
         yzktriO0SK9nR825fNZgbzgTwn53ofLDrs7DV9UGAAe+q2DSAvJncTP7hkNKJ62BUUwu
         mmrkaYUGcN5lIsEBqkUHxbJi1AQW/xd1R/8H0PzHvwkSteXAUXxuxKl7/kE8fEW/5ibK
         PiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g0zyhxh4ks1ak56xEA2lEhz+tyGZV7cQskN34O5j4OQ=;
        b=aWlz2q2oZGoDv7dpvVMXrdZqN8PJa5pzVlp9scp45OvSkJvnRN17trQ7H3wA9L8+FR
         9+px8GXWCJx3rCDOUbxcLYCpvOGU4PQPyxfrYyM3XPgfqIOn4GSO2sDqjtLDkUc/mw+Q
         Uv5dIj0nSHXu3T1BR0Aq6XgpeK7C8R+fPujYcUYTc3g5XnQDculAukjD3CkbyILRnoHb
         hJ8WA6huVtGbGP3a/wvRQG3iqGrnr9tPWQpvMm0Vq2Qr2T5ftSCoeF7oT989gN1j0nRH
         FNO9nx7bxvryEnBBzScAyme03Hz7BIGH3y4xuek1RoOI5mlHC18p9igbBH4UAXaymwTr
         95Gw==
X-Gm-Message-State: APjAAAUIkQ/jy8qq41aN6O/k95M+slUaSC6w8glJn5z1Pof6q2Dywi1o
        WFOaeGKG+pTkrQbwLWy+IRjNDE6J
X-Google-Smtp-Source: APXvYqwypHVqJSzNP6RDRYofw+mVtX+lsRxHONry5ynalPnbbOOX5tuRRJ4VOk9SUIaLaUhUkkW4WA==
X-Received: by 2002:a63:9249:: with SMTP id s9mr23468299pgn.356.1563155909708;
        Sun, 14 Jul 2019 18:58:29 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id r1sm17597451pfq.100.2019.07.14.18.58.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Jul 2019 18:58:28 -0700 (PDT)
Message-ID: <1563155904.2145.1.camel@gmail.com>
Subject: Re: [PATCH] powerpc: mm: Limit rma_size to 1TB when running without
 HV mode
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, david@gibson.dropbear.id.au
Date:   Mon, 15 Jul 2019 11:58:24 +1000
In-Reply-To: <87o91ze6wx.fsf@concordia.ellerman.id.au>
References: <20190710052018.14628-1-sjitindarsingh@gmail.com>
         <87o91ze6wx.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 2019-07-12 at 23:09 +1000, Michael Ellerman wrote:
> Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> > The virtual real mode addressing (VRMA) mechanism is used when a
> > partition is using HPT (Hash Page Table) translation and performs
> > real mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this
> > mode effective address bits 0:23 are treated as zero (i.e. the
> > access
> > is aliased to 0) and the access is performed using an implicit 1TB
> > SLB
> > entry.
> > 
> > The size of the RMA (Real Memory Area) is communicated to the guest
> > as
> > the size of the first memory region in the device tree. And because
> > of
> > the mechanism described above can be expected to not exceed 1TB. In
> > the
> > event that the host erroneously represents the RMA as being larger
> > than
> > 1TB, guest accesses in real mode to memory addresses above 1TB will
> > be
> > aliased down to below 1TB. This means that a memory access
> > performed in
> > real mode may differ to one performed in virtual mode for the same
> > memory
> > address, which would likely have unintended consequences.
> > 
> > To avoid this outcome have the guest explicitly limit the size of
> > the
> > RMA to the current maximum, which is 1TB. This means that even if
> > the
> > first memory block is larger than 1TB, only the first 1TB should be
> > accessed in real mode.
> > 
> > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> 
> I added:
> 
> Fixes: c3ab300ea555 ("powerpc: Add POWER9 cputable entry")
> Cc: stable@vger.kernel.org # v4.6+
> 
> 
> Which is not exactly correct, but probably good enough?

I think we actually want:
Fixes: c610d65c0ad0 ("powerpc/pseries: lift RTAS limit for hash")

Which is what actually caused it to break and for the issue to present
itself.

> 
> cheers
> 
> > diff --git a/arch/powerpc/mm/book3s64/hash_utils.c
> > b/arch/powerpc/mm/book3s64/hash_utils.c
> > index 28ced26f2a00..4d0e2cce9cd5 100644
> > --- a/arch/powerpc/mm/book3s64/hash_utils.c
> > +++ b/arch/powerpc/mm/book3s64/hash_utils.c
> > @@ -1901,11 +1901,19 @@ void
> > hash__setup_initial_memory_limit(phys_addr_t first_memblock_base,
> >  	 *
> >  	 * For guests on platforms before POWER9, we clamp the it
> > limit to 1G
> >  	 * to avoid some funky things such as RTAS bugs etc...
> > +	 * On POWER9 we limit to 1TB in case the host erroneously
> > told us that
> > +	 * the RMA was >1TB. Effective address bits 0:23 are
> > treated as zero
> > +	 * (meaning the access is aliased to zero i.e. addr = addr
> > % 1TB)
> > +	 * for virtual real mode addressing and so it doesn't make
> > sense to
> > +	 * have an area larger than 1TB as it can't be addressed.
> >  	 */
> >  	if (!early_cpu_has_feature(CPU_FTR_HVMODE)) {
> >  		ppc64_rma_size = first_memblock_size;
> >  		if (!early_cpu_has_feature(CPU_FTR_ARCH_300))
> >  			ppc64_rma_size = min_t(u64,
> > ppc64_rma_size, 0x40000000);
> > +		else
> > +			ppc64_rma_size = min_t(u64,
> > ppc64_rma_size,
> > +					       1UL <<
> > SID_SHIFT_1T);
> >  
> >  		/* Finally limit subsequent allocations */
> >  		memblock_set_current_limit(ppc64_rma_size);
> > -- 
> > 2.13.6
