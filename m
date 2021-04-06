Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A842354AFF
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Apr 2021 04:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhDFCpA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 5 Apr 2021 22:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbhDFCo7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 5 Apr 2021 22:44:59 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95C3C06174A
        for <kvm-ppc@vger.kernel.org>; Mon,  5 Apr 2021 19:44:51 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l123so7883086pfl.8
        for <kvm-ppc@vger.kernel.org>; Mon, 05 Apr 2021 19:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=FZm+EBfOQgvjiADT1DUFSfdKoGcbMkOWnvlGZD1PacI=;
        b=oCphvhssbO2PhWCoIEYdTMKhVBPzrOcf5Q1FqsvhvxRWcnDYtq0XgBjalhDMY5h9Xb
         3cJxpEeAasev85V5NiEyKb/EVco+G7H+S30R+jpmAaPp+cpgXao2ORhofp+dB7rhPFqT
         GwGbUkaVYkSj+aUwBrodEtqpp4SiDsC78ivNN4aBSjTZ+yCFL404XTxZCFQLpfxcMjvx
         wh3J5mNnc1ji8nE1zP+C7TRQVe/88lJICTSMt3CTrxQlqzuxerI6LlSVq8YPm6bJj8T1
         LDKJ4VSziJE3R6kfBNFbUFSLlpOyAERldgsr2acIrl+ofHSmz52jtkoAtP6FKBu8Znkc
         ST2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=FZm+EBfOQgvjiADT1DUFSfdKoGcbMkOWnvlGZD1PacI=;
        b=nT3wNJkSAQSTskkMh2PHqAhnjQ0eoVsV4oo9fDoCx6WxiUyoMwPPT9NP1sS5tx6ABo
         HxP3jCu8eQ3bw6ndAnMDFyfF08pPSYuIZRILLxHiEW/pXAmGo4GBu4Xw9R+UEsJ2wlJ3
         rUI1WLKFXKr4TpLDldUeBqabqnxStNLpMeEK8oOVJonVJmAUt226gKPjI6F7IP2FZ/sK
         fRSpSyhWbSwpg1yfHh3pMF7PCllPlRb0VCZXJUBj1rRcu9ejnjdYUTxIow3+i6RSi2N0
         hIQ7ZK2JnAfLCeCG2+dqV0Y0ceU/8e34y4VvpmA/8NaEVlYUOFYqIqvqIA1nVaX1LxGE
         hhaw==
X-Gm-Message-State: AOAM531G/KJq5Eri5zrs9bMKO5rNL6BCkR7P+17OYlbO0UDLpL2IlgLz
        bau7uhqh8CFeFU0P8EDTs/IKX/epa4Bisg==
X-Google-Smtp-Source: ABdhPJwoWEZ6RmYbFxqD+A+FedYJxC1i6ORbby/bSg+LA9ABSLcl1CSMJrsUm/JYBeyOugHVe82gZw==
X-Received: by 2002:a65:6559:: with SMTP id a25mr25361420pgw.106.1617677090871;
        Mon, 05 Apr 2021 19:44:50 -0700 (PDT)
Received: from localhost ([144.130.156.129])
        by smtp.gmail.com with ESMTPSA id v13sm16045664pfu.54.2021.04.05.19.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 19:44:50 -0700 (PDT)
Date:   Tue, 06 Apr 2021 12:44:45 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 09/48] powerpc/64s: remove KVM SKIP test from
 instruction breakpoint handler
To:     kvm-ppc@vger.kernel.org
Cc:     Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@ozlabs.org>
References: <20210405011948.675354-1-npiggin@gmail.com>
        <20210405011948.675354-10-npiggin@gmail.com>
In-Reply-To: <20210405011948.675354-10-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1617676583.kyex3nxmbg.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of April 5, 2021 11:19 am:
> The code being executed in KVM_GUEST_MODE_SKIP is hypervisor code with
> MSR[IR]=3D0, so the faults of concern are the d-side ones caused by acces=
s
> to guest context by the hypervisor.
>=20
> Instruction breakpoint interrupts are not a concern here. It's unlikely
> any good would come of causing breaks in this code, but skipping the
> instruction that caused it won't help matters (e.g., skip the mtmsr that
> sets MSR[DR]=3D0 or clears KVM_GUEST_MODE_SKIP).
>=20
>  [Paul notes: the 0x1300 interrupt was dropped from the architecture a
>   long time ago and is not generated by P7, P8, P9 or P10.]
>=20
> In fact it does not exist in ISA v2.01, which is the earliest supported
> now, but did exist in 600 series designs (some of the earliest 64-bit
> powerpcs), so it could probably be removed entirely.

Hmm, I looked at a 970 manual and that does have a 0x1300, but 2.01=20
(which it implements) does not, if I'm reading correctly. Seems strange
the interrupt would be taken out of the architecture then implemented,
but not mine to wonder why. Maybe I misread something.

We support G5 in Linux but not HV KVM, maybe PR KVM is supported though?

At any rate it can't be removed from Linux 64s yet, and may be relevant
for PR KVM, but that should still be okay according this reasoning they
should not be applicable to SKIP interrupts.

Thanks,
Nick

>=20
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/e=
xceptions-64s.S
> index a0515cb829c2..c9c446ccff54 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -2553,7 +2553,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
>  INT_DEFINE_BEGIN(instruction_breakpoint)
>  	IVEC=3D0x1300
>  #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> -	IKVM_SKIP=3D1
>  	IKVM_REAL=3D1
>  #endif
>  INT_DEFINE_END(instruction_breakpoint)
> --=20
> 2.23.0
>=20
>=20
