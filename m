Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29D538DB59
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 May 2021 16:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhEWODn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 May 2021 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbhEWODn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 23 May 2021 10:03:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1F4C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 23 May 2021 07:02:17 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so9771047pjb.3
        for <kvm-ppc@vger.kernel.org>; Sun, 23 May 2021 07:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:cc:references:in-reply-to:mime-version:message-id
         :content-transfer-encoding;
        bh=1/FeozxHRfVpleVaZSH9JCIqWkiRJTS5gM5GLQ+G1WY=;
        b=Nqe1Si+8L6X4kAdBMNtvSUWX2K9vuEAtbhGHaCgOFgiWFVkgWq6/uWmEZ5NICuopRM
         SFLy9Jtltmgcwnt483yP0XyqSlEHLfky1aU6vL+2yXGi7kkZvG9cZ7NpU6hSxI31bfxm
         ZU0XZtLnKljXUDYq9/DaKOAfyoFMkyLGf3qFohwQnzYX+T1LbpqPo693BZtT9CMy5Fla
         YfBvroAv4vKPEgE0D0xr28yOD+VJnDg/A8xoeGD0CuGMfUagTW7ubcKROgAqobnDZVzq
         cvgY3a7sYUzG+kGe9L0LYDWylH0A6W1Cng2fMyJJmnWUSt6pcRYschJjSgfN/DlHOBfa
         4j3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=1/FeozxHRfVpleVaZSH9JCIqWkiRJTS5gM5GLQ+G1WY=;
        b=jyT0IkJBV9lMkguuLUJ7XGFAL1UnBfSzVoV7WNPOkno6vVlIdPTpbwo3oMUzp8dFDc
         nUFcPa+ZViIQFNauKfaMMU/8DYdFhq3atuy9i4luwyT3Iu2Hy6GN2G+Sj4dBc0H8FTd9
         qDsxE2dDX8G4uG72j8TgAufysgob5gVL+B0SjBOyM6CZPPp7Y+lfVukI3nr/uAKAZpo4
         QBAjgCjDPjZ8TiTsjnj3YGpeezKUnTIPuOQEXGklR7igZFr8eiQ6E2zWNopu9pzKqwtA
         il2/8xiutSox6AgWjLcHMMsiuUqcDW2uPD9Ox7D/OLzy2jCp5VUCqeUkavkc6drdGDz8
         6qVg==
X-Gm-Message-State: AOAM53378U+3q9Sfx8o4ubMOV6064+6y2Wn9tLbOoxA7sRmnNEdZTDa4
        fDEJ1Zy14oo5xUiwrfyR5E0=
X-Google-Smtp-Source: ABdhPJyQ1myZY8wmPQTpUqCXjc7D31Sm72H5tntQMZ8fQ5yAIkd0hxgaM1iN6+dMqk24BmU0EgYrIg==
X-Received: by 2002:a17:902:9685:b029:ef:70fd:a5a2 with SMTP id n5-20020a1709029685b02900ef70fda5a2mr21004700plp.20.1621778536859;
        Sun, 23 May 2021 07:02:16 -0700 (PDT)
Received: from localhost ([210.185.78.224])
        by smtp.gmail.com with ESMTPSA id 136sm8698589pfu.195.2021.05.23.07.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 07:02:16 -0700 (PDT)
Date:   Mon, 24 May 2021 00:02:10 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
Cc:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Michael Neuling <mikey@neuling.org>
References: <20210523122101.3247232-1-npiggin@gmail.com>
In-Reply-To: <20210523122101.3247232-1-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1621778273.kjvbvpehfw.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of May 23, 2021 10:21 pm:
> Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
> FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
> FSCR. The logic explained in that patch actually applies there to the
> old path well: a context switch can be made before kvmppc_vcpu_run_hv
> restores the host FSCR and returns.
>=20
> Fixes: b005255e12a3 ("KVM: PPC: Book3S HV: Context-switch new POWER8 SPRs=
")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/b=
ook3s_hv_rmhandlers.S
> index 5e634db4809b..2b98e710c7a1 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -44,7 +44,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
>  #define NAPPING_UNSPLIT	3
> =20
>  /* Stack frame offsets for kvmppc_hv_entry */
> -#define SFS			208
> +#define SFS			216
>  #define STACK_SLOT_TRAP		(SFS-4)
>  #define STACK_SLOT_SHORT_PATH	(SFS-8)
>  #define STACK_SLOT_TID		(SFS-16)
> @@ -59,8 +59,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
>  #define STACK_SLOT_UAMOR	(SFS-88)
>  #define STACK_SLOT_DAWR1	(SFS-96)
>  #define STACK_SLOT_DAWRX1	(SFS-104)
> +#define STACK_SLOT_FSCR		(SFS-112)
>  /* the following is used by the P9 short path */
> -#define STACK_SLOT_NVGPRS	(SFS-152)	/* 18 gprs */
> +#define STACK_SLOT_NVGPRS	(SFS-160)	/* 18 gprs */

Actually, hmm.. this is wrong because nvgprs are subtracted from
this offset. But then I can't work out why 95a6432ce9038 raised
SFS from 160 to 208.

Thanks,
Nick
