Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DD077B368
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Aug 2023 10:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjHNIJk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Aug 2023 04:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjHNIJW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 14 Aug 2023 04:09:22 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657C91702;
        Mon, 14 Aug 2023 01:08:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6884310ee75so12156b3a.1;
        Mon, 14 Aug 2023 01:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692000538; x=1692605338;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHc6qGu7Ail6gjahuSN4onxMeC32IE8coMewoeVpo+4=;
        b=XrN429NkkjvtYKQqtj/TEdZqVZrUQ8b8FHbFO4j5Y+ZO5uZ5r1Dfi3Xs4qIqnZtmR8
         F5VO+c0FbRHfFpuj7l5LrzFaNDanNnZjOShVZ0fzMH6WPQcweob6q4tU7SYsXp+yAZLh
         E6USBDxvKoxbAvmJAoZAC5JDZ5NQvfz8JaX5NIUmAFWCslykElgu2lYNnd/hu9Kb9VCm
         rdgyy4TIhst6yWvWegUv4GxmpkkREiUbF0z8jCeNuJp4XYLtZnR0GZX2Q3862rFGn3Nt
         VCdonYgUs9k7PStlrktcNrAqS033qjRIl8FV6Y+8/UzmsK6NV/ZO1SkriS/QDxTLax0L
         vv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692000538; x=1692605338;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HHc6qGu7Ail6gjahuSN4onxMeC32IE8coMewoeVpo+4=;
        b=ZiY30ICURJsSGkFe6ztTXnivvurzfr2rj0SroHWHawrwtMGNI5/NpMGK9iA8h9XQAh
         MzrcHH3vYvK38lTPk/zGWYJUfDprs27VaROYAGlFUVTKsO9lPoAUbLat5tDMF3YgTMT5
         5UmrgYosKKKEF+E2jRH5fkk52ZC/tIYFrU30JsmHERCjz/awIKMhp2a6L+NCw35dzQXa
         CtQl7UXYrDZUl548+MhtRfggwuAO6R2BnXkxF61vuRKCp5sxetWczYuH9EYFPD+U0nl6
         sNv6XYR61cDzsbCQfO4OY9ORumjdZUr4V9f90ghPxrLgh8uve9ilPiJaf7aJCpmBJGJ7
         pquQ==
X-Gm-Message-State: AOJu0Yzr618hcRomxnq0FuB08L0YI702GXhKgEOK12Z10Hmy3VgEU5/7
        oBzQ6yDEKlv7ew+kK0Yz+A3RtvK8IZA=
X-Google-Smtp-Source: AGHT+IEOmHQAaO2710jyujKN7BPqeOdoqB8zTN52ofQqctE6cqKFRrusISuSxbuG3YPodBsb9qeYBw==
X-Received: by 2002:a05:6a00:b85:b0:686:24b0:554b with SMTP id g5-20020a056a000b8500b0068624b0554bmr12388389pfj.22.1692000538498;
        Mon, 14 Aug 2023 01:08:58 -0700 (PDT)
Received: from localhost ([61.68.161.249])
        by smtp.gmail.com with ESMTPSA id p16-20020a639510000000b005658d3a46d7sm4085195pgd.84.2023.08.14.01.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 01:08:58 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 14 Aug 2023 18:08:52 +1000
Message-Id: <CUS44PQRFL72.28PFLWO36FYAO@wheely>
Cc:     <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <mikey@neuling.org>, <paulus@ozlabs.org>, <vaibhav@linux.ibm.com>,
        <sbhat@linux.ibm.com>, <gautam@linux.ibm.com>,
        <kconsul@linux.vnet.ibm.com>, <amachhiw@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/6] KVM: PPC: Use getters and setters for vcpu
 register state
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Jordan Niethe" <jniethe5@gmail.com>,
        <linuxppc-dev@lists.ozlabs.org>
