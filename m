Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C573C3F2353
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Aug 2021 00:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhHSWk0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Aug 2021 18:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbhHSWk0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Aug 2021 18:40:26 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3736BC061575
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Aug 2021 15:39:49 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s11so7288914pgr.11
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Aug 2021 15:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=WX/qJVOnuFAI2moIv6OF4lqewvc4NdGxWkCdYilIaS4=;
        b=dIr051qis+9TSdlqlxkVlLOVanqfmbLXpUhEciivJ12h+asK6W8Lb8B1xQ5SOFx0ed
         hBWa5vXbV5b1XLr52yfjhKR12+utTBNZO8Ms6rSiPQtoDnQJGUQfsRj1N9qnjRpMnSko
         tbJ3maAALuUqpegMFAmcYb5xUkx8ZNp9IKaEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WX/qJVOnuFAI2moIv6OF4lqewvc4NdGxWkCdYilIaS4=;
        b=aZZ2SXTRb3t9x9lPkwQiPZ3BKQt49X/GGQyi3CFBkm5ok+D3dwmMl2ai1bhL0lQkOO
         bY5khBhchFahE6b7Q1H12Jxu86k4RtJGJ3d4t89GLI4vyuWSkBgcCs7udV9PhPp2N7r3
         fMGtA5bvzEnjhoVRqy7YAITNKRwjfiFqTDgzutE6soWslOSo1/PkTiR7XWbkl57zr7Q/
         7WmLGPWLhR/o6b0eTkBBpWAwfwjub5FuqeL6P7egf/TaCP/U0PEcrHGRcUjQ3afiPnXd
         IGjritRPuxlkTPTcRMabQrq86byR/BH9G45odO177FzNtUJP6Hd14OrQYfyOPn7W0pDt
         8Qcw==
X-Gm-Message-State: AOAM531H66dNK8tm1VEhZ2JywGzLceRKaH1wT9f7wTWOz0Nb88D242o1
        3Y0N3g1lUbJlOVytOxs/jVIB2A==
X-Google-Smtp-Source: ABdhPJydtoDgmtfFU7iCvzmfD+6LAiNa/sBr8PkQ4fFuCRed3yo4/Qn+wZAYqYuVMFMYpSUN+dNGhA==
X-Received: by 2002:aa7:8e56:0:b029:3cd:c2ec:6c1c with SMTP id d22-20020aa78e560000b02903cdc2ec6c1cmr16390211pfr.80.1629412788706;
        Thu, 19 Aug 2021 15:39:48 -0700 (PDT)
Received: from localhost ([2001:4479:e000:e400:3a83:f47e:d5a3:378a])
        by smtp.gmail.com with ESMTPSA id x69sm4639869pfc.59.2021.08.19.15.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:39:48 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        kernel-janitors@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] powerpc: kvm: remove obsolete and unneeded select
In-Reply-To: <20210819113954.17515-2-lukas.bulwahn@gmail.com>
References: <20210819113954.17515-1-lukas.bulwahn@gmail.com>
 <20210819113954.17515-2-lukas.bulwahn@gmail.com>
Date:   Fri, 20 Aug 2021 08:39:45 +1000
Message-ID: <87sfz59hzi.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Lukas,

> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index e45644657d49..ff581d70f20c 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -38,7 +38,6 @@ config KVM_BOOK3S_32_HANDLER
>  config KVM_BOOK3S_64_HANDLER
>  	bool
>  	select KVM_BOOK3S_HANDLER
> -	select PPC_DAWR_FORCE_ENABLE

I looked at some of the history here. It looks like this select was left
over from an earlier version of the patch series that added PPC_DAWR: v2
of the series has a new symbol PPC_DAWR_FORCE_ENABLE but by version 4
that new symbol had disappeared but the select had not.

v2: https://lore.kernel.org/linuxppc-dev/20190513071703.25243-1-mikey@neuling.org/
v5: https://lore.kernel.org/linuxppc-dev/20190604030037.9424-2-mikey@neuling.org/

The rest of the patch reasoning makes sense to me: DAWR support will be
selected anyway by virtue of PPC64->PPC_DAWR so there's no need to try
to select it again anyway.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

>  
>  config KVM_BOOK3S_PR_POSSIBLE
>  	bool
> -- 
> 2.26.2
