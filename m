Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6968D4EA915
	for <lists+kvm-ppc@lfdr.de>; Tue, 29 Mar 2022 10:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiC2IVf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 29 Mar 2022 04:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiC2IVe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 29 Mar 2022 04:21:34 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51198326EA
        for <kvm-ppc@vger.kernel.org>; Tue, 29 Mar 2022 01:19:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w8so16963323pll.10
        for <kvm-ppc@vger.kernel.org>; Tue, 29 Mar 2022 01:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=+BQQikJPmuFMFFUhgZstKn2ehOJbUcy0wVlEIm+OMNw=;
        b=Grb80NNNkoGpRBPmdHSOINVeVj5NHWTYZDw4p0Gd4C7kZo5pZ3YO09zzKwGWcc3wzI
         QUA8OUPiK8AXC1qgRL7j+XEEHEeN4cnAd2GNXADdmo2QXyNHeTr1iJxotobASxgBowha
         1pdQaBy3ASf508g9+mgoPnW5SQlp36l5cgH9AyA/3b6ocQ+jIgrhkd+OZpEiyRxaYwtw
         muwHDFoGMSyKlQNaYX8BLb9l81HyYSsuFv3Zg/nXzeOiOtKqIBTY6n3fuNL/N/oP3YrM
         ZXfQWyrEScXP2KKh3U0z7DyPGbYHnlRFAfcLumsPiKOovquxcI9Mt4isfs6l29RQdzzh
         d7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=+BQQikJPmuFMFFUhgZstKn2ehOJbUcy0wVlEIm+OMNw=;
        b=Wp5g41+2Z24XGzawNoUrrmmCs5RWK8JWR3+DocfUp6ADMeUQ2aJjto/dQVdwWqa72H
         zgv/JvtPzIEmhKCvX0NqLUtDnmgISrXTnDv7k18Z7Fdnh/zAhLAI5OSsMNwlqII1ebVA
         aNVHZsR+JYlgvjb2r8LSifowb7jh3k+4Ow+9g1SZf6uoOBM54lAD37fVIN1YBmuWgK4p
         kQxp2MwpSrWI4vhG8Y/bQwdFd56WTQXWI3EjGHuoopyyuw5GdfZGaArWlgxYQ78BTpQf
         sa41cC+3TA3vLg9Mo1uIzNtJ+ndm3WoF/TFzmlf0yHfxtASI7jpza2sImLMJBRJVQLMx
         MzKw==
X-Gm-Message-State: AOAM533LQMGaXfOrQyk5+Q0ZthTXUQRhLVJHlZos5svEakD62lNgA/0O
        31mqo2cHEDQD/KngLNaalq6TNokdFnc=
X-Google-Smtp-Source: ABdhPJx8H9NEeDpOiaemybgKimyOiRyvIy8IwHUL8CApJL3bMWqkTws7fvxZaYRlZcBzs9BqmGaPNg==
X-Received: by 2002:a17:90a:9294:b0:1b9:48e9:a030 with SMTP id n20-20020a17090a929400b001b948e9a030mr3352342pjo.200.1648541990704;
        Tue, 29 Mar 2022 01:19:50 -0700 (PDT)
Received: from localhost (58-6-255-110.tpgi.com.au. [58.6.255.110])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004fb28fafc4csm12672527pfk.97.2022.03.29.01.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 01:19:50 -0700 (PDT)
Date:   Tue, 29 Mar 2022 18:19:42 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au
References: <20220328215831.320409-1-farosas@linux.ibm.com>
In-Reply-To: <20220328215831.320409-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1648541941.gxj49rdes1.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 29, 2022 7:58 am:
> We removed most of the vcore logic from the P9 path but there's still
> a tracepoint that tried to dereference vc->runner.

Thanks for the fix.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Fixes: ecb6a7207f92 ("KVM: PPC: Book3S HV P9: Remove most of the vcore lo=
gic")
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 8 ++++----
>  arch/powerpc/kvm/trace_hv.h  | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index c886557638a1..5f5b2d0dee8c 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4218,13 +4218,13 @@ static void kvmppc_vcore_blocked(struct kvmppc_vc=
ore *vc)
>  	start_wait =3D ktime_get();
> =20
>  	vc->vcore_state =3D VCORE_SLEEPING;
> -	trace_kvmppc_vcore_blocked(vc, 0);
> +	trace_kvmppc_vcore_blocked(vc->runner, 0);
>  	spin_unlock(&vc->lock);
>  	schedule();
>  	finish_rcuwait(&vc->wait);
>  	spin_lock(&vc->lock);
>  	vc->vcore_state =3D VCORE_INACTIVE;
> -	trace_kvmppc_vcore_blocked(vc, 1);
> +	trace_kvmppc_vcore_blocked(vc->runner, 1);
>  	++vc->runner->stat.halt_successful_wait;
> =20
>  	cur =3D ktime_get();
> @@ -4596,9 +4596,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u6=
4 time_limit,
>  			if (kvmppc_vcpu_check_block(vcpu))
>  				break;
> =20
> -			trace_kvmppc_vcore_blocked(vc, 0);
> +			trace_kvmppc_vcore_blocked(vcpu, 0);
>  			schedule();
> -			trace_kvmppc_vcore_blocked(vc, 1);
> +			trace_kvmppc_vcore_blocked(vcpu, 1);
>  		}
>  		finish_rcuwait(wait);
>  	}
> diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
> index 38cd0ed0a617..32e2cb5811cc 100644
> --- a/arch/powerpc/kvm/trace_hv.h
> +++ b/arch/powerpc/kvm/trace_hv.h
> @@ -409,9 +409,9 @@ TRACE_EVENT(kvmppc_run_core,
>  );
> =20
>  TRACE_EVENT(kvmppc_vcore_blocked,
> -	TP_PROTO(struct kvmppc_vcore *vc, int where),
> +	TP_PROTO(struct kvm_vcpu *vcpu, int where),
> =20
> -	TP_ARGS(vc, where),
> +	TP_ARGS(vcpu, where),
> =20
>  	TP_STRUCT__entry(
>  		__field(int,	n_runnable)
> @@ -421,8 +421,8 @@ TRACE_EVENT(kvmppc_vcore_blocked,
>  	),
> =20
>  	TP_fast_assign(
> -		__entry->runner_vcpu =3D vc->runner->vcpu_id;
> -		__entry->n_runnable  =3D vc->n_runnable;
> +		__entry->runner_vcpu =3D vcpu->vcpu_id;
> +		__entry->n_runnable  =3D vcpu->arch.vcore->n_runnable;
>  		__entry->where       =3D where;
>  		__entry->tgid	     =3D current->tgid;
>  	),
> --=20
> 2.35.1
>=20
>=20
