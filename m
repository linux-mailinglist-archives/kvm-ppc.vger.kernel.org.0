Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACC731F4F8
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhBSGDq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBSGDq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:03:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC4DC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:03:05 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a24so2761383plm.11
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=MYyTS1/wjznlU/v9GaBg3e/Ma7dOx08FztPRQ5y5qlE=;
        b=Hq1q4ynuFCz5blo4G1nrCE1FA13tIsGAEcqU0lkN+k4W33oAYkmmQHgOCa7bNXvVbd
         MVjfvll4LGVIGCtuqQdROagYlmtiviaFMc2bRxgJw0yyhYFnAbYHww770ei2jfiZ6aUP
         y4Nd4OpUHDs/Z7O1NUhr60eM5CWx0rfOt4H38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MYyTS1/wjznlU/v9GaBg3e/Ma7dOx08FztPRQ5y5qlE=;
        b=Vut9MbhxzqoneVksH00l2vCOm5n1DoNfA9yhuJZyc4bKkgTW6yJW0StMscBpbcFdms
         q5OJLYnnMA8oG1gS+6X1tGR3vzTqLSMJDTOjsb4XASBkxnc4KqQYM21TN3xtBK9t9Wk/
         s8FhwUfZoszrxxAMje8sC1GCA6QHWRFMFmIl4G7lk7b9UEERTHSAEFFOEx8e90eOwlu2
         CGaput826an/UfP/BLcJ4hMxfdB1c0Qbihub5C55xuydPs3u/IRAHI+SsjX1MHCTZpSd
         RGecBuAumcgmhtJHjpvUQi4BrMaw6YwRBoTL8s877cJRFiFSHf6d3SfsQdPmLihyeSR5
         +eCw==
X-Gm-Message-State: AOAM5303wGdrLyeggL/1TbF40YKC68HVIJrOMsGnrQqCcZD0BHDyB4i/
        w4djaeDwGBYCBJNPj/QIRD5AVw==
X-Google-Smtp-Source: ABdhPJzvWi0zCztT5Olu5NZaIhs7oxY5snfk/RG6lqe8acnTTpe3q8ceVFCVTXQx18S9P+ZpZ3y0ug==
X-Received: by 2002:a17:90b:e83:: with SMTP id fv3mr7686838pjb.204.1613714585297;
        Thu, 18 Feb 2021 22:03:05 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id p18sm8336399pfn.178.2021.02.18.22.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:03:04 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC PATCH 2/9] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
In-Reply-To: <20210202030313.3509446-3-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com> <20210202030313.3509446-3-npiggin@gmail.com>
Date:   Fri, 19 Feb 2021 17:03:01 +1100
Message-ID: <87lfbka92i.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> +maybe_skip:
> +	cmpwi	r12,0x200
> +	beq	1f
> +	cmpwi	r12,0x300
> +	beq	1f
> +	cmpwi	r12,0x380
> +	beq	1f
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	/* XXX: cbe stuff? instruction breakpoint? */
> +	cmpwi	r12,0xe02
> +	beq	2f
> +#endif
> +	b	no_skip
> +1:	mfspr	r9,SPRN_SRR0
> +	addi	r9,r9,4
> +	mtspr	SPRN_SRR0,r9
> +	ld	r12,HSTATE_SCRATCH0(r13)
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	GET_SCRATCH0(r13)
> +	RFI_TO_KERNEL
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +2:	mfspr	r9,SPRN_HSRR0
> +	addi	r9,r9,4
> +	mtspr	SPRN_HSRR0,r9
> +	ld	r12,HSTATE_SCRATCH0(r13)
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	GET_SCRATCH0(r13)
> +	HRFI_TO_KERNEL
> +#endif

If I understand correctly, label 1 is the kvmppc_skip_interrupt and
label 2 is the kvmppc_skip_Hinterrupt. Would it be easier to understand
if we used symbolic labels, or do you think the RFI_TO_KERNEL vs
HRFI_TO_KERNEL and other changes are sufficient?

Apart from that, I haven't checked the precise copy-paste to make sure
nothing has changed by accident, but I am able to follow the general
idea of the patch and am vigorously in favour of anything that
simplifies our exception/interrupt paths!

Kind regards,
Daniel

> -- 
> 2.23.0
