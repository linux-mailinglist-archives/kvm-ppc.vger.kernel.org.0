Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68417325CD5
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Feb 2021 06:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBZFCb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 00:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhBZFCa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 00:02:30 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA5DC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 21:01:50 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id g4so5547070pgj.0
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 21:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ONONQmKKLgRI6txfN7nZzG8ZKShi1zdqEa9NKzPqd3E=;
        b=h+pajDz3m4XZUqTFlaQVxPtcQPzwA7yMI2I9aemClWUrS6jzudQAza5o02EGuf1yRS
         RgYtUH3aeg41kRTdbDJsZ2OSAPDC92Ddd1Ste5BRlQPqcUC/rxZo++g8uywrFKu0P4Lm
         LXF4k/Vs2Q/4CuGhvuP7DCmFBE9WsNL76VbjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ONONQmKKLgRI6txfN7nZzG8ZKShi1zdqEa9NKzPqd3E=;
        b=Ac5VigOBSz384SNojz9I56pDhVt3XN5/Xv2upL7utecwV94f9ZqHKQq2rbJbbKpFdP
         BktM5SzdFa95D9D+V5wWjjXyE/9CUjKDZB9i63l/WE6wiE0zgQfk4PNBTDdHEClc5wgn
         GQ0Lg+OSK19WMvUQGnHECYrlH5/8CFnMZAoodlD5B4RpBkwVLw1NK3O+AGDSNHdQTP+W
         NyFjJffy98gbqYq4/98n+4b8s/hU8l7Tkl32Wobi4N+9C+sNkPmE0EX9a6imzAFV/uN7
         SpQT/u9DyzKnWfmP+4Jj2YudTpjR+1+YKUwvdvayhIGWAyuIeKtfcieRVcqrpwBr516O
         SKQQ==
X-Gm-Message-State: AOAM532/GycOiCMv82sSqg2zoqb0IvNGaxMUBBkGpCDzm1gHRQaZM/y+
        pvfQ0JanZUXF2HxrI1fMlrW6CnDuZvbsu4EN
X-Google-Smtp-Source: ABdhPJzgjekTt0EMEqjOTzklf7dGBWjpxXDSUb3/tzvk0WOQlACltMeiroiwrvOEBI7gaeLGoT4BFw==
X-Received: by 2002:a63:ff53:: with SMTP id s19mr1306250pgk.347.1614315709698;
        Thu, 25 Feb 2021 21:01:49 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id h8sm7251059pfv.154.2021.02.25.21.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 21:01:49 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 01/37] KVM: PPC: Book3S 64: remove unused kvmppc_h_protect argument
In-Reply-To: <20210225134652.2127648-2-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-2-npiggin@gmail.com>
Date:   Fri, 26 Feb 2021 16:01:45 +1100
Message-ID: <878s7ba0cm.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> The va argument is not used in the function or set by its asm caller,
> so remove it to be safe.

Huh, so it isn't. I tracked the original implementation down to commit
a8606e20e41a ("KVM: PPC: Handle some PAPR hcalls in the kernel") where
paulus first added the ability to handle it in the kernel - there it
takes a va argument but even then doesn't do anything with it.

ajd also pointed out that we don't pass a va when linux is running as a
guest, and LoPAR does not mention va as an argument.

One small nit: checkpatch is complaining about spaces vs tabs:
ERROR: code indent should use tabs where possible
#25: FILE: arch/powerpc/include/asm/kvm_ppc.h:770:
+                      unsigned long pte_index, unsigned long avpn);$

WARNING: please, no spaces at the start of a line
#25: FILE: arch/powerpc/include/asm/kvm_ppc.h:770:
+                      unsigned long pte_index, unsigned long avpn);$

Once that is resolved,
  Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel Axtens

> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/kvm_ppc.h  | 3 +--
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c | 3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 8aacd76bb702..9531b1c1b190 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -767,8 +767,7 @@ long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned long flags,
>                       unsigned long pte_index, unsigned long avpn);
>  long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu);
>  long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
> -                      unsigned long pte_index, unsigned long avpn,
> -                      unsigned long va);
> +                      unsigned long pte_index, unsigned long avpn);
>  long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
>                     unsigned long pte_index);
>  long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
> diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> index 88da2764c1bb..7af7c70f1468 100644
> --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> @@ -673,8 +673,7 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
>  }
>  
>  long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
> -		      unsigned long pte_index, unsigned long avpn,
> -		      unsigned long va)
> +		      unsigned long pte_index, unsigned long avpn)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	__be64 *hpte;
> -- 
> 2.23.0
