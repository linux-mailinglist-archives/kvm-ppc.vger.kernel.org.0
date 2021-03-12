Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B123384E0
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Mar 2021 06:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCLFIC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Mar 2021 00:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhCLFH4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 12 Mar 2021 00:07:56 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC99CC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Mar 2021 21:07:56 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so4271656pjb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Mar 2021 21:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Aw8LdrIy0N+x7RWdCdmmkmT4qhnI7TsuuwjFLzDAHCg=;
        b=iiFmQA/ujrKz79YHZfVGSeFKgwmlp1xcvs5qM1LU+dCINPeVoAVxJCPmTzVvT7nUog
         SfKW53M7u4loOU2OJnzuOO9IFWGOfkXsrPtf0NMSuWyU1q1LmVpw9wr/xSMFtW/q7N9i
         QkMVEF6qW2xnLWxjVfOBnJqhrTTuKYOD1j74s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Aw8LdrIy0N+x7RWdCdmmkmT4qhnI7TsuuwjFLzDAHCg=;
        b=c0foGsbePiv6bhfDykl2HdOWwG7X2k/S2dJgz89pyjzemkUFTnzMdJFl3iWvBTb5ew
         4t+/892O8qanhdLAq8xwWg0t0GantVhHd3uCHbNpuNXRn/2UFLEcRsG3TqJwTXirRqTB
         gHK2icJVZqg+2Tec7tsr6FcrbChrTZm+cFnrnog3LuN6NIavNq+49PV/PWGlLKltVA7U
         xQR4GpjgcIPzrz9FfWRB9EBclFD5MCOKah7WO8XFr28j387LLS3UsYOX/Oxvp0QXYPZp
         fs4KOnh0IKoCrzE8Trp3MI3i9brmwQZuLQeDShXYBiAYBcAlceT7XGn/UKc3cnJjG+v1
         DCBQ==
X-Gm-Message-State: AOAM5332X5WvZ998rykezi8L5kcc2Imgh26RihV7LOrwf2+akN4btriW
        6NXLSSZsOcc3NFDdddN3+U8WSw==
X-Google-Smtp-Source: ABdhPJyDC5thnbRF6vH+OWtFPtshcHt9zGNXl3bAvIhIAAiWc8LkvHsuU8eEV6jCKV5y1HazdorJHg==
X-Received: by 2002:a17:903:22d2:b029:e5:df4f:3d64 with SMTP id y18-20020a17090322d2b02900e5df4f3d64mr11868068plg.37.1615525676335;
        Thu, 11 Mar 2021 21:07:56 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id 134sm3978946pfc.113.2021.03.11.21.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 21:07:55 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v3 03/41] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
In-Reply-To: <20210305150638.2675513-4-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com> <20210305150638.2675513-4-npiggin@gmail.com>
Date:   Fri, 12 Mar 2021 16:07:52 +1100
Message-ID: <87ft117ydz.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> This SPR is set to 0 twice when exiting the guest.
>
Indeed it is.

I checked the ISA because I'd never heard of the PSPB SPR before! It's
the Problem State Priority Boost register. Before I knew what it was, I
was slightly concerned that the chip might change the value while the
other mtsprs were running, but given that it's just affects the priority
boost states that problem state can use, I don't think that is actually
going to happen.

I also checked the commit that introduced it - commit 95a6432ce903
("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix
guests"), and there wasn't any justification for having a double mtspr.

So, this seems good:
Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel


> Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2e29b96ef775..0542d7f17dc3 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3758,7 +3758,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	mtspr(SPRN_DSCR, host_dscr);
>  	mtspr(SPRN_TIDR, host_tidr);
>  	mtspr(SPRN_IAMR, host_iamr);
> -	mtspr(SPRN_PSPB, 0);
>
>  	if (host_amr != vcpu->arch.amr)
>  		mtspr(SPRN_AMR, host_amr);
> -- 
> 2.23.0
