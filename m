Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F8C3E2431
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 09:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhHFHeY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 03:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbhHFHeX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 03:34:23 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EF8C061798
        for <kvm-ppc@vger.kernel.org>; Fri,  6 Aug 2021 00:34:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ggy0G11Pcz9sCD;
        Fri,  6 Aug 2021 17:34:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1628235246;
        bh=6aJ5cEo3MkqnUspd6fLCdrsVKPeYDkl7qVBbV+RvnsE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=l+H5H3B5SGOe99aqxzr2NN2vMV0dtzKh1f0bHEECKTP/orEzVDDshHXPN3uGw5ZPn
         91AIDK364G9Yt/NTvPED+QLsO6gUXBxL+yjiHwIWGiKeaVuYMFfTBQESxwyugHq4/p
         eUD+ioFXeDMAK8r/6qtHPn6XmKptmU/6lRD7ZA+VKw4uPXcz5HkvePm1Wh1cNWkYcW
         0XKKMtTNmnzRZm5NUgzJiWeL/nALfd3Rs+sEL5YZL3/gFzdbgi9v44MrMVIwQjveuv
         upCxoPJDv6+0tIIxYhGGvGjVJb5PbcM1ZAw2WhJ6DdUF7auJOpeOMnwSHa7jbBtF06
         lo3ukLhS4DV8A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 14/55] KVM: PPC: Book3S HV: Don't always save PMU for
 guest capable of nesting
In-Reply-To: <20210726035036.739609-15-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
 <20210726035036.739609-15-npiggin@gmail.com>
Date:   Fri, 06 Aug 2021 17:34:03 +1000
Message-ID: <871r77ni1g.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> Revert the workaround added by commit 63279eeb7f93a ("KVM: PPC: Book3S
> HV: Always save guest pmu for guest capable of nesting").
>
> Nested capable guests running with the earlier commit ("KVM: PPC: Book3S
> HV Nested: Indicate guest PMU in-use in VPA") will now indicate the PMU
> in-use status of their guests, which means the parent does not need to
> unconditionally save the PMU for nested capable guests.
>
> This will cause the PMU to break for nested guests when running older
> nested hypervisor guests under a kernel with this change. It's unclear
> there's an easy way to avoid that, so this could wait for a release or
> so for the fix to filter into stable kernels.

I'm not sure PMU inside nested guests is getting much use, but I don't
think we can break this quite so casually :)

Especially as the failure mode will be PMU counts that don't match
reality, which is hard to diagnose. It took nearly a year for us to find
the original bug.

I think we need to hold this back for a while.

We could put it under a CONFIG option, and then flip that option to off
at some point in the future.

cheers

> index e7f8cc04944b..ab89db561c85 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4003,8 +4003,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  		vcpu->arch.vpa.dirty = 1;
>  		save_pmu = lp->pmcregs_in_use;
>  	}
> -	/* Must save pmu if this guest is capable of running nested guests */
> -	save_pmu |= nesting_enabled(vcpu->kvm);
>  
>  	kvmhv_save_guest_pmu(vcpu, save_pmu);
>  #ifdef CONFIG_PPC_PSERIES
> -- 
> 2.23.0
