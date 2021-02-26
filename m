Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027B5326A91
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Feb 2021 01:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhB0AAA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 19:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhBZX77 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 18:59:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5429C061574
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:59:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u12so6807594pjr.2
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 15:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=MdnJV7L+flQpiq1z76Nfmc99kpcCv9yxwq6tbq/YWPU=;
        b=ZqDfPF2Orz1qA8SiA3Q8s1sbgEuwDf94rWDFAJy0GEOesgXrS46keo20LadEPS40Xl
         CAfhaZjZ+iBQI/wCrRyZ1vb2vk5MWyA1aZzy4M80cnSZiUyvNSHYTaTG2Uo6u7KDfEqC
         gMXtBMuxUo2NJEa6xjER7XrAKL7Der+qXYLQYKdeuxOvCbu0d1EqvGamjGv5qWocK/PO
         on9qQUW3m76mWnKtzy4t0GEZyygY/NlAYc/Vi/9EZ7Ds5yOCa//CsPwSJ7nbXyddXpfX
         2g5NI6+8jidgLOInygKP1ZOvD5eoFqEr/Ci84TLykwq+u43ggHd/khzB2Cig2Fe+Ig2E
         BtHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=MdnJV7L+flQpiq1z76Nfmc99kpcCv9yxwq6tbq/YWPU=;
        b=Q+gho6ofejgOZauogZn6OmlYlLNR9pZ5xXrfLfQqf/vOl6yxT6mTF+xbTVijAnYN5x
         m+Z8dTJvgcjUcq0nvjMMSUdKiM/28XxrnBXxG/FIPFKtxcT3ZUD6oFKOf5Z9nh3vqfJc
         uDn7+JtHy1xin210JLB+YQWPyRoWFUb27BZmfFDja4yGW//hrn5t1AFryfviDL7U2+mI
         pl32Qn44VkvZRAQizVqXDAqLbCR47+INkGZlzSpdI7RrjxPFpyXsSpreIwF0w8wty/zX
         k3b2ZS2iHEvQdbBisbM3to0mfgNg9pIPygjCwr3r7yYw0tNGU52Tcq3eo2/7k7x58pjo
         PUwg==
X-Gm-Message-State: AOAM533BC/bdxYSPthmJb7MrHCrNqSMm3Cod6yd9JY3mGhAo6QRFSnhf
        aRqr49HvG3E3a/+jllhrO/Qi+5kj+lY=
X-Google-Smtp-Source: ABdhPJx2q+U+TINlMd/GtxDI/hjQxEfddz0DuKOeRBrxDZgrC3xzdfqi/pfBmwEk9IL5JbwLu4lhAw==
X-Received: by 2002:a17:90b:2281:: with SMTP id kx1mr5717929pjb.113.1614383959303;
        Fri, 26 Feb 2021 15:59:19 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id u66sm11621578pfc.72.2021.02.26.15.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 15:59:18 -0800 (PST)
Date:   Sat, 27 Feb 2021 09:59:13 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 16/37] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     =?iso-8859-1?q?C=E9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-17-npiggin@gmail.com>
        <47ae7b2f-9356-6cff-da38-142eaea773ca@kaod.org>
In-Reply-To: <47ae7b2f-9356-6cff-da38-142eaea773ca@kaod.org>
MIME-Version: 1.0
Message-Id: <1614383911.azeq7dbfo9.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from C=C3=A9dric Le Goater's message of February 26, 2021 12:51 am=
:
> On 2/25/21 2:46 PM, Nicholas Piggin wrote:
>> In the interest of minimising the amount of code that is run in
>> "real-mode", don't handle hcalls in real mode in the P9 path.
>>=20
>> POWER8 and earlier are much more expensive to exit from HV real mode
>> and switch to host mode, because on those processors HV interrupts get
>> to the hypervisor with the MMU off, and the other threads in the core
>> need to be pulled out of the guest, and SLBs all need to be saved,
>> ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
>> in host mode. Hash guests also require a lot of hcalls to run. The
>> XICS interrupt controller requires hcalls to run.
>>=20
>> By contrast, POWER9 has independent thread switching, and in radix mode
>> the hypervisor is already in a host virtual memory mode when the HV
>> interrupt is taken. Radix + xive guests don't need hcalls to handle
>> interrupts or manage translations.
>>=20
>> So it's much less important to handle hcalls in real mode in P9.
>>=20
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/include/asm/kvm_ppc.h      |  5 +++++
>>  arch/powerpc/kvm/book3s_hv.c            | 25 ++++++++++++++++++++++---
>>  arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 +++++
>>  arch/powerpc/kvm/book3s_xive.c          | 25 +++++++++++++++++++++++++
>>  4 files changed, 57 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/a=
sm/kvm_ppc.h
>> index 73b1ca5a6471..db6646c2ade2 100644
>> --- a/arch/powerpc/include/asm/kvm_ppc.h
>> +++ b/arch/powerpc/include/asm/kvm_ppc.h
>> @@ -607,6 +607,7 @@ extern void kvmppc_free_pimap(struct kvm *kvm);
>>  extern int kvmppc_xics_rm_complete(struct kvm_vcpu *vcpu, u32 hcall);
>>  extern void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu);
>>  extern int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd);
>> +extern int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req);
>>  extern u64 kvmppc_xics_get_icp(struct kvm_vcpu *vcpu);
>>  extern int kvmppc_xics_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
>>  extern int kvmppc_xics_connect_vcpu(struct kvm_device *dev,
>> @@ -639,6 +640,8 @@ static inline int kvmppc_xics_enabled(struct kvm_vcp=
u *vcpu)
>>  static inline void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu) { }
>>  static inline int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd)
>>  	{ return 0; }
>> +static inline int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req=
)
>> +	{ return 0; }
>>  #endif
>> =20
>>  #ifdef CONFIG_KVM_XIVE
>> @@ -673,6 +676,7 @@ extern int kvmppc_xive_set_irq(struct kvm *kvm, int =
irq_source_id, u32 irq,
>>  			       int level, bool line_status);
>>  extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
>>  extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
>> +extern void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu);
>=20
> I can not find this routine. Is it missing or coming later in the patchse=
t ?=20

Yeah it leaked into a later patch but it belongs here. I'll fix it.

Thanks,
Nick
