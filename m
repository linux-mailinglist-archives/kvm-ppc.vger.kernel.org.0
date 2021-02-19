Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613A631F4A4
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 06:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhBSFTE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 00:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSFTD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 00:19:03 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67366C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 21:18:23 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e9so3460796pjj.0
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 21:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dOSKkRk/bzqzj43v5P9ak3HT+jUMbvevUBEbWD/wiYc=;
        b=mCUCsWcN8EJvFt0JHWA9xAhHK9agA73CiOuRUp0P8McEzqnyBhYK4kgTGDgTJtMy9i
         1TRAaJ89XPH0H7e2GlnzVaf9wXoEJSx1IF1goGU8GSDYmhgYwl4ewX4uu0bFxcvEEuOE
         YgZUl8I7QqOMeM/xrkfkLScBRWM6pW19lfi30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dOSKkRk/bzqzj43v5P9ak3HT+jUMbvevUBEbWD/wiYc=;
        b=gOj69RdTDFUN9kqtqC0yrJSEjoAm5UKmddPv6d300gpI02G5+2+VkGhUcciv1J0D/G
         CAwoHZ3eWvcqKTq3kxXWVviKzV7+j0TjepRgGRHd0mCgf28tGgGCrDBy9sVIEPJWckxy
         mqv8KYtRZ8Bcd5XO3QDkgboDjpcDRbk8kOigcwIMrbOe+hwRbxGTEB0ScRPg/ZCC8EQW
         1lbBz068FAjxsK1j2djpu+MBBAWo1TiKafGa6PhaNqzy1o68E7W0WmjZ4dXXtTqv2exP
         qp7uGEdwXyqKmho6n4Wg+0nJV+lkZi94UfjZHNeuebzCSbbv7NKoARQ+Mqi+Hw2PwLVe
         hz4w==
X-Gm-Message-State: AOAM530eRPcUK2/WA5UYqL6oyIBKRgP2cNzn6d1povlidnTTaSVwr0OW
        cctoFzrnz0M8j0Yo105HEdY+Y6lND1kcMsOH
X-Google-Smtp-Source: ABdhPJzqRyzbsmPJm7JLbxU9H49OdN0ac/604fQ1hGBxAeDc5TDke5FrpPWfyXkola5Oo9V4dERBBw==
X-Received: by 2002:a17:90a:cb8e:: with SMTP id a14mr1696085pju.196.1613711902856;
        Thu, 18 Feb 2021 21:18:22 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id o9sm8081438pfp.21.2021.02.18.21.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 21:18:22 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 1/9] KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
In-Reply-To: <20210202030313.3509446-2-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com> <20210202030313.3509446-2-npiggin@gmail.com>
Date:   Fri, 19 Feb 2021 16:18:19 +1100
Message-ID: <87o8ggab50.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -0,0 +1,34 @@
> +#include <asm/cache.h>
> +#include <asm/ppc_asm.h>
> +#include <asm/kvm_asm.h>
> +#include <asm/reg.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/kvm_book3s_asm.h>
> +
> +/*
> + * We come here from the first-level interrupt handlers.
> + */
> +.global	kvmppc_interrupt
> +.balign IFETCH_ALIGN_BYTES
> +kvmppc_interrupt:
> +	/*
> +	 * Register contents:

Clearly r9 contains some data at this point, and I think it's guest r9
because of what you say later on in
book3s_hv_rmhandlers.S::kvmppc_interrupt_hv. Is that right? Should that
be documented in this comment as well?

> +	 * R12		= (guest CR << 32) | interrupt vector
> +	 * R13		= PACA
> +	 * guest R12 saved in shadow VCPU SCRATCH0
> +	 * guest R13 saved in SPRN_SCRATCH0
> +	 */
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	std	r9, HSTATE_SCRATCH2(r13)
> +	lbz	r9, HSTATE_IN_GUEST(r13)
> +	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
> +	beq	kvmppc_bad_host_intr
> +#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> +	cmpwi	r9, KVM_GUEST_MODE_GUEST
> +	ld	r9, HSTATE_SCRATCH2(r13)
> +	beq	kvmppc_interrupt_pr
> +#endif
> +	b	kvmppc_interrupt_hv
> +#else
> +	b	kvmppc_interrupt_pr
> +#endif

Apart from that I had a look and convinced myself that the code will
behave the same as before. On that basis:

Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel
