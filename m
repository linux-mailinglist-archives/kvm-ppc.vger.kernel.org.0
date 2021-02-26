Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8C5325D6A
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Feb 2021 07:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBZGHX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 01:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhBZGHV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 01:07:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E471EC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 22:06:40 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o22so6197838pjs.1
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 22:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1mVcmt0ZvY7Uv/jshYVKfExfLIN+9bxYoK2/ZcoShx8=;
        b=cGJiVIMr+BajjT84h1CERxfdSJ3E9SkaPODfTg0VPl8zt7WtkAIIeox4NipnJW/mjd
         ix/M4jOuC6+pdsz2is5lgyU2cY3Bfb2EsW34KmCrSenAEl6O6BqSvWNcdm9Mt54qt0Dh
         o81KFKm2HQQG2a8yymigwn0RoQyEPoAMFWq4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1mVcmt0ZvY7Uv/jshYVKfExfLIN+9bxYoK2/ZcoShx8=;
        b=l01HnRHfYYSKtSLIKw7M8pWWtadhK7DZyyCteMG/ZSHNJFPk1MerRImBb7KklE+hNG
         gkY4fyifjfj3SRuc2FbbYEJZUN8GBGUYM8wF+my36LruLaS7q1lMDbJAK3gGqGVvzGHr
         XJ9l8gdtRUmQbbedRSbLrMfv58+Z9oSEZ3QISKQfpDaFLbd7SSy1hvQQXRJeYsqCYxkz
         Z68fttpB7HkMJQitcFV7fEfzgweuYcNjMLzbKD8qMVpBI1ta+v5d3HGOmQ8bD27kasZx
         T7X+OBqysj3CdGoIG4vPmYsZcCQOouOUKAdUK7cYyF4Hw+o0fiXLedc0mr2ymL4NgDa+
         O7lQ==
X-Gm-Message-State: AOAM532X0odoc+s8SEIfGtZdNMOHyq5vczM+mu6r5gHwRkYrJ5fvyj48
        eni9JY0lge2ZsTug/+95uI5//Q==
X-Google-Smtp-Source: ABdhPJxRVDYc+YcFZabj+EZQgRYsNoYJYXUYFQ5jIxIuNmSPMuoJ9AG0F5STIxLuj5dRAWfpb1Nv7Q==
X-Received: by 2002:a17:90b:1b47:: with SMTP id nv7mr1758380pjb.235.1614319600443;
        Thu, 25 Feb 2021 22:06:40 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id q13sm8167423pfs.183.2021.02.25.22.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 22:06:40 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v2 05/37] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
In-Reply-To: <20210225134652.2127648-6-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-6-npiggin@gmail.com>
Date:   Fri, 26 Feb 2021 17:06:37 +1100
Message-ID: <87zgzr8is2.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

>  void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
>  {
> +	/*
> +	 * Guest must always run with machine check interrupt
> +	 * enabled.
> +	 */
> +	if (!(msr & MSR_ME))
> +		msr |= MSR_ME;

This 'if' is technically redundant but you mention a future patch warning
on !(msr & MSR_ME) so I'm holding off on any judgement about the 'if' until
I get to that patch :)

The patch seems sane to me, I agree that we don't want guests running with
MSR_ME=0 and kvmppc_set_msr_hv already ensures that the transactional state is
sane so this is another sanity-enforcement in the same sort of vein.

All up:
Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

> +
>  	/*
>  	 * Check for illegal transactional state bit combination
>  	 * and if we find it, force the TS field to a safe state.
> -- 
> 2.23.0
