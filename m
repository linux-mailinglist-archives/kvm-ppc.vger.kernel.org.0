Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E2325CF9
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Feb 2021 06:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBZFWf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 00:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhBZFWe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 00:22:34 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80101C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 21:21:54 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b8so1879636plh.0
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 21:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=G0n0GtXCnVUgNxEQs6ivYCWrbpuorhBY/DfuohJYFLM=;
        b=kQTrHw3+qJExsopJW13hHe6o+yaiTvQIM8RzPMuNoJHjgIvjpUtfGA/oe7PqlMGzme
         z+Ox71hBclSBFo+9h9hYPRLh2IADsVEDpBVpBzuDlqNqvD00ImAywrIjAwgF40To92ZB
         DiwHtptmkvdHCF6XMB2oK6eJBeGmMKPnngC9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=G0n0GtXCnVUgNxEQs6ivYCWrbpuorhBY/DfuohJYFLM=;
        b=eoGd0JCR35FLhdhOfE8DvBW6cs67F0BLbeJ/mYxeowWpLWDvnqG4zdaarJC8fLpKTS
         FOf0V+dsPikV4WIOwu1GOV7YisO8/HX8Gxkug3duA7p83OukYD/nV6nEA0HuMguLEC7H
         QHspMAEbayXRwex/ALI8XlBrK3oCfcAJcmzQI3pVx1CGeKYXidQGwKZM1/JpFFbo69j4
         fWy+UojHDPTQH21/olulsLhSf2Y7ZUiK3WxwhgJldaKkyftxmTlCRp6WW7xBncLfCh2c
         PZm/tUakS2zNI8ZfrlWpO1P0dWEfU2PvUELpk2BVumml+lxFxGhR3dU7lkh+o1iSrU+0
         9GcQ==
X-Gm-Message-State: AOAM533k5KNWvJ3sA4/KlQLZp8wFeRw0CqiOSghbzqslVL5aQbgSU+UN
        cllOwzNYVOBHi6lTGCYco8DECA==
X-Google-Smtp-Source: ABdhPJwAJ8yfjWTchCphDH+TWvqyIAj8tFTBcC3i25C3OhOMwD2WBbduCpjTqMsT4+0bhS1PDGOHFg==
X-Received: by 2002:a17:90a:66cd:: with SMTP id z13mr1597599pjl.171.1614316914006;
        Thu, 25 Feb 2021 21:21:54 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id 192sm5259559pfx.193.2021.02.25.21.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 21:21:53 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 02/37] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
In-Reply-To: <20210225134652.2127648-3-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-3-npiggin@gmail.com>
Date:   Fri, 26 Feb 2021 16:21:50 +1100
Message-ID: <875z2f9zf5.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> This config option causes the warning in init_default_hcalls to fire
> because the TCE handlers are in the default hcall list but not
> implemented.

I checked that the TCE handlers are indeed not defined unless
CONFIG_SPAPR_TCE_IOMMU=y, and so I can see how you would hit the
warning.

This seems like the right solution to me.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 13bad6bf4c95..895090636295 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5369,8 +5369,10 @@ static unsigned int default_hcall_list[] = {
>  	H_READ,
>  	H_PROTECT,
>  	H_BULK_REMOVE,
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>  	H_GET_TCE,
>  	H_PUT_TCE,
> +#endif
>  	H_SET_DABR,
>  	H_SET_XDABR,
>  	H_CEDE,
> -- 
> 2.23.0
