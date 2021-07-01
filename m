Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A516D3B8E86
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Jul 2021 10:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhGAIHL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Jul 2021 04:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbhGAIHL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Jul 2021 04:07:11 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E41C061756
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Jul 2021 01:04:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ie21so2035406pjb.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Jul 2021 01:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=GGDX6c3bWhp7+8s6wd+GJQxCKEIt/gtf69ReO690w1w=;
        b=VjgAcxihyQIog9dGE5EjIb7vXiLlq2IKfLNfadzuCIf/7v+Dqla3Cs6DSdwfAcu+4j
         TL2Pk6MagG17KtwbpNcg5Yj3VQgHEalcu2PdgVADu6KaPz5eCuLamj975dJ8+kNWxuxl
         rmMRB/YkJ3/Y2y8yVkOSFATAB7FO3/RBn1HkY0GtgdJsqFPyW+pZhgo6TZjZo0gAM4yg
         iqGZZj2nQIL8mr2K6Y6RpoRd29/txwfmjQKcHF0Fe9YjYooIIfG2VLpxvdZp2t4uG9SV
         3g8LOMtOH6cKWHV0i55DFq4KbZB12ATaKvk10kcH/uI0Wtc6zHE1AIE4Vt8GPBZE5z3f
         wzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=GGDX6c3bWhp7+8s6wd+GJQxCKEIt/gtf69ReO690w1w=;
        b=lsozsfeltUFLTHRsop3XFn6ReLS64OIyR4hiUMxMR0LLPCqUcsi7tniCdB6u66niXA
         Q6Fl3Q3UZcyphhQgXkFMJ7kG1SrnwJnv5kQX905BJEgwxnsn6fGnvLBcG8lUifZECuAZ
         GO4uOr6YPbDWebrXtduxcfpjkyDhQlqg6kQkQth6wOA/+kLPsWhOzN2h5RjI2AofKWMT
         IfPp9veBatQp7oLv7mnJEUUFE7m49uEuBITHRJ7K08aLzhzOj3Fqao9XK3oSnalpb65d
         v9wt7qxlsisV5BPmFQrGr8OTJoOeW2744Hxhc7qT8xHlAiPCGollb9bmYPJ99TcPBcCO
         L6LA==
X-Gm-Message-State: AOAM5321SqW5Kdcd7/Ql+TpIO3S6I43VnTintv2cJGXwGId9eKolPFVt
        xyHozERb98ztVv6XBUssFZc=
X-Google-Smtp-Source: ABdhPJy66zGDfZrtRFftH1eqP3NOTctLY3VHlG1fDFrfRRfYgFwB34hOHPS08TPbtp8YePzWaUjJ4Q==
X-Received: by 2002:a17:90a:a395:: with SMTP id x21mr43858670pjp.63.1625126679747;
        Thu, 01 Jul 2021 01:04:39 -0700 (PDT)
Received: from localhost (220-244-87-52.tpgi.com.au. [220.244.87.52])
        by smtp.gmail.com with ESMTPSA id s63sm15836688pfb.195.2021.07.01.01.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 01:04:39 -0700 (PDT)
Date:   Thu, 01 Jul 2021 18:04:34 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 38/43] KVM: PPC: Book3S HV P9: Test dawr_enabled()
 before saving host DAWR SPRs
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210622105736.633352-1-npiggin@gmail.com>
        <20210622105736.633352-39-npiggin@gmail.com> <87eecj2qcv.fsf@linux.ibm.com>
In-Reply-To: <87eecj2qcv.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1625126603.992wxhpa1l.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of July 1, 2021 3:51 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Some of the DAWR SPR access is already predicated on dawr_enabled(),
>> apply this to the remainder of the accesses.
>>
>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> ---
>>  arch/powerpc/kvm/book3s_hv_p9_entry.c | 34 ++++++++++++++++-----------
>>  1 file changed, 20 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/bo=
ok3s_hv_p9_entry.c
>> index 7aa72efcac6c..f305d1d6445c 100644
>> --- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
>> +++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
>> @@ -638,13 +638,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64=
 time_limit, unsigned long lpc
>>
>>  	host_hfscr =3D mfspr(SPRN_HFSCR);
>>  	host_ciabr =3D mfspr(SPRN_CIABR);
>> -	host_dawr0 =3D mfspr(SPRN_DAWR0);
>> -	host_dawrx0 =3D mfspr(SPRN_DAWRX0);
>>  	host_psscr =3D mfspr(SPRN_PSSCR);
>>  	host_pidr =3D mfspr(SPRN_PID);
>> -	if (cpu_has_feature(CPU_FTR_DAWR1)) {
>> -		host_dawr1 =3D mfspr(SPRN_DAWR1);
>> -		host_dawrx1 =3D mfspr(SPRN_DAWRX1);
>> +
>> +	if (dawr_enabled()) {
>> +		host_dawr0 =3D mfspr(SPRN_DAWR0);
>> +		host_dawrx0 =3D mfspr(SPRN_DAWRX0);
>> +		if (cpu_has_feature(CPU_FTR_DAWR1)) {
>> +			host_dawr1 =3D mfspr(SPRN_DAWR1);
>> +			host_dawrx1 =3D mfspr(SPRN_DAWRX1);
>=20
> The userspace needs to enable DAWR1 via KVM_CAP_PPC_DAWR1. That cap is
> not even implemented in QEMU currently, so we never allow the guest to
> set vcpu->arch.dawr1. If we check for kvm->arch.dawr1_enabled instead of
> the CPU feature, we could shave some more time here.

Ah good point, yes let's do that.

Thanks,
Nick