X-Mailer: aerc 0.15.2
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-2-jniethe5@gmail.com>
In-Reply-To: <20230807014553.1168699-2-jniethe5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon Aug 7, 2023 at 11:45 AM AEST, Jordan Niethe wrote:
> There are already some getter and setter functions used for accessing
> vcpu register state, e.g. kvmppc_get_pc(). There are also more
> complicated examples that are generated by macros like
> kvmppc_get_sprg0() which are generated by the SHARED_SPRNG_WRAPPER()
> macro.
>
> In the new PAPR "Nestedv2" API for nested guest partitions the L1 is
> required to communicate with the L0 to modify and read nested guest
> state.
>
> Prepare to support this by replacing direct accesses to vcpu register
> state with wrapper functions. Follow the existing pattern of using
> macros to generate individual wrappers. These wrappers will
> be augmented for supporting Nestedv2 guests later.
>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
> ---
> v3:
>   - Do not add a helper for pvr
>   - Use an expression when declaring variable in case
>   - Squash in all getters and setters
>   - Guatam: Pass vector registers by reference
> ---
>  arch/powerpc/include/asm/kvm_book3s.h  | 123 +++++++++++++-
>  arch/powerpc/include/asm/kvm_booke.h   |  10 ++
>  arch/powerpc/kvm/book3s.c              |  38 ++---
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |   4 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |   9 +-
>  arch/powerpc/kvm/book3s_64_vio.c       |   4 +-
>  arch/powerpc/kvm/book3s_hv.c           | 220 +++++++++++++------------
>  arch/powerpc/kvm/book3s_hv.h           |  58 +++++++
>  arch/powerpc/kvm/book3s_hv_builtin.c   |  10 +-
>  arch/powerpc/kvm/book3s_hv_p9_entry.c  |   4 +-
>  arch/powerpc/kvm/book3s_hv_ras.c       |   5 +-
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c    |   8 +-
>  arch/powerpc/kvm/book3s_hv_rm_xics.c   |   4 +-
>  arch/powerpc/kvm/book3s_xive.c         |   9 +-
>  arch/powerpc/kvm/emulate_loadstore.c   |   2 +-
>  arch/powerpc/kvm/powerpc.c             |  76 ++++-----
>  16 files changed, 395 insertions(+), 189 deletions(-)
>

[snip]

> +
>  /* Expiry time of vcpu DEC relative to host TB */
>  static inline u64 kvmppc_dec_expires_host_tb(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu->arch.dec_expires - vcpu->arch.vcore->tb_offset;
> +	return kvmppc_get_dec_expires(vcpu) - kvmppc_get_tb_offset_hv(vcpu);
>  }

I don't see kvmppc_get_tb_offset_hv in this patch.

> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3=
s_64_mmu_hv.c
> index 7f765d5ad436..738f2ecbe9b9 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -347,7 +347,7 @@ static int kvmppc_mmu_book3s_64_hv_xlate(struct kvm_v=
cpu *vcpu, gva_t eaddr,
>  	unsigned long v, orig_v, gr;
>  	__be64 *hptep;
>  	long int index;
> -	int virtmode =3D vcpu->arch.shregs.msr & (data ? MSR_DR : MSR_IR);
> +	int virtmode =3D kvmppc_get_msr(vcpu) & (data ? MSR_DR : MSR_IR);
> =20
>  	if (kvm_is_radix(vcpu->kvm))
>  		return kvmppc_mmu_radix_xlate(vcpu, eaddr, gpte, data, iswrite);

So this isn't _only_ adding new accessors. This should be functionally a
noop, but I think it introduces a branch if PR is defined.

Shared page is a slight annoyance for HV, I'd like to get rid of it...
but that's another story. I think the pattern here would be to add a
kvmppc_get_msr_hv() accessor.

And as a nitpick, for anywhere employing existing access functions, gprs
and such, could that be split into its own patch?

Looks pretty good aside from those little things.

Thanks,
Nick
