Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D27512A51
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Apr 2022 06:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbiD1EPx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 28 Apr 2022 00:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiD1EPw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 28 Apr 2022 00:15:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55082237CC
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Apr 2022 21:12:37 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so6670160pjq.0
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Apr 2022 21:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=io+jKzHun/DVw5+/escf8la1hEu0bh7CLX1jPSTeK14=;
        b=F/JO9whyVX6P0mC9GTWkkIHpJ2qVhAS/VGzRILSJQQtlmaEv63fNx/+5rcWlx3EBef
         Z+sxD833iLzTjlXaGkVV4dQxl8T13yF4uvDY5ccFSTyLGbfHFbpEr93qnPAxPcek1sMn
         PwCHz9kGS2pCjCb3on9BUpRMhxHWcEawaJuvYWIc6gB5V+RBMA7kJJCymSfwkrASY/2F
         +qkukDCX4iuaWOULo0OmMvxVKR/sQh1tnnhQ9dz3qzhgRvNYgg4ebQVeedgSSy/Afnta
         /adZbPnKUd9YCOzSLseW+WLBMQUGI3Ne7cLEtfxaBAEnrxKQ1/NZN25XtscdjBjmCrSh
         Ms+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=io+jKzHun/DVw5+/escf8la1hEu0bh7CLX1jPSTeK14=;
        b=I/XuLpEngHfhbio8CS+Jlwo/cMn+R4woKtbiRSkX777mC7fQ7R6TIMw0NHe8IZBFNk
         CHbgNOXrddTtJJeUCZOYWjGyBIh8czipsoTkCQVHZ5m3Q7c2nP8RFXXepVcONr4a+V7K
         u5Gm27KBid3LqhPLVo/5NTZopkytKfu4Zo0XdZtMhnzbpwCrLWqMHLhfnu0pfirc6niA
         mLKniMxFeYxMklEttYdMLr4W6pUVu4LHQnLNndcdMP+MN6+maGagPfv74irCIfntqMWW
         MUlOBmuALYpU3QIImL3cnJSxF4YpViueYGB1bzvRSTXpxFnypJNCJyGhwan3uiO+/nDR
         6DsQ==
X-Gm-Message-State: AOAM531rMTcvRjwwoQh5LXaoR0omxywYoIEqoQLQyypK0XjcK6AK7od2
        MJfwQAPqf715x+IfOjs9ZSKDbC1LPWeggQ==
X-Google-Smtp-Source: ABdhPJxMomsldnYQpSewhOKG2Jkua0Lv2p4xeHWBFC1Yd4ibjIORF+fWCVPmEMgtlMtiVhkMHcDW7Q==
X-Received: by 2002:a17:90a:1116:b0:1d9:a41a:d13d with SMTP id d22-20020a17090a111600b001d9a41ad13dmr15601739pja.206.1651119156838;
        Wed, 27 Apr 2022 21:12:36 -0700 (PDT)
Received: from localhost (193-116-105-54.tpgi.com.au. [193.116.105.54])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm21733118pfu.120.2022.04.27.21.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 21:12:36 -0700 (PDT)
Date:   Thu, 28 Apr 2022 14:12:30 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Initialize AMOR in nested entry
To:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au
References: <20220425142151.1495142-1-farosas@linux.ibm.com>
In-Reply-To: <20220425142151.1495142-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1651118922.7qh15cf4pc.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of April 26, 2022 12:21 am:
> The hypervisor always sets AMOR to ~0, but let's ensure we're not
> passing stale values around.
>=20

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Looks like our L0 doesn't do anything with hvregs.amor ?

Thanks,
Nick

> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 6fa518f6501d..b5f504576765 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3967,6 +3967,7 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vc=
pu *vcpu, u64 time_limit, uns
> =20
>  	kvmhv_save_hv_regs(vcpu, &hvregs);
>  	hvregs.lpcr =3D lpcr;
> +	hvregs.amor =3D ~0;
>  	vcpu->arch.regs.msr =3D vcpu->arch.shregs.msr;
>  	hvregs.version =3D HV_GUEST_STATE_VERSION;
>  	if (vcpu->arch.nested) {
> --=20
> 2.35.1
>=20
>=20
