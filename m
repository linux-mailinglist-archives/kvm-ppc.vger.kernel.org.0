Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0530B68221
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 04:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfGOCB5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 14 Jul 2019 22:01:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35514 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfGOCB5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 14 Jul 2019 22:01:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24so7484901plp.2
        for <kvm-ppc@vger.kernel.org>; Sun, 14 Jul 2019 19:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lA/ZbfEc02zbLPfMDvSjpx/eUQq1QypxqafA6N7NhN8=;
        b=ErKvuoE9bXRPuW359j9IxktUzXwJuaK19B/rNbenI/pLBptRf1hSLSN8CDDOeDTnUT
         /uYQUBy4JqyfuqLFlHtEeui51tYAsiTakLpyXDwO7M6KqcMoe+Mw21VufqyO6ELKO9l4
         gm0n8FLOOE6nt0X0ucK71ZeafFx9k2r10kd/qNkGtjzbaIDUWX6sP48XUjioEOJ1klCJ
         OZgVdhZU+5m91pAaeYAqu/ChEPAT7bhHQ9cwQ/iSlDavQNxqAIj6r8gCe+HRG+vpBgdC
         85LyVwQI72Z0n/kEqNBtRZDNsMZKCQogAXsnDNuYgnvOEmsBnGWY/5WNyGSxNPY9AAYD
         jtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lA/ZbfEc02zbLPfMDvSjpx/eUQq1QypxqafA6N7NhN8=;
        b=FYiu/0kROxBHpWtHOFcv/Szwj2ZsST6odjIAKqpwXGXQDU51UuVCEFVQ1MqUS/OJk/
         dTPQiHTDMcqiCKilu50KyCY1sTrSrXg6E2Rnl8x8Fs6HPNIdDxW7k/Y6JnXd+EoJmiD6
         P6GsEmhWV5Gfg9pJgT6+dYfSqi1ZMl0OEMWOZxP3LVehJaT0sKsU3pfrmUl9kj924ESC
         NW91+kmhlKL2lst1C4PCkRTxJREt/7mCWZ99nHz6O5PLRGNRYYABoe1nbGPqvVrsBcUw
         DyWxDrzKdQAHTKQSP+bM7wf0mIxPTIANzSmULts8GUOVJSOQvOgvfpYpMakwIak2W5jD
         pN9g==
X-Gm-Message-State: APjAAAW4VoieLJ5jLO/lBm0Jm5e7Jtbwb7Vr5GWsDOqQz05VXiayXHi9
        qdVUZVTR2uQGWaJesRdy1YL1MMNn
X-Google-Smtp-Source: APXvYqzRcXp0CcRxSqr/P86P+xh+lUDyxmYewjv9BUKmEORpeLvaOYg5X4BtjT421yLiUIt2c/vj7A==
X-Received: by 2002:a17:902:a417:: with SMTP id p23mr25194413plq.136.1563156116083;
        Sun, 14 Jul 2019 19:01:56 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id o32sm14954211pje.9.2019.07.14.19.01.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Jul 2019 19:01:55 -0700 (PDT)
Message-ID: <1563156110.2145.5.camel@gmail.com>
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Always save guest pmu for
 guest capable of nesting
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, paulus@ozlabs.org
Date:   Mon, 15 Jul 2019 12:01:50 +1000
In-Reply-To: <87lfx2egt4.fsf@concordia.ellerman.id.au>
References: <20190703012022.15644-1-sjitindarsingh@gmail.com>
         <87lfx2egt4.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 2019-07-13 at 13:47 +1000, Michael Ellerman wrote:
> Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> > The performance monitoring unit (PMU) registers are saved on guest
> > exit
> > when the guest has set the pmcregs_in_use flag in its lppaca, if it
> > exists, or unconditionally if it doesn't. If a nested guest is
> > being
> > run then the hypervisor doesn't, and in most cases can't, know if
> > the
> > pmu registers are in use since it doesn't know the location of the
> > lppaca
> > for the nested guest, although it may have one for its immediate
> > guest.
> > This results in the values of these registers being lost across
> > nested
> > guest entry and exit in the case where the nested guest was making
> > use
> > of the performance monitoring facility while it's nested guest
> > hypervisor
> > wasn't.
> > 
> > Further more the hypervisor could interrupt a guest hypervisor
> > between
> > when it has loaded up the pmu registers and it calling
> > H_ENTER_NESTED or
> > between returning from the nested guest to the guest hypervisor and
> > the
> > guest hypervisor reading the pmu registers, in
> > kvmhv_p9_guest_entry().
> > This means that it isn't sufficient to just save the pmu registers
> > when
> > entering or exiting a nested guest, but that it is necessary to
> > always
> > save the pmu registers whenever a guest is capable of running
> > nested guests
> > to ensure the register values aren't lost in the context switch.
> > 
> > Ensure the pmu register values are preserved by always saving their
> > value into the vcpu struct when a guest is capable of running
> > nested
> > guests.
> > 
> > This should have minimal performance impact however any impact can
> > be
> > avoided by booting a guest with "-machine pseries,cap-nested-
> > hv=false"
> > on the qemu commandline.
> > 
> > Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest
> > entry/exit path on P9 for radix guests"
> 
> I'm not clear why this and the next commit are marked as fixing the
> above commit. Wasn't it broken prior to that commit as well?

That was the commit which introduced the entry path which we use for a
nested guest, the path on which we need to be saving and restoring the
pmu registers and so where the new code was introduced.

It wasn't technically broken prior to that commit since you couldn't
run nested prior to that commit, and in fact it's a few commits after
that one where we actually enabled the ability to run nested guests.

However since that's the code which introduced the nested entry path it
seemed like the best fit for the fixes tag for people who will be
looking for fixes in that area. Also all the other nested entry path
fixes used that fixes tag so it ties them together nicely.

Thanks,
Suraj

> 
> cheers
> 
> > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > ---
> >  arch/powerpc/kvm/book3s_hv.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_hv.c
> > b/arch/powerpc/kvm/book3s_hv.c
> > index ec1804f822af..b682a429f3ef 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -3654,6 +3654,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu
> > *vcpu, u64 time_limit,
> >  		vcpu->arch.vpa.dirty = 1;
> >  		save_pmu = lp->pmcregs_in_use;
> >  	}
> > +	/* Must save pmu if this guest is capable of running
> > nested guests */
> > +	save_pmu |= nesting_enabled(vcpu->kvm);
> >  
> >  	kvmhv_save_guest_pmu(vcpu, save_pmu);
> >  
> > -- 
> > 2.13.6
