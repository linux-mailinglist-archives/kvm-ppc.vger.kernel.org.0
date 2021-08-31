Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D003FCE93
	for <lists+kvm-ppc@lfdr.de>; Tue, 31 Aug 2021 22:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhHaUaj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 31 Aug 2021 16:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240899AbhHaUaj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 31 Aug 2021 16:30:39 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88253C061764
        for <kvm-ppc@vger.kernel.org>; Tue, 31 Aug 2021 13:29:43 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d11so715221qtw.3
        for <kvm-ppc@vger.kernel.org>; Tue, 31 Aug 2021 13:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=HZ3pj56mGoBpB6xSaPok/o43VKjWK5QuZ3X0xEylQ7A=;
        b=BBMK7o+guuqTDQOFARaHRkaRTvS1c+yc3Lo6N9osZWow/fEaRX9vXQgPfVvLCKRAbS
         rYlEleVtV+xAkrL2t7kEDkfu3RJhBeKrF8Ppb4CY1l8nOaQXdasY360nDcjaxmC6ToCf
         jt4m8ipskpVtAun9oah/uZ/AwkHPPLsh1vSzqO2y5d8ULYYFgIpist2HBCDD7P9fCrBb
         kNz7cThumSgAxwRXvgSewucHuF6ZBg4cU7Sl6PbCzL2pmDu/yAms01vQ184aJzkHQjxt
         80t919GkhucHsuQ8jSHAgwMq6sgEZxzz9bjWrnCkrVL5UumlNy/Uh1yCZyszkTgix4o1
         N9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HZ3pj56mGoBpB6xSaPok/o43VKjWK5QuZ3X0xEylQ7A=;
        b=iL5b2TiDWBztVIFFw/1LsUNEuh/y3fjjsuUHkJtXp/AuzGpaaaRuc0nLqONQGITSS9
         Bvi0PmYTOZ4wwTtoDiQFdPIBIw5/oBd72QsdZQ0EcT2QJyvX8Z2xGNDjDjvirkzINQLe
         bYLbx2XXtbeZLHPzYVT9cH5vp0YeRfgHX/+XOH41YkB2h2hdOrhJiFgirGanVELiDZ0u
         9gyv4xjacz2Ywi4/3Wqvaq2JgD5xgNNJN+bp3PyVrXrYO7CUi/mMoUHbgoOFINfX+qVu
         yfjuAsMVXEf9r9s6SsxFQ1VmOPWzWQuVPfhrCqmMrcPoM/FYhnEgadj/FsiLhhNtkvWq
         gbfg==
X-Gm-Message-State: AOAM530i0qYRGXnmGnr2182if5tFv6kmm7LiHuVmito5tzx646J4lQA/
        W/16faf3ix4xcW2SxucD8OoYFo9tCLc=
X-Google-Smtp-Source: ABdhPJyX0j27HVECx4O2VgHX34zIa84/GutgBUzDHsVpXWO1ZkIzLYiQS+eWA1ICVuFpC2q7PBh7Hw==
X-Received: by 2002:ac8:4891:: with SMTP id i17mr4525321qtq.321.1630441782665;
        Tue, 31 Aug 2021 13:29:42 -0700 (PDT)
Received: from ?IPv6:2804:431:c7f1:e948:8e69:9cd6:5512:12f4? ([2804:431:c7f1:e948:8e69:9cd6:5512:12f4])
        by smtp.gmail.com with ESMTPSA id t8sm11433605qtn.37.2021.08.31.13.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 13:29:42 -0700 (PDT)
Message-ID: <12346f49d2f9962d654efe4466754c519a98c236.camel@gmail.com>
Subject: Re: [PATCH kernel] KVM: PPC: Fix clearing never mapped TCEs in
 realmode
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras.c@gmail.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Date:   Tue, 31 Aug 2021 17:30:00 -0300
In-Reply-To: <20210827040706.517652-1-aik@ozlabs.ru>
References: <20210827040706.517652-1-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hello Alexey,

On Fri, 2021-08-27 at 14:07 +1000, Alexey Kardashevskiy wrote:
> Since e1a1ef84cd07, pages for TCE tables for KVM guests are allocated
> only when needed. This allows skipping any update when clearing TCEs.
> This works mostly fine as TCE updates are handled when MMU is enabled.
> The realmode handlers fail with H_TOO_HARD when pages are not yet
> allocated except when clearing a TCE in which case KVM prints a warning
> but proceeds to dereference a NULL pointer which crashes the host OS.
> 
> This has not been caught so far as the change is reasonably new,
> POWER9 runs mostly radix which does not use realmode handlers.
> With hash, the default TCE table is memset() by QEMU the machine reset
> which triggers page faults and the KVM TCE device's
> kvm_spapr_tce_fault()
> handles those with MMU on. And the huge DMA windows are not cleared
> by VMs whicn instead successfully create a DMA window big enough to map
> the VM memory 1:1 and then VMs just map everything without clearing.
> 
> This started crashing now as upcoming sriov-under-powervm support added
> a mode when a dymanic DMA window not big enough to map the VM memory
> 1:1
> but it is used anyway, and the VM now is the first (i.e. not QEMU) to
> clear a just created table. Note that the upstream QEMU needs to be
> modified to trigger the VM to trigger the host OS crash.
> 
> This replaces WARN_ON_ONCE_RM() with a check and return.
> This adds another warning if TCE is not being cleared.
> 
> Cc: Leonardo Bras <leobras.c@gmail.com>
> Fixes: e1a1ef84cd07 ("KVM: PPC: Book3S: Allocate guest TCEs on demand
> too")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> With recent changes in the printk() department, calling pr_err() when
> MMU
> off causes lockdep lockups which I did not dig any further so we should
> start getting rid of the realmode's WARN_ON_ONCE_RM().
> ---
>  arch/powerpc/kvm/book3s_64_vio_hv.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c
> b/arch/powerpc/kvm/book3s_64_vio_hv.c
> index 083a4e037718..e5ba96c41f3f 100644
> --- a/arch/powerpc/kvm/book3s_64_vio_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
> @@ -173,10 +173,13 @@ static void kvmppc_rm_tce_put(struct
> kvmppc_spapr_tce_table *stt,
>         idx -= stt->offset;
>         page = stt->pages[idx / TCES_PER_PAGE];
>         /*
> -        * page must not be NULL in real mode,
> -        * kvmppc_rm_ioba_validate() must have taken care of this.
> +        * kvmppc_rm_ioba_validate() allows pages not be allocated if
> TCE is
> +        * being cleared, otherwise it returns H_TOO_HARD and we skip
> this.
>          */
> -       WARN_ON_ONCE_RM(!page);
> +       if (!page) {
> +               WARN_ON_ONCE_RM(tce != 0);
> +               return;
> +       }
>         tbl = kvmppc_page_address(page);
>  
>         tbl[idx % TCES_PER_PAGE] = tce;

That looks reasonable IMHO.

FWIW:
Reviewed-by: Leonardo Bras <leobras.c@gmail.com>

