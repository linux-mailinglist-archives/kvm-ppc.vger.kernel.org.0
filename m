Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50B63149E2
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 09:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBIIBD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 03:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBIIAc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Feb 2021 03:00:32 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A7BC061786
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Feb 2021 23:59:52 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x136so4822745pfc.2
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Feb 2021 23:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=MqQxySyjZ6a1wLj5kW0+ega6PBQu/gHsVLCfNZ2NsJs=;
        b=gESe9yQUejqF9/04hLvlS3fqzcTvYSzRCEJrHhXPko7RPBt92AT0Vwgy6nGi8bI4A9
         sLV5jJ1aa1fOHsg2ny6sB2txIr4Jrr/2EGiszPXrCHkqhDZLNfm416lWWNBEJV5UMG48
         VUpEMiBeVgaW17kL6KCPa76UPr2aErLsqSSrrpaXEJOfTlJHmTUHUMbTHgItQht3OeVg
         ymeldCxka1Mh6mKHrMiFf4Y4Fu9pk+zVRmSpMbjqBWS7cGE3GtH7QoYB3Aas8DrYAeYJ
         Av1ggQYtFnAnF9RnPhy3ubRCzoiplFYWZ74Hds6CbKbWufxeY0INd/HodJlmyWfNuxWN
         6Tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=MqQxySyjZ6a1wLj5kW0+ega6PBQu/gHsVLCfNZ2NsJs=;
        b=Sa5Tn5gak4bJjcVOndTawlr+ruyR5iGrOwBVxIS93DvJmTTX993MgRFZX6H1oPUFR0
         cS4zZQ0zCdr/Zth04ydCw+gxF9arTm6PpSi5SDzWTW/P3I7IMG4WAALJzqUIgpAs1AaL
         FXSm+13OzYFed+8jCXWA5oYCJHK/O6DsVW2m/e9SxZ0Zev1wMgJJ2ug+r4DtM6j9ZWRi
         Qi+u+djcI8Vh+ajQYckFLaT3kIYEVhBX2n+JhAq8SD6kEfr9s5xqO4XkQQKEDU9Jf7I8
         ahI8kaZuVTtuauuia4BWNLZk+r6Qxhe70+ue7XAdhM1RDfJud0b6Y3tCSmT8PncwNOPy
         Gffg==
X-Gm-Message-State: AOAM530o7XyiJ7lLuqySZ2UQfBboksv7h4mrFhmrl6EyV/ZlDCO1u/9J
        9xWhXry1ImiyEX7QJs2oeXs=
X-Google-Smtp-Source: ABdhPJxPwVNu8NZQDUlU5k0o8x/GdDspYh8pc9OdLkTN38Wd9+Lfd6Sv8nIKL8/JlbadMSJ+KmcMew==
X-Received: by 2002:a62:7cd7:0:b029:1d5:727a:8fec with SMTP id x206-20020a627cd70000b02901d5727a8fecmr20977447pfc.15.1612857591788;
        Mon, 08 Feb 2021 23:59:51 -0800 (PST)
Received: from localhost ([1.132.146.177])
        by smtp.gmail.com with ESMTPSA id t21sm5627138pfe.174.2021.02.08.23.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 23:59:50 -0800 (PST)
Date:   Tue, 09 Feb 2021 17:59:44 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a
 vcpu moves between threads in a core
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org
References: <20210118122609.1447366-1-npiggin@gmail.com>
        <20210118122609.1447366-2-npiggin@gmail.com> <87sg6x5kfo.fsf@linux.ibm.com>
        <1611101698.8m2ih5f8sn.astroid@bobo.none>
        <20210209072602.GC2841126@thinks.paulus.ozlabs.org>
In-Reply-To: <20210209072602.GC2841126@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Message-Id: <1612857540.t11eh8o7bv.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Paul Mackerras's message of February 9, 2021 5:26 pm:
> On Wed, Jan 20, 2021 at 10:26:51AM +1000, Nicholas Piggin wrote:
>> Excerpts from Aneesh Kumar K.V's message of January 19, 2021 7:45 pm:
>> > Nicholas Piggin <npiggin@gmail.com> writes:
>> >=20
>> >> As explained in the comment, there is no need to flush TLBs on all
>> >> threads in a core when a vcpu moves between threads in the same core.
>> >>
>> >> Thread migrations can be a significant proportion of vcpu migrations,
>> >> so this can help reduce the TLB flushing and IPI traffic.
>> >>
>> >> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>> >> ---
>> >> I believe we can do this and have the TLB coherency correct as per
>> >> the architecture, but would appreciate someone else verifying my
>> >> thinking.
>> >>
>> >> Thanks,
>> >> Nick
>> >>
>> >>  arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++++++++--
>> >>  1 file changed, 26 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_h=
v.c
>> >> index 752daf43f780..53d0cbfe5933 100644
>> >> --- a/arch/powerpc/kvm/book3s_hv.c
>> >> +++ b/arch/powerpc/kvm/book3s_hv.c
>> >> @@ -2584,7 +2584,7 @@ static void kvmppc_release_hwthread(int cpu)
>> >>  	tpaca->kvm_hstate.kvm_split_mode =3D NULL;
>> >>  }
>> >> =20
>> >> -static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcp=
u *vcpu)
>> >> +static void radix_flush_cpu(struct kvm *kvm, int cpu, bool core, str=
uct kvm_vcpu *vcpu)
>> >>  {
>> >=20
>> > Can we rename 'core' to something like 'core_sched'  or 'within_core'=20
>> >=20
>> >>  	struct kvm_nested_guest *nested =3D vcpu->arch.nested;
>> >>  	cpumask_t *cpu_in_guest;
>> >> @@ -2599,6 +2599,14 @@ static void radix_flush_cpu(struct kvm *kvm, i=
nt cpu, struct kvm_vcpu *vcpu)
>> >>  		cpu_in_guest =3D &kvm->arch.cpu_in_guest;
>> >>  	}
>> >>
>> >=20
>> > and do
>> >       if (core_sched) {
>>=20
>> This function is called to flush guest TLBs on this cpu / all threads on=
=20
>> this cpu core. I don't think it helps to bring any "why" logic into it
>> because the caller has already dealt with that.
>=20
> I agree with Aneesh that the name "core" doesn't really help the
> reader to know what the parameter means.  Either it needs a comment or
> a more descriptive name.

Okay. 'all_threads_in_core' is less typing than a comment :)

Thanks,
Nick
